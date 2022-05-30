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
        
        for x in 0...6 {
            entries.append(ChartDataEntry(x: Double(x), y: Double(values[x])))
        }
        
        let set = LineChartDataSet(entries: entries, label: "kcal")
        set.colors = [.darkGray]
        let data = LineChartData(dataSet: set)
        calChartView.data = data
        calChartView.gridBackgroundColor = .clear
        calChartView.doubleTapToZoomEnabled = false
        calChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        calChartView.xAxis.labelPosition = .bottom
        calChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        calChartView.rightAxis.enabled = false
        calChartView.xAxis.drawGridLinesEnabled = false
        calChartView.backgroundColor = .mainGreen
        
        //리미트라인
        let ll = ChartLimitLine(limit: 1700.0, label: "타겟")
        calChartView.leftAxis.addLimitLine(ll)
    }
}
