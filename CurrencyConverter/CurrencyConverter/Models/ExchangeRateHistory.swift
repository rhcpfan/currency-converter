//
//  ExchangeRateHistory.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 22/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import Foundation

/// Representation of an exchange rate history.
struct ExchangeRateHistory: Decodable {

    // MARK: - Instance Properties -

    /// The base currency.
    var baseCurrency: Currency
    /// An array of exchange rates used to compute the historical values for each day included.
    var exchangeRates: [ExchangeRate]
    
    // MARK: - Codable Implementation -

    enum CodingKeys: String, CodingKey {
        case exchangeRates = "rates"
        case baseCurrencyType = "base"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let ratesDictionary = try values.decode([String : [String : Double]].self, forKey: .exchangeRates)
        let baseCurrencyCode = try values.decode(String.self, forKey: .baseCurrencyType)

        let baseCurrency = Currency(code: baseCurrencyCode)
        self.baseCurrency = baseCurrency
        self.exchangeRates = []

        for rateDictionary in ratesDictionary {
            guard let dateValue = Date(format: "yyyy-MM-dd", value: rateDictionary.key) else { continue }
            let currencies = rateDictionary.value.compactMap({ currency in
                Currency(code: currency.key, value: currency.value)
            })

            let exchangeRateEntry = ExchangeRate(currencies: currencies, base: baseCurrency, date: dateValue)
            self.exchangeRates.append(exchangeRateEntry)
        }
    }
}
