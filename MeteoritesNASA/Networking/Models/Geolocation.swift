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
