//
//  Geolocation.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import Foundation

struct Geolocation: Codable, Hashable {
    let latitude: String?
    let longitude: String?
    
    public init(
        latitude: String? = "0.0",
        longitude: String? = "0.0"
    ) {
        self.latitude = latitude
        self.longitude = longitude
    }
}


// MARK: - Meteorite example
#if DEBUG
extension Geolocation {
    static var example: Geolocation {
        Geolocation(
            latitude: "50.775",
            longitude: "6.08333"
        )
    }
}
#endif
