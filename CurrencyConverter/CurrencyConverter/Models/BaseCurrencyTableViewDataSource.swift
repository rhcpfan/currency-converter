//
//  BaseCurrencyTableViewDataSource.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 22/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import UIKit

/// The cell types displayed in the "Base Currency" table view.
enum SelectBaseCurrencyTableViewCellTypes: Hashable {
    /// A cell representing a currency.
    case currency(Currency)
    /// The cell reuse identifier.
    var reuseID: String { return "CurrencyTableViewCell" }
}

/// The section types displayed in the "Base Currency" table view.
enum SelectBaseCurrencyTableViewSection: Int {
    /// The base currency section.
    case baseCurrency
    /// Section for displaying currencies different from the base currency.
    case otherCurrencies

    /// The section header.
    var header: String {
        switch self {
        case .baseCurrency: return "Base Currency"
        case .otherCurrencies: return "Other"
        }
    }
}

/// Custom `UITableViewDiffableDataSource` implementation for displaying the selected base currency..
class BaseCurrencyTableViewDataSource: UITableViewDiffableDataSource<SelectBaseCurrencyTableViewSection, SelectBaseCurrencyTableViewCellTypes> {

    // MARK: - Application Lifecycle -

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.snapshot().sectionIdentifiers[section]
        return section.header
    }

    // MARK: - Instance Methods -

    /// Creates an instance of `BaseCurrencyTableViewDataSource` used to update the base currency table view.
    /// - Parameter tableView: The `UITableView` instance to provide updates for.
    static func create(for tableView: UITableView) -> BaseCurrencyTableViewDataSource {
        return BaseCurrencyTableViewDataSource(tableView: tableView, cellProvider: { tableView, indexPath, cellType in
            switch cellType {
            case .currency(let currency):
                let cellVM = CurrencyCellViewModel(currency: currency)
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellType.reuseID, for: indexPath) as? CurrencyTableViewCell else {
                    fatalError("Could not dequeue reusable cell with identifier: \(cellType.reuseID)")
                }
                cell.viewModel = cellVM

                // disable selection for the current base currency cell
                if indexPath.section == 0 {
                    cell.selectionStyle = .none
                }

                return cell
            }
        })
    }
}
