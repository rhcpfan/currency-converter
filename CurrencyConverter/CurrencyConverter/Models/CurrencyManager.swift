//
//  CurrencyManager.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 22/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import Foundation

class CurrencyManager {

    // MARK: - Singleton instance -

    /// Singleton instance.
    static let shared = CurrencyManager()

    // MARK: - Instance Properties -

    /// Stores all the currencies available from the provider API.
    /// Useful to avoid computing the currency details every time (country code, flag symbol, etc.).
    var allCurrencies: [Currency] = []

    // MARK: - Initializers -

    private init() { }
}
