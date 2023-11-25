//
//  Geolocation.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import Foundation

struct Geolocation: Codable {
    let type: String
    let coordinates: [Double]
}

// MARK: - Meteorite example
#if DEBUG
extension Geolocation {
    static var example: Geolocation {
        Geolocation(
            type: "Point",
            coordinates: [
                6.08333,
                50.775
            ]
        )
    }
}
#endif
