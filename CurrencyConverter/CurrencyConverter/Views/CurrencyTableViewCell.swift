//
//  CurrencyTableViewCell.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 22/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    // MARK: - Instance Properties -

    var viewModel: CurrencyCellViewModel? {
        didSet {
            guard let cellVM = viewModel else { return }
            self.currencyFlagLabel.text = cellVM.currencyFlag
            self.currencyCodeLabel.text = cellVM.currencyCode
            self.currencyNameLabel.text = cellVM.currencyName
        }
    }

    // MARK: - IBOutlets -

    @IBOutlet weak var currencyFlagLabel: UILabel!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
}
