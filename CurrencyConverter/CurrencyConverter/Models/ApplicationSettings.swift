//
//  ApplicationSettings.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 22/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

/// Extension of `DefaultsKeys` for defining the stored application settings.
extension DefaultsKeys {
    /// The current base currency.
    var baseCurrency: DefaultsKey<Currency> { return .init("settings.base_currency_code", defaultValue: Currency(code: "EUR")) }
    /// The refresh interval used to refresh the exchange rates in the "Rates" screen.
    var refreshTimeInterval: DefaultsKey<TimeInterval> { return .init("settings.refresh_time_interval", defaultValue: 3)}
}

struct ApplicationSettings {
    /// The application version.
    static var appVersion: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
                fatalError("Failed to get application version and build number.")
        }

        return "\(version) (\(buildNumber))"
    }
}
