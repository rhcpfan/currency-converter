//
//  ExchangeRateTests.swift
//  CurrencyConverterTests
//
//  Created by Andrei Ciobanu on 23/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import XCTest
@testable import CurrencyConverter

class ExchangeRateTests: XCTestCase {

    func testExchangeRateDecodingWithValidData() throws {

        let mockJsonResponse = """
            {
              "rates": {
                "RON": 4.804,
                "USD": 1.0801,
                "GBP": 0.8351
              },
              "base": "EUR",
              "date": "2020-02-21"
            }
        """

        let jsonData = try XCTUnwrap(mockJsonResponse.data(using: .utf8))
        XCTAssertNoThrow(try JSONDecoder().decode(ExchangeRate.self, from: jsonData))
    }

    func testExchangeRateDecodingWithInvalidData() throws {

        let mockJsonResponse = """
            {
              "rates": {
                "RON": 4.804,
                "USD": 1.0801,
                "GBP": 0.8351
              },
              "date": "2020-02-21"
            }
        """

        let jsonData = try XCTUnwrap(mockJsonResponse.data(using: .utf8))
        XCTAssertThrowsError(try JSONDecoder().decode(ExchangeRate.self, from: jsonData))
    }
}
