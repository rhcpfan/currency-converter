//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 21/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

/// Model defining a currency.
class Currency: Codable, DefaultsSerializable {

    // MARK: - Instance Properties -

    /// Currency code (ex. "USD", "RON", etc.)
    var currencyCode: String
    /// Currency symbol (ex. "$", "€", etc.)
    lazy var symbol: String = { return getSymbol() }()
    /// Currency localized name (ex. "Romanian Leu", "US Dollar", etc.)
    lazy var localizedName: String? = { return getLocalizedName() }()
    /// The code for the country using this currecy.
    /// If multiple countries use the same currency, the main issuer country is selected.
    lazy var countryCode: String? = { return getCountryCode() }()
    lazy var flagSymbol: String? = { return getFlagSymbol() }()
    var valueAgainstBase: Double?

    // MARK: - Initializer(s) -

    /// Creates a currency instance.
    /// - Parameters:
    ///   - code: The currency code.
    ///   - value: The value against the base currency.
    init(code: String, value: Double? = nil) {
        self.currencyCode = code
        self.valueAgainstBase = value
        
        self.symbol = getSymbol()
        self.localizedName = getLocalizedName()
        self.countryCode = getCountryCode()
        self.flagSymbol = getFlagSymbol()
    }

    // MARK: - Instance Methods -

    fileprivate func getSymbol() -> String {
        let currencyCodeKey = NSLocale.Key.currencyCode.rawValue
        let currencyLocaleId = NSLocale.localeIdentifier(fromComponents: [currencyCodeKey: currencyCode])
        let currencyLocale = NSLocale(localeIdentifier: currencyLocaleId)
        return currencyLocale.currencySymbol
    }

    fileprivate func getLocalizedName() -> String? {
        return Locale.current.localizedString(forCurrencyCode: currencyCode)
    }

    fileprivate func getCountryCode() -> String? {
        // EUR is the only currency not mapping to a specific country
        if self.currencyCode == "EUR" { return "EU" }

        // Get all available locales
        let availableLocales = Locale.availableIdentifiers.map({ Locale(identifier: $0) })
        // Filter them by currency code
        let localesWithCurrency = availableLocales.filter({
            guard let currencyCode = $0.currencyCode else { return false }
            return currencyCode.caseInsensitiveCompare(self.currencyCode) == .orderedSame
        })
        // Get their region codes (all countries in which this currency is used)
        let regionCodes = localesWithCurrency.compactMap({ $0.regionCode }).uniques
        // If only one country uses that currency, return that one
        if regionCodes.count == 1 { return regionCodes[0] }
        // Else, if more than one country uses the same currency
        else if regionCodes.count > 1 {
            // Filter all country codes by matching against the currency code
            // (ex: CHF is used in [CH, LI], "CH" is in "CHF" so that's the main country)
            let matchingWithCurrency = regionCodes.filter({ self.currencyCode.contains($0) })
            // If only one region matching, return that one.
            if matchingWithCurrency.count == 1 { return matchingWithCurrency[0] }
        }

        // If all conditions fail, return nil
        return nil
    }

    fileprivate func getFlagSymbol() -> String? {
        guard let countryCode = self.countryCode else { return nil }
        // Flags are encoded starting with 0x1F1E6. The letter A has an offset of 65.
        let base : UInt32 = 0x1F1E6 - 65
        let unicodeScalars = countryCode.unicodeScalars.compactMap({ UnicodeScalar(base + $0.value) })
        // Return nil if we don't have all the values
        if unicodeScalars.count != countryCode.count { return nil }
        // Create the flag symbol of the country
        var flagSymbol = ""
        unicodeScalars.forEach({ flagSymbol.unicodeScalars.append($0) })
        return String(flagSymbol)
    }
}

// MARK: - Hashable Implementation -

extension Currency: Hashable {

    static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.currencyCode == rhs.currencyCode && lhs.valueAgainstBase == rhs.valueAgainstBase
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(currencyCode)
        hasher.combine(valueAgainstBase)
    }

}
