//
//  NetworkManager.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 24.11.2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func getAllMeteorites() async throws -> [Meteorite]
}

final class NetworkManager: NetworkManagerProtocol {
    private let baseURL = "https://data.nasa.gov"
    
    // MARK: - Get all meteorites
    func getAllMeteorites() async throws -> [Meteorite] {
        guard let url = URL(string: baseURL + "/resource/gh4g-9sfh.json") else {
            throw NetworkError.invalidURL
        }
        
        let config = URLSession.shared.configuration
        config.waitsForConnectivity = true
        
        let (data, response) = try await URLSession(configuration: config).data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.serverError
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let meteorites = try? decoder.decode([Meteorite].self, from: data) else {
            throw NetworkError.invalidData
        }
        
        return meteorites
    }
}
