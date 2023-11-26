//
//  MeteoriteDetailViewModel.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 25.11.2023.
//

import Foundation
import CoreLocation

final class MeteoriteDetailViewModel: ObservableObject {
    let meteorite: Meteorite
    @Published private(set) var progressHudState: ProgressHudState = .shouldHideProgress
    
    init(meteorite: Meteorite) {
        self.meteorite = meteorite
    }
    
//    func getUserDistanceFromMeteorite() -> String {
//        guard let userCoordinates = LocationManager.shared.userLocation,
//              let meteoriteCoordinates = meteorite.geolocation?.coordinates else {
//            return "Unknown distance"
//        }
//        
//        let userLocation = CLLocation(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude)
//        let meteoriteLocation = CLLocation(latitude: meteoriteCoordinates[1], longitude: meteoriteCoordinates[0])
//        
//        let distanceInMeters = userLocation.distance(from: meteoriteLocation)
//        return String(format: "%.2f meters", distanceInMeters)
//    }
}
