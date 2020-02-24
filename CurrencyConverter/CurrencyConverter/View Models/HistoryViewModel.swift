//
//  HistoryViewModel.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 22/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import Foundation
import SwiftyUserDefaults


class HistoryViewModel {

    // MARK: - Instance Properties -

    /// The API client used to fetch the data.
    var apiClient: ExchangeRatesApiClientProtocol = ExchangeRatesApiIoClient()
    /// The number of currencies to get historical data for.
    var numberOfCurrencies: Int = 0
    /// The current exchange rate history.
    var exchangeRatesHistory: ExchangeRateHistory?
    /// Array of history cell view models.
    var currencyHistoryCellViewModels: [ExchangeRateHistoryCellViewModel]?
    /// Closure used to signal that the exchange rate history was updated.
    var didUpdateExchangeRateHistory: (() -> Void)?
    /// Closure used to signal that fetching the exchange rate history failed.
    var didFailGettingExchangeRateHistory: ((String) -> Void)?

    // MARK: - Instance Methods -

    /// Fetches the exchange rate history.
    func fetchExchangeRateHistory() {
        let endDate = Date()
        guard let startDate = endDate.dateBySubtracting(days: 30) else { return }

        let baseCurrency = Defaults[\.baseCurrency]
        let includedCurrencies = [
            Currency(code: "RON"),
            Currency(code: "USD"),
            Currency(code: "BGN"),
            Currency(code: "CHF")
        ]

        apiClient.getExchangeRatesHistory(base: baseCurrency,
                                          currencies: includedCurrencies,
                                          from: startDate,
                                          to: endDate,
                                          completion: { [weak self] result in
            switch result {
            case .success(let exchangeRateHistory):
                self?.update(with: exchangeRateHistory)
            case .failure(let error):
                self?.didFailGettingExchangeRateHistory?(error.localizedDescription)
            }
        })
    }

    /// Parses the response from the API.
    /// - Parameter exchangeHistory: The exchange history received trom the API.
    private func update(with exchangeHistory: ExchangeRateHistory) {
        self.exchangeRatesHistory = exchangeHistory
        // Get all currencies
        let currencies = exchangeHistory.exchangeRates[0].currencies.sorted(by: { $0.currencyCode < $1.currencyCode })
        // Update the cell view models.
        self.currencyHistoryCellViewModels = currencies.compactMap({ ExchangeRateHistoryCellViewModel(currency: $0, exchangeRateHistory: exchangeHistory) })
        // Set the number of currencies.
        self.numberOfCurrencies = currencies.count
        // Signal that the exchange rate history was updated.
        self.didUpdateExchangeRateHistory?()
    }
}
