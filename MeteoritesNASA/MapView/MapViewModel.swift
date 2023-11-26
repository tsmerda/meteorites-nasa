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
    let geolocation: Geolocation
    let goBackAction: () -> Void
    
    init(
        title: String,
        geolocation: Geolocation,
        goBackAction: @escaping () -> Void
    ) {
        self.title = title
        self.geolocation = geolocation
        self.goBackAction = goBackAction
    }
    
    func getMeteoritePosition() -> MKMapItem {
        let coordinate = CLLocationCoordinate2D(latitude: geolocation.coordinates[1], longitude: geolocation.coordinates[0])
        let placemark = MKPlacemark(coordinate: coordinate)
        return MKMapItem(placemark: placemark)
    }
}
