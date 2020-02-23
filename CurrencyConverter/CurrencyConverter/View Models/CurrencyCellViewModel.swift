//
//  CurrencyCell.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 22/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import Foundation

struct CurrencyCellViewModel {

    // MARK: - Instance Properties -

    let currencyCode: String
    let currencyFlag: String?
    let currencyName: String?

    // MARK: - Initializer(s) -

    init(currency: Currency) {
        self.currencyCode = currency.currencyCode
        self.currencyName = currency.localizedName
        self.currencyFlag = currency.flagSymbol
    }
}
