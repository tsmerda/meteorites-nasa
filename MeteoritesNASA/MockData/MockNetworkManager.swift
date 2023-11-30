//
//  MockNetworkManager.swift
//  MeteoritesNASA
//
//  Created by Tomáš Šmerda on 30.11.2023.
//

import Foundation

class MockNetworkManager: NetworkManagerProtocol {
    func getAllMeteorites() async throws -> [Meteorite] {
        Meteorite.exampleList
    }
    
}

class MockNetworkManagerEmpty: NetworkManagerProtocol {
    func getAllMeteorites() async throws -> [Meteorite] {
        return []
    }
}

class MockNetworkManagerFailure: NetworkManagerProtocol {
    func getAllMeteorites() async throws -> [Meteorite] {
        throw NetworkError.serverError
    }
}
