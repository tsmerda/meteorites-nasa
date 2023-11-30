//
//  MeteoriteInfoModalViewModel.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 25.11.2023.
//

import Foundation
import CoreLocation
import MapKit

final class MeteoriteInfoModalViewModel: ObservableObject {
    let meteorite: Meteorite?
    let withRouteButton: Bool
    private let onNavigateAction: (() -> Void)?
    private let onCancelNavigationAction: (() -> Void)?
    private let locationManager: LocationManager
    
    init(
        meteorite: Meteorite?,
        withRouteButton: Bool = false,
        onNavigateAction: (() -> Void)?,
        onCancelNavigationAction: (() -> Void)?,
        locationManager: LocationManager
    ) {
        self.meteorite = meteorite
        self.withRouteButton = withRouteButton
        self.onNavigateAction = onNavigateAction
        self.onCancelNavigationAction = onCancelNavigationAction
        self.locationManager = locationManager
    }
    
    func onNavigate() {
        onNavigateAction?()
    }
    
    func onCancelNavigation() {
        onCancelNavigationAction?()
    }
    
    func getFormattedMass() -> String? {        
        guard let massStr = meteorite?.mass, let massValue = Double(massStr) else {
            return nil
        }
        if massValue >= 1000 {
            let kgValue = massValue / 1000.0
            if floor(kgValue) == kgValue {
                return "\(Int(kgValue)) \(L.MeteoriteInfoModal.kilograms)"
            } else {
                return String(format: "%.2f \(L.MeteoriteInfoModal.kilograms)", kgValue)
            }
        } else {
            return "\(Int(massValue)) \(L.MeteoriteInfoModal.grams)"
        }
    }
    
    func getFormattedYear() -> String? {
        return meteorite?.year?.toFormattedDate(outputFormat: "d. MMMM yyyy")
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
        guard let userCoordinates = locationManager.userLocation,
              let latitudeString = meteorite?.geolocation?.latitude,
              let longitudeString = meteorite?.geolocation?.longitude,
              let latitude = Double(latitudeString),
              let longitude = Double(longitudeString) else {
            return L.Generic.unknown
        }
        
        let userLocation = CLLocation(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude)
        let meteoriteLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        let distanceInKilometers = userLocation.distance(from: meteoriteLocation) / 1000
        return String(format: "%.2f \(L.MeteoriteInfoModal.kilometers)", distanceInKilometers)
    }
    
    func openInMaps() {
        guard let latitude = meteorite?.reclat, let longitude = meteorite?.reclong,
              let lat = Double(latitude), let lon = Double(longitude) else {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = meteorite?.name
        mapItem.openInMaps(launchOptions: nil)
    }
}
