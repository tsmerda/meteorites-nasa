//
//  MeteoriteListTests.swift
//  MeteoritesNASATests
//
//  Created by Tomáš Šmerda on 28.11.2023.
//

import XCTest
import Combine
@testable import MeteoritesNASA

final class MeteoriteListTests: XCTestCase {
    var viewModel: MeteoritesListViewModel!
    var mockNetworkManager: MockNetworkManager!
    var mockLocationManager: MockLocationManager!
    var subscriptions: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockLocationManager = MockLocationManager()
        viewModel = MeteoritesListViewModel(
            networkManager: mockNetworkManager,
            locationManager: mockLocationManager
        )
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: GlobalConstants.lastUpdateKey)
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func testSaveDataToLocalStorage() async throws {
        try await viewModel.saveDataToLocalStorage(Meteorite.exampleList)
        let savedData = try Data(contentsOf: viewModel.getDocumentsDirectory().appendingPathComponent(GlobalConstants.localDataFile))
        let decodedSavedData = try JSONDecoder().decode([Meteorite].self, from: savedData)
        XCTAssertEqual(decodedSavedData, Meteorite.exampleList, "Saved data should match the mock data")
        let lastUpdateDate = UserDefaults.standard.object(forKey: GlobalConstants.lastUpdateKey) as? Date
        XCTAssertNotNil(lastUpdateDate, "Last update date should be set in UserDefaults")
    }
    
    func testLoadDataWithSuccess() {
        let expectation = XCTestExpectation(description: "Data is loaded")
        viewModel = MeteoritesListViewModel(
            networkManager: MockNetworkManager(),
            locationManager: mockLocationManager
        )
        
        viewModel.$meteoritesList
            .dropFirst()
            .sink { meteorites in
                XCTAssertFalse(meteorites.isEmpty, "Meteorites list should not be empty")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        viewModel.refreshData()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadDataWithEmptyData() {
        let expectation = XCTestExpectation(description: "Data is empty")
        viewModel = MeteoritesListViewModel(
            networkManager: MockNetworkManagerEmpty(),
            locationManager: mockLocationManager
        )
        
        viewModel.$meteoritesList
            .dropFirst()
            .sink { meteorites in
                XCTAssertTrue(meteorites.isEmpty, "Meteorites list should be empty")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        viewModel.refreshData()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadDataWithError() {
        let expectation = XCTestExpectation(description: "Data loading failed")
        viewModel = MeteoritesListViewModel(
            networkManager: MockNetworkManagerFailure(),
            locationManager: mockLocationManager
        )
        
        viewModel.$progressHudState
            .dropFirst()
            .sink { state in
                if case .showFailure(let message) = state {
                    XCTAssertNotNil(message)
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        viewModel.refreshData()
        wait(for: [expectation], timeout: 1.0)
    }
}
