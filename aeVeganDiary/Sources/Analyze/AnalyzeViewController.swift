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
        
        showIndicator()
        AnalyzeDataManager().requestData(viewController: self)
        
        // 그래프에 들어갈 데이터들
        dates = ["05.24", "05.25", "05.26", "05.27", "05.28", "05.29", "05.30", "05.31"]
        values = [1500, 1600, 2000, 1700, 1800, 2100, 2000, 1800]
        
        setLineChart(dataPoints: dates, values: values)
        
        drawStackedProgress(percentages: [0.2,0.3,0.5], width: 200, height: 20, x: 200, y: 200)
    }
    
    // 그래프 설정 코드
    func setLineChart(dataPoints: [String], values: [Double]) {
        var entries = [ChartDataEntry]()
        
        for x in 0...6 {
            entries.append(ChartDataEntry(x: Double(x), y: Double(values[x])))
        }
        
        let set = LineChartDataSet(entries: entries, label: "kcal")
        set.circleRadius = 5
        set.circleHoleRadius = 2.5
        set.circleColors = [.middleGreen]
        set.colors = [.middleGreen]
        set.lineWidth = 2
        
        let data = LineChartData(dataSet: set)
        data.setValueFont(UIFont.systemFont(ofSize: 10, weight: .semibold))
        data.setValueTextColor(.lGray)
        data.setDrawValues(false)
        
        // 그래프 설정
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
        //calChartView.xAxis.forceLabelsEnabled = true
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
        ll.labelPosition = .rightTop
        calChartView.leftAxis.addLimitLine(ll)
        
        let li = ChartLimitLine(limit: 2000, label: "권장 2000kcal")
        li.lineWidth = 1
        li.labelPosition = .leftTop
        li.valueFont = UIFont.systemFont(ofSize: 11)
        li.lineColor = .darkGreen
        calChartView.leftAxis.addLimitLine(li)
    }
    
    func drawStackedProgress(percentages:[Float], width:Float, height:Float, x:Float, y:Float){
        var currentX = x

        let colors = [UIColor.red, UIColor.blue, UIColor.green]
        var index = -1
        for percentage in percentages{
            index += 1
            let DynamicView=UIView(frame: CGRect(x: CGFloat(currentX), y: CGFloat(y), width: CGFloat(Double(percentage)*Double(width)), height: CGFloat(height)))
            currentX+=Float(Double(percentages[index])*Double(width))
            DynamicView.backgroundColor=colors[index]
            self.view.addSubview(DynamicView)
        }
    }
}

extension AnalyzeViewController {
    func getData(response: AnalyzeResponse) {
        dismissIndicator()
    }
}
