//
//  MeteoritesListViewModel.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import Foundation
import CoreLocation

final class MeteoritesListViewModel: ObservableObject {
    @Published var meteoritesList: [Meteorite] = []
    @Published var nearestMeteorites: [Meteorite] = []
    @Published var showNearest: Bool = false
    @Published private(set) var progressHudState: ProgressHudState = .shouldHideProgress
    
    init() {
        getAllMeteorites()
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
}

// MARK: -- Private methods

private extension MeteoritesListViewModel {
    func distanceFromUser(to meteorite: Meteorite) -> Double {
        guard let userLocation = LocationManager.shared.userLocation,
              let meteoriteLat = meteorite.geolocation?.coordinates[1],
              let meteoriteLon = meteorite.geolocation?.coordinates[0] else {
            return Double.greatestFiniteMagnitude
        }
        
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let meteoriteCLLocation = CLLocation(latitude: meteoriteLat, longitude: meteoriteLon)
        
        return userCLLocation.distance(from: meteoriteCLLocation)
    }
}

// MARK: -- Network methods

private extension MeteoritesListViewModel {
    func getAllMeteorites() {
        Task { @MainActor in
            progressHudState = .shouldShowProgress
            do {
                meteoritesList = try await NetworkManager.shared.getAllMeteorites()
                progressHudState = .shouldHideProgress
            } catch {
                progressHudState = .shouldShowFail(message: error.localizedDescription)
            }
        }
    }
}
