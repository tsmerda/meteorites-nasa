//
//  NetworkError.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case serverError
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return L.Error.invalidUrl
        case .serverError:
            return L.Error.serverError
        case .invalidData:
            return L.Error.invalidData
        }
    }
}
