//
//  MapViewModel.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 25.11.2023.
//

import Foundation
import MapKit

final class MapViewModel: ObservableObject {
    let title: String
    let geolocation: Geolocation?
    let nearestMeteorites: [Meteorite]?
    let goBackAction: () -> Void
    private let onSelectMeteoriteAction: ((Meteorite) -> Void)?
    let locationManager: LocationManager
    
    var selectedMeteorite: Meteorite? = nil
    
    init(
        title: String,
        geolocation: Geolocation? = nil,
        nearestMeteorites: [Meteorite]? = nil,
        goBackAction: @escaping () -> Void,
        onSelectMeteoriteAction: ((Meteorite) -> Void)?,
        locationManager: LocationManager
    ) {
        self.title = title
        self.geolocation = geolocation
        self.nearestMeteorites = nearestMeteorites
        self.goBackAction = goBackAction
        self.onSelectMeteoriteAction = onSelectMeteoriteAction
        self.locationManager = locationManager
    }
    
    func getMeteoritePosition() -> MKMapItem? {
        if let latitudeString = geolocation?.latitude,
           let longitudeString = geolocation?.longitude,
           let latitude = Double(latitudeString),
           let longitude = Double(longitudeString) {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let placemark = MKPlacemark(coordinate: coordinate)
            return MKMapItem(placemark: placemark)
        }
        return nil
    }
    
    func onSelectMeteorite(_ meteorite: Meteorite) {
        selectedMeteorite = meteorite
        onSelectMeteoriteAction?(meteorite)
    }
    
    func handleUserLocation() -> Bool {
        switch locationManager.status {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        case .restricted, .denied, .notDetermined:
            return false
        @unknown default:
            return false
        }
    }
}
