//
//  SelectBaseCurrencyTableViewController.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 22/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import UIKit

class SelectBaseCurrencyTableViewController: UITableViewController {

    // MARK: - Instance Properties -

    var viewModel = SelectBaseCurrencyViewModel()

    private var currenciesDataSource: BaseCurrencyTableViewDataSource!
    private var currenciesSnapshot: NSDiffableDataSourceSnapshot<SelectBaseCurrencyTableViewSection, SelectBaseCurrencyTableViewCellTypes>!

    // MARK: - Application Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDataSource(for: self.tableView)
        self.configureViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshTableViewData()
    }

    // MARK: - Instance Methods -

    func initDataSource(for tableView: UITableView) {
        self.currenciesDataSource = BaseCurrencyTableViewDataSource.create(for: tableView)
    }

    func configureViewModel() {
        self.viewModel.didChangeBaseCurrency = self.refreshTableViewData
    }

    func refreshTableViewData() {
        // Update table view
        currenciesSnapshot = NSDiffableDataSourceSnapshot()

        currenciesSnapshot.appendSections([.baseCurrency])
        currenciesSnapshot.appendItems([viewModel.baseCurrencyCell], toSection: .baseCurrency)

        currenciesSnapshot.appendSections([.otherCurrencies])
        currenciesSnapshot.appendItems(viewModel.otherCurrencyCells, toSection: .otherCurrencies)
        currenciesDataSource.apply(currenciesSnapshot, animatingDifferences: true)
    }
}

// MARK: - UITableViewDelegate Implementation -

extension SelectBaseCurrencyTableViewController {

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == SelectBaseCurrencyTableViewSection.baseCurrency.rawValue {
            return nil
        }

        return indexPath
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.didSelectNewBaseCurrency(at: indexPath.row)
    }
}
