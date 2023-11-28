//
//  MeteoriteListTests.swift
//  MeteoritesNASATests
//
//  Created by Tomáš Šmerda on 28.11.2023.
//

import XCTest
@testable import MeteoritesNASA

class MeteoriteListTests: XCTestCase {
    var viewModel: MeteoritesListViewModel!
    var mockMeteorites: [Meteorite]!
    
    override func setUp() {
        super.setUp()
        viewModel = MeteoritesListViewModel()
        mockMeteorites = [
            Meteorite(
                name: "Aachen",
                id: "1",
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
                geolocation: Geolocation(
                    type: "Point",
                    coordinates: [
                        10.23333,
                        56.18333
                    ]
                )
            )
        ]
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: GlobalConstants.lastUpdateKey)
        viewModel = nil
        mockMeteorites = nil
        super.tearDown()
    }
    
    func testShouldUpdateData() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        UserDefaults.standard.set(yesterday, forKey: GlobalConstants.lastUpdateKey)
        
        let shouldUpdate = viewModel.shouldUpdateData()
        XCTAssertTrue(shouldUpdate)
    }
    
    func testSaveDataToLocalStorage() async throws {
        try await viewModel.saveDataToLocalStorage(mockMeteorites)
        let savedData = try Data(contentsOf: viewModel.getDocumentsDirectory().appendingPathComponent(GlobalConstants.localDataFile))
        let decodedSavedData = try JSONDecoder().decode([Meteorite].self, from: savedData)
        XCTAssertEqual(decodedSavedData, mockMeteorites, "Saved data should match the mock data")
        let lastUpdateDate = UserDefaults.standard.object(forKey: GlobalConstants.lastUpdateKey) as? Date
        XCTAssertNotNil(lastUpdateDate, "Last update date should be set in UserDefaults")
    }
}
