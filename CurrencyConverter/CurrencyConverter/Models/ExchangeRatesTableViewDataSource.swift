//
//  ExchangeRatesTableViewDataSource.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 22/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import UIKit

/// The cell types displayed in the "Rates" table view.
enum ExchangeRatesCellType: Hashable {
    /// The base currency cell.
    case baseCurrency(Currency)
    /// The exchange rate cell for a specific `Currency`, against the base `Currency`.
    case exchangeRate(Currency, Currency)

    /// The cell reuse identifier.
    var reuseID: String {
        switch self {
        case .baseCurrency: return "CurrencyTableViewCell"
        case .exchangeRate: return "ExchangeRateTableViewCell"
        }
    }
}

/// The sections displayed in the "Rates" table view.
enum ExchangeRatesTableViewSection {
    /// The base currency section.
    case baseCurrency
    /// The exchange rates section.
    case exchangeRates

    /// The header of the section.
    var header: String {
        switch self {
        case .baseCurrency: return "Base Currency"
        case .exchangeRates: return "Exchange Rates"
        }
    }
}

/// Custom `UITableViewDiffableDataSource` implementation for displaying exchange rates.
class ExchangeRatesTableViewDataSource: UITableViewDiffableDataSource<ExchangeRatesTableViewSection, ExchangeRatesCellType> {

    // MARK: - Application Lifecycle -

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.snapshot().sectionIdentifiers[section]
        return section.header
    }

    // MARK: - Instance Methods -

    /// Creates an instance of `ExchangeRatesTableViewDataSource` used to update a table view.
    /// - Parameter tableView: The `UITableView` to update.
    static func create(for tableView: UITableView) -> ExchangeRatesTableViewDataSource {
        return ExchangeRatesTableViewDataSource(tableView: tableView, cellProvider: { tableView, indexPath, cellType in
            switch cellType {
            case .baseCurrency(let currency):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellType.reuseID, for: indexPath) as? CurrencyTableViewCell else { fatalError("Could not dequeue reusable cell with identifier: \(cellType.reuseID)") }
                let cellVM = CurrencyCellViewModel(currency: currency)
                cell.viewModel = cellVM
                return cell

            case .exchangeRate(let currency, let baseCurrency):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellType.reuseID, for: indexPath) as? ExchangeRateTableViewCell else {
                    fatalError("Could not dequeue reusable cell with identifier: \(cellType.reuseID)")
                }
                let cellVM = ExchangeRateCellViewModel(currency: currency, baseCurrency: baseCurrency)
                cell.viewModel = cellVM
                return cell
            }
        })
    }
}
