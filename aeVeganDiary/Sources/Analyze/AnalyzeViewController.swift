//
//  AnalyzeViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/29.
//

import UIKit
import Charts

class AnalyzeViewController: BaseViewController, ChartViewDelegate {
    
    @IBOutlet weak var calChartView: LineChartView!
    
    
    var dates: [String]!
    var values: [Double]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationTitle(title: "분석")
        
        calChartView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dates = ["05.24", "05.25", "05.26", "05.27", "05.28", "05.29", "05.30"]
        values = [1500, 1600, 2000, 1700, 1800, 2100, 2000]
        
        
        setLineChart(dataPoints: dates, values: values)
    }
    
    func setLineChart(dataPoints: [String], values: [Double]) {
        var entries = [ChartDataEntry]()
        
        for x in 0...5 {
            entries.append(ChartDataEntry(x: Double(x), y: Double(values[x])))
        }
        
        let set = LineChartDataSet(entries: entries, label: "kcal")
        set.circleRadius = 5
        set.circleHoleRadius = 2.5
        set.circleColors = [.mainGreen]
        set.colors = [.mainGreen]
        set.lineWidth = 2
        
        let data = LineChartData(dataSet: set)
        data.setValueFont(UIFont.systemFont(ofSize: 10, weight: .semibold))
        data.setValueTextColor(.lightGray)
        data.setDrawValues(false)
        
        calChartView.data = data
        calChartView.doubleTapToZoomEnabled = false
        calChartView.highlightPerTapEnabled = false
        calChartView.animate(yAxisDuration: 1.0)
        calChartView.xAxis.labelPosition = .bottom
        calChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        calChartView.rightAxis.enabled = false
        calChartView.xAxis.drawGridLinesEnabled = false
        
        calChartView.leftAxis.drawGridLinesEnabled = false
        calChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 9)
        //calChartView.xAxis.labelRotationAngle = -20
        calChartView.leftAxis.drawLabelsEnabled = false
        calChartView.leftAxis.drawAxisLineEnabled = false
        calChartView.leftAxis.drawLimitLinesBehindDataEnabled = false
        calChartView.xAxis.forceLabelsEnabled = true
        calChartView.xAxis.gridColor = .lightGray
        calChartView.xAxis.labelTextColor = .lightGray
        
        calChartView.legend.enabled = false
        
        calChartView.extraLeftOffset = 20
        calChartView.extraRightOffset = 20
        calChartView.extraTopOffset = 10
        
        //리미트라인
        var sum: Double = 0
        for element in values {
            sum += element
        }
        let avg = sum / Double(values.count)
        let ll = ChartLimitLine(limit: avg, label: "평균 \(Int(avg))kcal")
        ll.lineWidth = 1
        ll.valueFont = UIFont.systemFont(ofSize: 11)
        calChartView.leftAxis.addLimitLine(ll)
    }
}
