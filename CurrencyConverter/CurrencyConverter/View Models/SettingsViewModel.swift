//
//  SettingsViewModel.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 22/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct SettingsViewModel {

    // MARK: - Instance Properties -

    /// The base currency code.
    var baseCurrencyCode: String { return Defaults[\.baseCurrency].currencyCode }

    /// The options for the refresh time interval.
    private let refreshTimeIntervalOptions: [TimeInterval] = [3, 5, 15]
    /// The number of options for the refresh time interval setting.
    var numberOfRefreshTimeIntervalOptions: Int { return refreshTimeIntervalOptions.count }
    /// The titles for each refresh time interval option.
    var refreshTimeIntervalOptionTitles: [String] { return refreshTimeIntervalOptions.map({ "\(Int($0)) seconds" }) }
    /// The current refresh time interval.
    private var currentRefreshTimeInterval: TimeInterval {
        get { return Defaults[\.refreshTimeInterval] }
        set { Defaults[\.refreshTimeInterval] = newValue }
    }
    /// The current refresh time interval title.
    var currentRefreshTimeIntervalTitle: String { return "\(Int(currentRefreshTimeInterval)) seconds"}
    /// The index of the selected time interval amongst all options.
    var selectedRefreshIntervalIndex: Int {
        get { return refreshTimeIntervalOptions.firstIndex(of: currentRefreshTimeInterval) ?? 0 }
        set { currentRefreshTimeInterval = refreshTimeIntervalOptions[newValue] }
    }
    /// Closure for signaling refresh time interval updates.
    var didUpdateRefreshTimeInterval: (() -> Void)?
    /// The application version.
    var applicationVersion: String { return ApplicationSettings.appVersion }

    // MARK: - Instance Methods -

    /// Updates the selected refresh time interval
    /// - Parameter index: The index of the selected option.
    mutating func updateRefreshTimeInterval(index: Int) {
        self.selectedRefreshIntervalIndex = index
        self.didUpdateRefreshTimeInterval?()
    }
}
