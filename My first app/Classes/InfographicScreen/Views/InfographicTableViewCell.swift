//
//  InfographicTableViewCell.swift
//  My first app
//
//  Created by ios02 on 12.02.18.
//  Copyright © 2018 ios02. All rights reserved.
//

import UIKit
import Charts

class InfographicTableViewCell: UITableViewCell, ChartViewDelegate {

    @IBOutlet weak var titleNutritionLabel: UILabel!
    @IBOutlet weak var chartView: HorizontalBarChartView!
    @IBOutlet weak var numberDailyLabel: UILabel!
    @IBOutlet weak var numberNutritionLabel: UILabel!

    var chartDatas = [BarChartDataEntry]()

    /// Method for charts' data creating.
    private func chartDataForCell(goalElement: Double, dayElement: Double) {
        drawLayers()
        chartDatas.removeAll()
        var yData = [Double]()
        var index = 0.0
        var numberElement = 0
        yData.append(goalElement)
        yData.append(dayElement)
        for _ in 0..<2 {
            let chartEntry = BarChartDataEntry(x: index * 10.0, y: yData[numberElement])
            chartDatas.append(chartEntry)
            index += 1.0
            numberElement += 1
        }
        drawDataBars()
    }

    /// Method for charts' UI.
    private func drawLayers() {
        setup(barLineChartView: chartView)

        chartView.delegate = self
        chartView.maxVisibleCount = 2

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = true
        xAxis.granularity = 200

        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0

        let rightAxis = chartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisMinimum = 0

        let chartLegend = chartView.legend
        chartLegend.horizontalAlignment = .left
        chartLegend.verticalAlignment = .bottom
        chartLegend.orientation = .horizontal
        chartLegend.drawInside = false
        chartLegend.form = .square
        chartLegend.formSize = 8
        chartLegend.xEntrySpace = 4
    }

    /// Method for charts' accessories.
    private func setup(barLineChartView chartView: BarLineChartViewBase) {
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.highlightPerTapEnabled = false
    }

    /// Method for drawing data bars.
    private func drawDataBars() {
        let barWidth = 9.0
        let set = BarChartDataSet(values: chartDatas, label: "Day Goal")
        let data = BarChartData(dataSet: set)
        data.setValueFont(UIFont.systemFont(ofSize: 10.0))
        set.colors = [UIColor(red: 237/255.0, green: 237/255.0, blue: 239/255.0, alpha: 1),
                      UIColor(red: 189/255.0, green: 234/255.0, blue: 221/255.0, alpha: 1)]
        data.barWidth = barWidth
        chartView.data = data
    }

    /// Method configures cells.
    func configure(goalArrayElement: Double, dayArrayElement: Double, titlesElement: String) {
        titleNutritionLabel.text = titlesElement
        chartDataForCell(goalElement: goalArrayElement, dayElement: dayArrayElement)
        numberDailyLabel.text = "\(dayArrayElement)"
        numberNutritionLabel.text = "\(goalArrayElement)"
    }

}
