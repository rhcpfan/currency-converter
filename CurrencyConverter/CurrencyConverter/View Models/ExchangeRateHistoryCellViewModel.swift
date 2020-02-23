//
//  ExchangeRateHistoryCellViewModel.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 23/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import Foundation

class ExchangeRateHistoryCellViewModel {

    // MARK: - Instance Properties -

    let currencyCode: String
    let currencyName: String?
    let currencyFlag: String?
    /// Array of pairs of `Date` and `Double` representing the date and the currency value.
    private var historicalValues: [(date: Date, value: Double)]
    /// The values displayed on the chart (paris of `Double` values,
    /// first = the date represented as `.timeIntervalSince1970`, second = the currency value).
    var chartValues: [(date: Double, value: Double)]
    /// The selected chart value.
    var selectedChartValue: String? {
        didSet {
            guard selectedChartValue != nil else { return }
            self.didUpdateSelectedHistoryValue?()
        }
    }

    /// Signal that the selected history chart entry has changed.
    var didUpdateSelectedHistoryValue: (() -> Void)?

    // MARK: - Initializer(s) -

    init(currency: Currency, exchangeRateHistory: ExchangeRateHistory) {

        self.currencyCode = currency.currencyCode
        self.currencyName = currency.localizedName
        self.currencyFlag = currency.flagSymbol

        var historyValues: [(date: Date, value: Double)] = []

        for exchangeRate in exchangeRateHistory.exchangeRates {
            if let currencyValue = exchangeRate.currencies.first(where: { $0.currencyCode == currency.currencyCode })?.valueAgainstBase {
                historyValues.append((exchangeRate.exchangeDate, currencyValue))
            }
        }

        self.historicalValues = historyValues.sorted(by: { $0.date < $1.date })
        self.chartValues = self.historicalValues.map({ ($0.date.timeIntervalSince1970, $0.value) })
    }

    // MARK: - Instance Methods -

    /// Updates the selected chart value.
    /// - Parameters:
    ///   - x: The `X` axis value (date)
    ///   - y: The `Y` axis value (currency value)
    func didSelectChartValue(x: Double, y: Double) {
        let selectedDate = Date(timeIntervalSince1970: x)
        let dateRepresentation = selectedDate.stringRepresentation(dateStyle: .full, timeStyle: .none)
        self.selectedChartValue = String(format: "%.04f on %@", locale: .current, y, dateRepresentation)
    }
}
