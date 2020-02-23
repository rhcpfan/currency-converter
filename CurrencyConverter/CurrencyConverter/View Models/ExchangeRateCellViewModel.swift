//
//  ExchangeRateCellViewModel.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 21/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import Foundation

struct ExchangeRateCellViewModel {

    // MARK: - Instance Properties -

    let currencyCode: String
    let currencyFlag: String?
    let currencyName: String?
    /// The value against the base currency.
    var baseToCurrencyValue: String?
    /// The value of the base currency against the currency (`1 / baseToCurrencyValue`).
    var currencyToBaseValue: String?

    // MARK: - Initializer(s) -

    init(currency: Currency, baseCurrency: Currency?) {
        self.currencyCode = currency.currencyCode
        self.currencyName = currency.localizedName
        self.currencyFlag = currency.flagSymbol

        if let valueAgainstBase = currency.valueAgainstBase {
            self.baseToCurrencyValue = String(format: "%.03f", valueAgainstBase)
        }

        if let baseCurrency = baseCurrency, let valueAgainstBase = currency.valueAgainstBase {
            let value = String(format: "%.03f", 1.0 / valueAgainstBase)
            // Ex: 1 RON = 0.208 EUR
            self.currencyToBaseValue = "1 \(currencyCode) = \(value) \(baseCurrency.currencyCode)"
        }
    }
}
