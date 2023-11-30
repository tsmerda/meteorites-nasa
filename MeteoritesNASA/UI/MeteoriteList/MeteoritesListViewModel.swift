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
    @Published private(set) var progressHudState: ProgressHudState = .shouldHideProgress
    @Published var searchText: String = ""
    @Published var searchIsActive: Bool = false
    
    private let networkManager: NetworkManagerProtocol
    private let fileManager = FileManager.default
    private let localDataFile = GlobalConstants.localDataFile
    private let lastUpdateKey = GlobalConstants.lastUpdateKey
    private let networkMonitor = NWPathMonitor()
    private var isInternetAvailable: Bool = false
    
    var searchResults: [Meteorite] {
        if searchText.isEmpty {
            return meteoritesList
        } else {
            return meteoritesList.filter { $0.name.contains(searchText) }
        }
    }
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
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
    
    func findNearestMeteorites() {
        showNearest.toggle()
        if showNearest {
            let sortedByDistance = self.meteoritesList.sorted {
                self.distanceFromUser(to: $0) < self.distanceFromUser(to: $1)
            }
            nearestMeteorites = Array(sortedByDistance.prefix(10))
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
        getAllMeteorites()
    }
}

// MARK: -- Private methods

private extension MeteoritesListViewModel {
    func handleInitialData() {
        startNetworkMonitoring()
    }
    
    func loadMeteoritesData() {
        if shouldUpdateData() && isInternetAvailable {
            getAllMeteorites()
        } else {
            loadDataFromLocalStorage()
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
    
    func loadDataFromLocalStorage() {
        Task { @MainActor in
            progressHudState = .shouldShowProgress
            let url = getDocumentsDirectory().appendingPathComponent(localDataFile)
            if let data = try? Data(contentsOf: url) {
                do {
                    meteoritesList = try JSONDecoder().decode([Meteorite].self, from: data)
                } catch {
                    progressHudState = .shouldShowFail(message: error.localizedDescription)
                }
            }
            progressHudState = .shouldHideProgress
        }
    }
    
    func distanceFromUser(to meteorite: Meteorite) -> Double {
        guard let userLocation = LocationManager.shared.userLocation,
              let latitudeString = meteorite.geolocation?.latitude,
              let longitudeString = meteorite.geolocation?.longitude,
              let latitude = Double(latitudeString),
              let longitude = Double(longitudeString) else {
            return Double.greatestFiniteMagnitude
        }
        
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let meteoriteCLLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        return userCLLocation.distance(from: meteoriteCLLocation)
    }
}

// MARK: -- Network methods

private extension MeteoritesListViewModel {
    func getAllMeteorites() {
        Task { @MainActor in
            progressHudState = .shouldShowProgress
            do {
                let data = try await networkManager.getAllMeteorites()
                meteoritesList = data
                try await saveDataToLocalStorage(data)
                progressHudState = .shouldHideProgress
            } catch {
                progressHudState = .shouldShowFail(message: error.localizedDescription)
            }
        }
    }
}