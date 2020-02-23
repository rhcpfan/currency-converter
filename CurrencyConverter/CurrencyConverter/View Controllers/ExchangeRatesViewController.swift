//
//  ExchangeRatesViewController.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 20/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import UIKit

class ExchangeRatesViewController: UIViewController {

    // MARK: - Instance Properties -

    lazy var viewModel = ExchangeRatesViewModel()
    private var exchangeRatesDataSource: ExchangeRatesTableViewDataSource!
    private var exchangeRatesSnapshot: NSDiffableDataSourceSnapshot<ExchangeRatesTableViewSection, ExchangeRatesCellType>!

    // MARK: - IBOutlets -

    @IBOutlet weak var exchangeRateTimestampLabel: UILabel!
    @IBOutlet weak var exchangeRatesTableView: UITableView!

    // MARK: - Application Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDataSource(for: self.exchangeRatesTableView)
        self.configureViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.startFetchingExchangeRates()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.stopFetchingExchangeRates()
    }

    // MARK: - Instance Methods -

    func configureViewModel() {
        self.viewModel.displayErrorAlertClosure = self.displayError
        self.viewModel.didUpdateExchangeRate = self.updateExchangeRate
        self.viewModel.didUpdateExchangeRateTimestamp = self.updateExchangeRateTimestamp
    }

    private func displayError(_ errorMessage: String) {
        let alertVC = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }

    func initDataSource(for tableView: UITableView) {
        self.exchangeRatesDataSource = ExchangeRatesTableViewDataSource.create(for: exchangeRatesTableView)
    }

    /// Creates a new `NSDiffableDataSourceSnapshot` from the exchange rates and applies it to the exchange rates table view.
    /// - Parameter exchangeRate: The exchange rate to display.
    func updateExchangeRate(_ exchangeRate: ExchangeRate) {
        exchangeRatesSnapshot = NSDiffableDataSourceSnapshot()

        let baseCurrency = exchangeRate.baseCurrency
        let baseCurrencyCell = ExchangeRatesCellType.baseCurrency(baseCurrency)
        exchangeRatesSnapshot.appendSections([.baseCurrency])
        exchangeRatesSnapshot.appendItems([baseCurrencyCell])

        let exchangeRateCells = exchangeRate.currencies.compactMap({ ExchangeRatesCellType.exchangeRate($0, baseCurrency) })
        exchangeRatesSnapshot.appendSections([.exchangeRates])
        exchangeRatesSnapshot.appendItems(exchangeRateCells, toSection: .exchangeRates)
        exchangeRatesDataSource.apply(exchangeRatesSnapshot)
    }

    func updateExchangeRateTimestamp(_ timestamp: String?) {
        DispatchQueue.main.async {
            self.exchangeRateTimestampLabel.text = timestamp
        }
    }
}
