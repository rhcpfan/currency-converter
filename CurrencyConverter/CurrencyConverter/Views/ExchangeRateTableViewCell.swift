//
//  ExchangeRateTableViewCell.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 21/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import UIKit

class ExchangeRateTableViewCell: UITableViewCell {

    // MARK: - Instance Properties -

    var viewModel: ExchangeRateCellViewModel? {
        didSet {
            guard let cellVM = viewModel else { return }
            self.currencyFlagLabel.text = cellVM.currencyFlag
            self.currencyCodeLabel.text = cellVM.currencyCode
            self.currencyNameLabel.text = cellVM.currencyName
            self.baseToCurrencyValueLabel.text = cellVM.baseToCurrencyValue
            self.currencyToBaseValueLabel.text = cellVM.currencyToBaseValue
        }
    }

    // MARK: - IBOutlets -

    @IBOutlet weak var currencyFlagLabel: UILabel!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var baseToCurrencyValueLabel: UILabel!
    @IBOutlet weak var currencyToBaseValueLabel: UILabel!

}
