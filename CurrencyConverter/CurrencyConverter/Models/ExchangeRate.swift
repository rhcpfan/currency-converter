//
//  ExchangeRate.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 21/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import UIKit

/// Representation of an exchange rate.
struct ExchangeRate: Decodable {

    // MARK: - Instance Properties -

    /// The currencies included in the exchange rate.
    var currencies: [Currency]
    /// The base currency.
    var baseCurrency: Currency
    /// The date the exchange rates are for.
    var exchangeDate: Date

    // MARK: - Initializer(s) -

    init(currencies: [Currency], base: Currency, date: Date) {
        self.currencies = currencies
        self.baseCurrency = base
        self.exchangeDate = date
    }

    // MARK: - Codable Implementation -

    enum CodingKeys: String, CodingKey {
        case currencies = "rates"
        case baseCurrencyType = "base"
        case exchangeDate = "date"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let ratesDictionary = try values.decode([String : Double].self, forKey: .currencies)
        let baseCurrencyCode = try values.decode(String.self, forKey: .baseCurrencyType)
        let valuesDate = try values.decode(String.self, forKey: .exchangeDate)

        self.currencies = ratesDictionary
            .compactMap({ return Currency(code: $0.key, value: $0.value) })
            .sorted(by: ({ $0.currencyCode < $1.currencyCode }))
            .filter({ $0.currencyCode != baseCurrencyCode })

        self.baseCurrency = Currency(code: baseCurrencyCode)

        if let exchangeDate = Date(format: "yyyy-MM-dd", value: valuesDate) {
            self.exchangeDate = exchangeDate
        } else {
            throw ExchangeRatesApiError.decodeTimestampError
        }
    }
}
