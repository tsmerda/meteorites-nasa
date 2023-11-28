//
//  DateFormatExtensionTests.swift
//  MeteoritesNASATests
//
//  Created by Tomáš Šmerda on 28.11.2023.
//

import XCTest
@testable import MeteoritesNASA

class StringExtensionTests: XCTestCase {
    func testCorrectDateFormatConversion() {
        let dateString = "2023-01-01T12:30:00.000"
        let formattedDate = dateString.toFormattedDate(
            inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS",
            outputFormat: "d. MMM yyyy",
            locale: "en_US"
        )
        XCTAssertEqual(formattedDate, "1. Jan 2023")
    }
    
    func testIncorrectDateFormat() {
        let dateString = "NotADate"
        let formattedDate = dateString.toFormattedDate(
            inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS",
            outputFormat: "d. MMM yyyy",
            locale: "en_US"
        )
        XCTAssertNil(formattedDate)
    }
    
    func testDifferentLocale() {
        let dateString = "2023-01-01T12:30:00.000"
        let formattedDate = dateString.toFormattedDate(
            inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS",
            outputFormat: "d. MMM yyyy",
            locale: "cs_CZ"
        )
        XCTAssertEqual(formattedDate, "1. led 2023")
    }
    
    func testIsoDateTimeToStandardDateFormatConversion() {
        let dateString = "2023-01-01T12:30:00.000"
        let formattedDate = dateString.toFormattedDate(
            inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS",
            outputFormat: "d MMM, yyyy",
            locale: "en_US"
        )
        XCTAssertEqual(formattedDate, "1 Jan, 2023")
    }
    
    func testIsoDateTimeToFullDateFormatConversion() {
        let dateString = "2023-01-01T12:30:00.000"
        let formattedDate = dateString.toFormattedDate(
            inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS",
            outputFormat: "EEEE, MMMM d, yyyy",
            locale: "en_US"
        )
        XCTAssertEqual(formattedDate, "Sunday, January 1, 2023")
    }
    
    func testIsoDateTimeWithDifferentLocale() {
        let dateString = "2023-01-01T12:30:00.000"
        let formattedDate = dateString.toFormattedDate(
            inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS",
            outputFormat: "d. MMMM yyyy", 
            locale: "cs_CZ"
        )
        XCTAssertEqual(formattedDate, "1. ledna 2023")
    }
}
