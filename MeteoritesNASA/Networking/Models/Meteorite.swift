//
//  Meteorite.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import Foundation

struct Meteorite: Identifiable, Codable, Hashable {
    let name: String
    let id: String
    let nametype: String
    let recclass: String
    let mass: String?
    let fall: String
    let year: String?
    let reclat: String?
    let reclong: String?
    let geolocation: Geolocation?
}

// MARK: - Meteorite example
#if DEBUG
extension Meteorite {
    static var example: Meteorite {
        Meteorite(
            name: "Aachen",
            id: "1",
            nametype: "Valid",
            recclass: "L5",
            mass: "21",
            fall: "Fell",
            year: "1880-01-01T00:00:00.000",
            reclat: "50.775000",
            reclong: "6.083330",
            geolocation: Geolocation.example
        )
    }
}
#endif
