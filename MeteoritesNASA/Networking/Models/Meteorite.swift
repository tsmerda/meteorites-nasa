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
    let nametype: String?
    let recclass: String?
    let mass: String?
    let fall: String?
    let year: String?
    let reclat: String?
    let reclong: String?
    let geolocation: Geolocation?
    
    public init(
        name: String,
        id: String,
        nametype: String? = "",
        recclass: String? = "",
        mass: String? = "",
        fall: String? = "",
        year: String? = "",
        reclat: String? = "",
        reclong: String? = "",
        geolocation: Geolocation? = nil
    ) {
        self.name = name
        self.id = id
        self.nametype = nametype
        self.recclass = recclass
        self.mass = mass
        self.fall = fall
        self.year = year
        self.reclat = reclat
        self.reclong = reclong
        self.geolocation = geolocation
    }
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
    static var exampleList: [Meteorite] {[
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
            geolocation: Geolocation(
                type: "Point",
                coordinates: [
                    6.08333,
                    50.775
                ]
            )
        ),
        Meteorite(
            name: "Aarhus",
            id: "2",
            nametype: "Valid",
            recclass: "H6",
            mass: "720",
            fall: "Fell",
            year: "1951-01-01T00:00:00.000",
            reclat: "56.183330",
            reclong: "10.233330",
            geolocation: Geolocation(
                type: "Point",
                coordinates: [
                    10.23333,
                    56.18333
                ]
            )
        ),
        Meteorite(
            name: "Abee",
            id: "6",
            nametype: "Valid",
            recclass: "EH4",
            mass: "107000",
            fall: "Fell",
            year: "1952-01-01T00:00:00.000",
            reclat: "54.216670",
            reclong: "-113.000000",
            geolocation: Geolocation(
                type: "Point",
                coordinates: [
                    -113,
                     54.21667
                ]
            )
        ),
        Meteorite(
            name: "Akyumak",
            id: "433",
            nametype: "Valid",
            recclass: "Iron, IVA",
            mass: "50000",
            fall: "Fell",
            year: "1981-01-01T00:00:00.000",
            reclat: "39.916670",
            reclong: "42.816670",
            geolocation: Geolocation(
                type: "Point",
                coordinates: [
                    42.81667,
                    39.91667
                ]
            )
        )
    ]}
}
#endif
