//
//  SettingsViewController.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 20/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    // MARK: - Instance Properties -

    var viewModel = SettingsViewModel()

    // MARK: - IBOutlets -

    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var refreshTimeIntervalLabel: UILabel!
    @IBOutlet weak var refreshTimeIntervalPicker: UIPickerView!
    @IBOutlet weak var applicationVersionLabel: UILabel!

    // MARK: - Application Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewModel()
        self.initRefreshTimeIntervalPicker()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.baseCurrencyLabel.text = viewModel.baseCurrencyCode
        self.applicationVersionLabel.text = viewModel.applicationVersion
        self.refreshTimeIntervalLabel.text = viewModel.currentRefreshTimeIntervalTitle
    }

    // MARK: - Instance Methods -

    func initRefreshTimeIntervalPicker() {
        let selectedIndex = viewModel.selectedRefreshIntervalIndex
        self.refreshTimeIntervalPicker.selectRow(selectedIndex, inComponent: 0, animated: false)
    }

    func configureViewModel() {
        viewModel.didUpdateRefreshTimeInterval = self.updateRefreshTimeIntervalLabel
    }

    func updateRefreshTimeIntervalLabel() {
        DispatchQueue.main.async {
            self.refreshTimeIntervalLabel.text = self.viewModel.currentRefreshTimeIntervalTitle
        }
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate Implementation -

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRefreshTimeIntervalOptions
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.refreshTimeIntervalOptionTitles[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.updateRefreshTimeInterval(index: row)
    }
}
