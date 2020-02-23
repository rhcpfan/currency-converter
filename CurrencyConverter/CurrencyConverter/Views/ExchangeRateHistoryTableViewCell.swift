//
//  ExchangeRateHistoryTableViewCell.swift
//  CurrencyConverter
//
//  Created by Andrei Ciobanu on 23/02/2020.
//  Copyright © 2020 Andrei Ciobanu. All rights reserved.
//

import UIKit
import Charts

/// A `Charts` value formatter that converts the `Double` values on the `X axis`
/// (date values as `timeIntervalSince1970`) to their string representation.
public class ChartDateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()

    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM"
    }

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

class ExchangeRateHistoryTableViewCell: UITableViewCell {

    // MARK: - Instance Properties -

    var viewModel: ExchangeRateHistoryCellViewModel? {
        didSet {
            guard let cellVM = viewModel else { return }
            self.currencyFlagLabel.text = cellVM.currencyFlag
            self.currencyCodeLabel.text = cellVM.currencyCode
            self.currencyNameLabel.text = cellVM.currencyName
            self.updateChartData(viewModel: cellVM)
            self.configureViewModel()
        }
    }

    // MARK: - IBOutlets -

    @IBOutlet weak var currencyFlagLabel: UILabel!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyValueLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!

    // MARK: - Application Lifecycle -

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initChartView()

    }

    // MARK: - Instance Methods -

    func configureViewModel() {
        viewModel?.didUpdateSelectedHistoryValue = self.updateSelectedHistoryValueLabel
    }

    func updateSelectedHistoryValueLabel() {
        DispatchQueue.main.async {
            self.currencyValueLabel.text = self.viewModel?.selectedChartValue
        }
    }

    /// Initializes the chart view (sets its appearance, configures the X and Y axis, etc.).
    func initChartView() {
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        chartView.highlightPerDragEnabled = true
        chartView.legend.enabled = false
        chartView.gridBackgroundColor = UIColor.systemBackground
        chartView.delegate = self

        // X Axis (Date)

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.labelTextColor = UIColor.label
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = true
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 3600
        xAxis.valueFormatter = ChartDateValueFormatter()

        // Y Axis (Value)

        let yAxis = chartView.leftAxis
        yAxis.labelPosition = .outsideChart
        yAxis.granularity = 0.0001
        yAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        yAxis.drawGridLinesEnabled = true
        yAxis.granularityEnabled = true
        yAxis.labelTextColor = UIColor.label

        chartView.rightAxis.enabled = false
    }

    /// Updates the chart data.
    /// - Parameter viewModel: The view model instance that holds the chart values.
    func updateChartData(viewModel: ExchangeRateHistoryCellViewModel) {
        let dataPoints = viewModel.chartValues
        let dateEntries = dataPoints.map({ ChartDataEntry(x: $0.0, y: $0.1) })

        let entriesDataSet = LineChartDataSet(entries: dateEntries, label: viewModel.currencyCode)
        entriesDataSet.axisDependency = .left
        entriesDataSet.mode = .cubicBezier
        entriesDataSet.setColor(UIColor.systemYellow)
        entriesDataSet.lineWidth = 2
        entriesDataSet.drawValuesEnabled = false
        entriesDataSet.drawIconsEnabled = false
        entriesDataSet.drawCircleHoleEnabled = false
        entriesDataSet.drawCirclesEnabled = true
        entriesDataSet.setCircleColor(.label)
        entriesDataSet.circleRadius = 2
        entriesDataSet.drawFilledEnabled = true
        entriesDataSet.fillAlpha = 0.2
        entriesDataSet.fillColor = UIColor.systemYellow

        let chartData = LineChartData(dataSet: entriesDataSet)
        chartData.setValueTextColor(.label)
        chartData.setValueFont(.systemFont(ofSize: 9, weight: .light))

        chartView.autoScaleMinMaxEnabled = true
        self.chartView.data = chartData
        chartView.animate(xAxisDuration: 1, easingOption: .linear)
        chartView.autoScaleMinMaxEnabled = false
    }
}

// MARK: - ChartViewDelegate Implementation -

extension ExchangeRateHistoryTableViewCell: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        self.viewModel?.didSelectChartValue(x: entry.x, y: entry.y)
    }
}
