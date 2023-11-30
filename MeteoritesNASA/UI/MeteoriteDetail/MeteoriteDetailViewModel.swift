//
//  MeteoriteDetailViewModel.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 25.11.2023.
//

import Foundation

final class MeteoriteDetailViewModel: ObservableObject {
    let meteorite: Meteorite
    let locationManager: LocationManager
    
    init(
        meteorite: Meteorite,
        locationManager: LocationManager
    ) {
        self.meteorite = meteorite
        self.locationManager = locationManager
    }
}
