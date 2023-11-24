//
//  NetworkError.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import Foundation

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case serverError
    case invalidData
    case serverResponseError(String)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please check the URL and try again."
        case .serverError:
            return "There was an error with the server. Please try again later."
        case .invalidData:
            return "Invalid data received from the server. Please try again."
        case .serverResponseError(let message):
            return message
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
