//
//  HistoryViewController.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 20/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class HistoryViewController: UITableViewController {

    // MARK: - Instance Properties -

    let viewModel = HistoryViewModel()

    // MARK: - Application Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.fetchExchangeRateHistory()
    }

    // MARK: - Instance Methods -

    func configureViewModel() {
        viewModel.didUpdateExchangeRateHistory = self.updateExchangeRateHistory
    }

    func updateExchangeRateHistory() {
        self.tableView.reloadData()
    }

    // MARK: - UITableViewDataSource Implementation -

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCurrencies
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseID = "\(ExchangeRateHistoryTableViewCell.self)"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath) as? ExchangeRateHistoryTableViewCell else {
            fatalError("Could not dequeue reusable cell with identifier: \(cellReuseID)")
        }

        cell.viewModel = self.viewModel.currencyHistoryCellViewModels?[indexPath.row]

        return cell
    }

}
