//
//  FormattedMassTests.swift
//  MeteoritesNASATests
//
//  Created by Tomáš Šmerda on 28.11.2023.
//

import XCTest
@testable import MeteoritesNASA

final class FormattedMassTests: XCTestCase {
    var viewModel: MeteoriteInfoModalViewModel!
    var mockMeteorite: Meteorite!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        viewModel = nil
        mockMeteorite = nil
        super.tearDown()
    }
    
    func testFormattedMassInGrams() {
        mockMeteorite = Meteorite(
            name: "TestMeteorite",
            id: "1",
            mass: "750"
        )
        let viewModel = MeteoriteInfoModalViewModel(
            meteorite: mockMeteorite,
            withRouteButton: false,
            onNavigateAction: nil,
            onCancelNavigationAction: nil
        )
        let mass = viewModel.getFormattedMass()
        XCTAssertEqual(mass, "750 \(L.MeteoriteInfoModal.grams)", "Should correctly format mass in grams")
    }
    
    func testFormattedMassInKilograms() {
        mockMeteorite = Meteorite(
            name: "TestMeteorite",
            id: "1",
            mass: "10500"
        )
        let viewModel = MeteoriteInfoModalViewModel(
            meteorite: mockMeteorite,
            withRouteButton: false,
            onNavigateAction: nil,
            onCancelNavigationAction: nil
        )
        let mass = viewModel.getFormattedMass()
        XCTAssertEqual(mass, "10.50 \(L.MeteoriteInfoModal.kilograms)", "Should correctly format mass in kilograms")
    }
    
    func testFormattedMassExactlyOneKilogram() {
        mockMeteorite = Meteorite(
            name: "TestMeteorite",
            id: "1",
            mass: "1000"
        )
        let viewModel = MeteoriteInfoModalViewModel(
            meteorite: mockMeteorite,
            withRouteButton: false,
            onNavigateAction: nil,
            onCancelNavigationAction: nil
        )
        let mass = viewModel.getFormattedMass()
        XCTAssertEqual(mass, "1 \(L.MeteoriteInfoModal.kilograms)", "Should correctly format mass as 1 kilogram")
    }
}
