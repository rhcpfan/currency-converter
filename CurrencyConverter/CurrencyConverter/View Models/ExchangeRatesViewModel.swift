//
//  ExchangeRatesViewModel.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 21/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class ExchangeRatesViewModel {

    // MARK: - Instance Properties -

    /// The refresh timer that triggers the fetching of exchange rates.
    weak var refreshTimer: Timer?
    /// The API client used to fetch data.
    var apiClient: ExchangeRatesApiClientProtocol = ExchangeRatesApiIoClient()

    /// The current exchange rate.
    var currentExchangeRate: ExchangeRate? {
        didSet {
            guard let exchangeRate = currentExchangeRate else { return }
            self.didUpdateExchangeRate?(exchangeRate)
        }
    }

    /// The current exchange rate timestamp (ex. "Last updated: 15/02/2020, 13:18:32")
    var currentExchangeRateTimestamp: String? {
        didSet { self.didUpdateExchangeRateTimestamp?(currentExchangeRateTimestamp) }
    }

    /// Closure used to signal that the exchange rate was updated.
    var didUpdateExchangeRate: ((ExchangeRate) -> Void)?
    /// Closure used to signal that the exchange rate timestamp was updated.
    var didUpdateExchangeRateTimestamp: ((String?) -> Void)?
    /// Closure used to signal that an error occured. Provides the error message as the first parameter.
    var displayErrorAlertClosure: ((String) -> Void)?

    // MARK: - Instance Methods -

    /// Starts to fetch exchange rates at the interval defined in the application settings.
    func startFetchingExchangeRates() {
        let refreshInterval = Defaults[\.refreshTimeInterval]
        refreshTimer?.invalidate()
        refreshTimer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true, block: { [weak self] _ in
            self?.fetchExchangeRates()
        })
        refreshTimer?.fire()
    }

    /// Stops fetching exchange rate updates.
    func stopFetchingExchangeRates() {
        refreshTimer?.invalidate()
    }

    /// Fetches exchange rates from the API.
    private func fetchExchangeRates() {
        let baseCurrency = Defaults[\.baseCurrency]
        apiClient.getLatestExchangeRates(baseCurrency: baseCurrency, completion: { [weak self] result in
            switch result {
            case .success(let exchangeRate):
                // Store the received currencies
                CurrencyManager.shared.allCurrencies = exchangeRate.currencies
                CurrencyManager.shared.allCurrencies.append(exchangeRate.baseCurrency)
                // Get the current refresh date timestamp
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .medium
                let refreshDateTimestamp = dateFormatter.string(from: Date())
                let timestampFormatted = "Last updated: \(refreshDateTimestamp)"
                // Set the current exchange rate
                self?.currentExchangeRate = exchangeRate
                // Send changes to the VC
                self?.currentExchangeRateTimestamp = timestampFormatted
            case .failure(let error):
                self?.displayErrorAlertClosure?(error.localizedDescription)
            }
        })
    }
}
