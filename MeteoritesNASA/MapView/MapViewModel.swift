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
    
    var selectedMeteorite: Meteorite? = nil
    
    init(
        title: String,
        geolocation: Geolocation? = nil,
        nearestMeteorites: [Meteorite]? = nil,
        goBackAction: @escaping () -> Void,
        onSelectMeteoriteAction: ((Meteorite) -> Void)?
    ) {
        self.title = title
        self.geolocation = geolocation
        self.nearestMeteorites = nearestMeteorites
        self.goBackAction = goBackAction
        self.onSelectMeteoriteAction = onSelectMeteoriteAction
    }
    
    func getMeteoritePosition() -> MKMapItem? {
        if let latitude = geolocation?.coordinates[1],
           let longitude = geolocation?.coordinates[0] {
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
}
