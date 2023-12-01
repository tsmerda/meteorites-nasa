//
//  MeteoritesListViewModel.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import Foundation
import CoreLocation
import Network

final class MeteoritesListViewModel: ObservableObject {
    @Published var meteoritesList: [Meteorite] = []
    @Published var nearestMeteorites: [Meteorite] = []
    @Published var showNearest: Bool = false
    @Published private(set) var progressHudState: ProgressHudState = .hide
    @Published var searchText: String = ""
    @Published var searchIsActive: Bool = false
    
    let locationManager: LocationManager
    private let networkManager: NetworkManagerProtocol
    private let fileManager = FileManager.default
    private let localDataFile = GlobalConstants.localDataFile
    private let lastUpdateKey = GlobalConstants.lastUpdateKey
    private let networkMonitor = NWPathMonitor()
    private var isInternetAvailable: Bool = false
    private var isInitialLoad = true
    
    var searchResults: [Meteorite] {
        if searchText.isEmpty {
            return meteoritesList
        } else {
            return meteoritesList.filter { $0.name.contains(searchText) }
        }
    }
    
    init(
        networkManager: NetworkManagerProtocol,
        locationManager: LocationManager
    ) {
        self.networkManager = networkManager
        self.locationManager = locationManager
        handleInitialData()
    }
    
    deinit {
        networkMonitor.cancel()
    }
    
    func formattedMass(_ mass: String?) -> String? {
        guard let massStr = mass, let massValue = Double(massStr) else {
            return nil
        }
        if massValue >= 1000 {
            let kgValue = massValue / 1000.0
            if floor(kgValue) == kgValue {
                return "\(Int(kgValue)) kg"
            } else {
                return String(format: "%.2f kg", kgValue)
            }
        } else {
            return "\(Int(massValue)) g"
        }
    }
    
    func findNearestMeteorites(completion: @escaping (Result<[Meteorite], LocationError>) -> Void) {
        switch locationManager.status {
        case .notDetermined:
            locationManager.requestLocationPermission()
            completion(.failure(.permissionNotDetermined))
        case .authorizedWhenInUse, .authorizedAlways:
            if let userLocation = locationManager.userLocation {
                sortAndFindNearestMeteorites(userLocation: userLocation, completion: completion)
            } else {
                completion(.failure(.locationUnavailable))
            }
        default:
            completion(.failure(.permissionDenied))
        }
    }
    
    func shouldUpdateData() -> Bool {
        guard let lastUpdate = UserDefaults.standard.object(forKey: lastUpdateKey) as? Date else {
            return true
        }
        return !Calendar.current.isDateInToday(lastUpdate)
    }
    
    func saveDataToLocalStorage(_ data: [Meteorite]) async throws {
        let url = getDocumentsDirectory().appendingPathComponent(localDataFile)
        let data = try JSONEncoder().encode(data)
        try data.write(to: url)
        UserDefaults.standard.set(Date(), forKey: lastUpdateKey)
    }
    
    func getDocumentsDirectory() -> URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func refreshData() {
        Task {
            await getAllMeteorites(showProgress: false)
        }
    }
}

// MARK: -- Private methods

private extension MeteoritesListViewModel {
    func handleInitialData() {
        startNetworkMonitoring()
    }
    
    func loadMeteoritesData() {
        Task {
            if shouldUpdateData() && isInternetAvailable {
                await getAllMeteorites(showProgress: true)
            } else {
                await loadDataFromLocalStorage()
            }
        }
    }
    
    func startNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isInternetAvailable = path.status == .satisfied
                self?.loadMeteoritesData()
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        networkMonitor.start(queue: queue)
    }
    
    func loadDataFromLocalStorage() async {
        await MainActor.run {
            progressHudState = .showProgress
        }
        let url = getDocumentsDirectory().appendingPathComponent(localDataFile)
        if let data = try? Data(contentsOf: url) {
            do {
                let meteoritesResponse = try JSONDecoder().decode([Meteorite].self, from: data)
                await MainActor.run {
                    meteoritesList = meteoritesResponse
                    progressHudState = .hide
                }
            } catch {
                await MainActor.run {
                    progressHudState = .showFailure(message: error.localizedDescription)
                }
            }
        }
    }
    
    func sortAndFindNearestMeteorites(
        userLocation: CLLocationCoordinate2D,
        completion: (Result<[Meteorite], LocationError>) -> Void
    ) {
        let sortedByDistance = meteoritesList.sorted {
            distanceFromUser(to: $0, userLocation: userLocation) < distanceFromUser(to: $1, userLocation: userLocation)
        }
        
        nearestMeteorites = Array(sortedByDistance.prefix(10))
        completion(.success(nearestMeteorites))
    }
    
    private func distanceFromUser(to meteorite: Meteorite, userLocation: CLLocationCoordinate2D) -> Double {
        guard let latitudeString = meteorite.geolocation?.latitude,
              let longitudeString = meteorite.geolocation?.longitude,
              let latitude = Double(latitudeString),
              let longitude = Double(longitudeString) else {
            return Double.greatestFiniteMagnitude
        }
        
        let meteoriteLocation = CLLocation(latitude: latitude, longitude: longitude)
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        return userCLLocation.distance(from: meteoriteLocation)
    }
}

// MARK: -- Network methods

private extension MeteoritesListViewModel {
    func getAllMeteorites(showProgress: Bool) async {
        await MainActor.run {
            if showProgress {
                self.progressHudState = .showProgress
            }
        }
        do {
            let meteoritesResponse = try await networkManager.getAllMeteorites()
            try await self.saveDataToLocalStorage(meteoritesResponse)
            await MainActor.run {
                self.meteoritesList = meteoritesResponse
                self.progressHudState = .hide
            }
        } catch {
            await MainActor.run {
                self.progressHudState = .showFailure(message: error.localizedDescription)
            }
        }
    }
}
