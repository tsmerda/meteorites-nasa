//
//  MeteoriteListTests.swift
//  MeteoritesNASATests
//
//  Created by Tomáš Šmerda on 28.11.2023.
//

import XCTest
@testable import MeteoritesNASA

final class MeteoriteListTests: XCTestCase {
    var viewModel: MeteoritesListViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = MeteoritesListViewModel(networkManager: mockNetworkManager)
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
        viewModel = MeteoritesListViewModel(networkManager: MockNetworkManager())
        
        viewModel.refreshData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.viewModel.meteoritesList.isEmpty, "Meteorites list should not be empty")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testLoadDataWithEmptyData() {
        let expectation = XCTestExpectation(description: "Data is empty")
        viewModel = MeteoritesListViewModel(networkManager: MockNetworkManagerEmpty())
        
        viewModel.refreshData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.viewModel.meteoritesList.isEmpty, "Meteorites list should be empty")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testLoadDataWithError() {
        let expectation = XCTestExpectation(description: "Data loading failed")
        viewModel = MeteoritesListViewModel(networkManager: MockNetworkManagerFailure())
        
        viewModel.refreshData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if case .shouldShowFail(let message) = self.viewModel.progressHudState {
                XCTAssertNotNil(message, "Error message should be present")
                expectation.fulfill()
            } else {
                XCTFail("Expected failure state not reached")
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
