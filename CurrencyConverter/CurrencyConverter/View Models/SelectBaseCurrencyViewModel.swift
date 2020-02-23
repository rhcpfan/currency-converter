//
//  SelectBaseCurrencyViewModel.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 22/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class SelectBaseCurrencyViewModel {

    // MARK: - Instance Properties -

    /// The current base currency.
    private var baseCurrency: Currency {
        get { return Defaults[\.baseCurrency] }
        set { Defaults[\.baseCurrency] = newValue }
    }

    /// All other currencies except the base currency.
    private var otherCurrencies: [Currency] {
        let other = CurrencyManager.shared.allCurrencies
            .filter({ $0.currencyCode != baseCurrency.currencyCode })
            .sorted(by: { $0.currencyCode < $1.currencyCode })

        return other
    }

    /// The base currency cell type.
    var baseCurrencyCell: SelectBaseCurrencyTableViewCellTypes {
        return .currency(self.baseCurrency)
    }

    /// The cells representing other currencies.
    var otherCurrencyCells: [SelectBaseCurrencyTableViewCellTypes] {
        return otherCurrencies.compactMap({ SelectBaseCurrencyTableViewCellTypes.currency($0) })
    }

    /// Closure used to signal that the base currency changed.
    var didChangeBaseCurrency: (() -> Void)?

    // MARK: - Instance Methods -

    /// Changes the base currency with the one from the "Other" section.
    /// - Parameter index: The index of the selected currency from `otherCurrencies`.
    func didSelectNewBaseCurrency(at index: Int) {
        let selectedCurrency = otherCurrencies[index]
        self.baseCurrency = selectedCurrency
        self.didChangeBaseCurrency?()
    }
}
