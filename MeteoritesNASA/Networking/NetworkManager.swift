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

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private let baseURL = "https://data.nasa.gov"
    
    // MARK: - Get all meteorites
    func getAllMeteorites() async throws -> [Meteorite] {
        guard let url  = URL(string: baseURL + "/resource/y77d-th95.json") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        // print(String(decoding: data, as: UTF8.self))
        
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
