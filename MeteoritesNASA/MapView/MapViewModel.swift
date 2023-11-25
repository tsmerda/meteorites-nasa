//
//  MapViewModel.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 25.11.2023.
//

import Foundation

final class MapViewModel: ObservableObject {
    let geolocation: Geolocation
    
    init(geolocation: Geolocation) {
        self.geolocation = geolocation
    }
}
