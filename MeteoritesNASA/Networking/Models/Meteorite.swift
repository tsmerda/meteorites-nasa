//
//  Meteorite.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import Foundation

struct Meteorite: Identifiable, Codable {
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
