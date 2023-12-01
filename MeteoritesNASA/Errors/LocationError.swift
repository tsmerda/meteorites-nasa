//
//  LocationError.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 01.12.2023.
//

import Foundation

enum LocationError: Error {
    case permissionDenied
    case permissionNotDetermined
    case locationUnavailable
}
