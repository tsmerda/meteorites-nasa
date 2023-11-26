//
//  MeteoriteInfoModalViewModel.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 25.11.2023.
//

import Foundation
import CoreLocation

final class MeteoriteInfoModalViewModel: ObservableObject {
    let meteorite: Meteorite?
    let withRouteButton: Bool
    
    init(
        meteorite: Meteorite?,
        withRouteButton: Bool = false
    ) {
        self.meteorite = meteorite
        self.withRouteButton = withRouteButton
    }
    
    func formattedMass(_ mass: String?) -> String? {
        guard let massStr = mass, let massValue = Double(massStr) else {
            return nil
        }
        if massValue >= 1000 {
            let kgValue = massValue / 1000.0
            if floor(kgValue) == kgValue {
                return "\(Int(kgValue)) kilogramů"
            } else {
                return String(format: "%.2f kilogramů", kgValue)
            }
        } else {
            return "\(Int(massValue)) gramů"
        }
    }
    
    func getCoordinates() -> String? {
        if let latitude = meteorite?.reclat,
           let longitude = meteorite?.reclong {
            return "\(latitude), \(longitude)"
        } else {
            return nil
        }
    }
    
    func getUserDistanceFromMeteorite() -> String {
        guard let userCoordinates = LocationManager.shared.userLocation,
              let meteoriteCoordinates = meteorite?.geolocation?.coordinates else {
            return "Unknown distance"
        }
        
        let userLocation = CLLocation(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude)
        let meteoriteLocation = CLLocation(latitude: meteoriteCoordinates[1], longitude: meteoriteCoordinates[0])
        
        let distanceInKilometers = userLocation.distance(from: meteoriteLocation) / 1000
        return String(format: "%.2f kilometrů", distanceInKilometers)
    }
}
