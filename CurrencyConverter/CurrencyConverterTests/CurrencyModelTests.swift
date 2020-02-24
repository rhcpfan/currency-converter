//
//  CurrencyModelTests.swift
//  CurrencyConverterTests
//
//  Created by Andrei Ciobanu on 23/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import XCTest
@testable import CurrencyConverter

class CurrencyModelTests: XCTestCase {

    func testCurrencyInitialization() {
        let ronCurrency = Currency(code: "RON")
        XCTAssertEqual(ronCurrency.countryCode, "RO")
        XCTAssertEqual(ronCurrency.flagSymbol, "🇷🇴")
        let usdCurrency = Currency(code: "USD")
        XCTAssertEqual(usdCurrency.countryCode, "US")
        XCTAssertEqual(usdCurrency.symbol, "US$")
        XCTAssertEqual(usdCurrency.flagSymbol, "🇺🇸")
        let eurCurrency = Currency(code: "EUR")
        XCTAssertEqual(eurCurrency.countryCode, "EU")
        XCTAssertEqual(eurCurrency.symbol, "€")
        XCTAssertEqual(eurCurrency.flagSymbol, "🇪🇺")
    }

    func testCurrencyEquality() {
        let firstRonCurrency = Currency(code: "RON", value: 1)
        let secondRonCurrency = Currency(code: "RON", value: 1)
        let thirdRonCurrency = Currency(code: "RON", value: 2)
        let usdCurrency = Currency(code: "USD", value: 1)

        XCTAssertNotEqual(firstRonCurrency, usdCurrency)
        XCTAssertEqual(firstRonCurrency, secondRonCurrency)
        XCTAssertNotEqual(firstRonCurrency, thirdRonCurrency)
    }

}
