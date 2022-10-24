//
//  AnalyzeViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/29.
//

import UIKit
import Charts

class AnalyzeViewController: BaseViewController, ChartViewDelegate {
    
    lazy var analyzeDataManager: AnalyzeDataManagerDelegate = AnalyzeDataManager()
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var ratioView: UIView!
    @IBOutlet weak var calMessageLabel: UILabel!
    @IBOutlet weak var calChartView: LineChartView!
    
    @IBOutlet weak var carbProgressView: UIProgressView!
    @IBOutlet weak var proProgressView: UIProgressView!
    @IBOutlet weak var fatProgressView: UIProgressView!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var carbPercentLabel: UILabel!
    @IBOutlet weak var proLabel: UILabel!
    @IBOutlet weak var proPercentLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var fatPercentLabel: UILabel!
    
    @IBOutlet weak var statusView: UIView!
    var dates: [String]!
    var values: [Double]!
    var analysis = [Analysis]()
    var rcal:Double? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationTitle(title: "분석")
        
        calChartView.delegate = self
        
        // ProgressView
        carbProgressView.clipsToBounds = true
        carbProgressView.layer.cornerRadius = 4
        carbProgressView.clipsToBounds = true
        carbProgressView.layer.sublayers![1].cornerRadius = 4// 뒤에 있는 회색 track
        carbProgressView.subviews[1].clipsToBounds = true
        
        proProgressView.clipsToBounds = true
        proProgressView.layer.cornerRadius = 4
        proProgressView.clipsToBounds = true
        proProgressView.layer.sublayers![1].cornerRadius = 4// 뒤에 있는 회색 track
        proProgressView.subviews[1].clipsToBounds = true
        
        fatProgressView.clipsToBounds = true
        fatProgressView.layer.cornerRadius = 4
        fatProgressView.clipsToBounds = true
        fatProgressView.layer.sublayers![1].cornerRadius = 4// 뒤에 있는 회색 track
        fatProgressView.subviews[1].clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dates = [String]()
        values = [Double]()
        
        showIndicator()
        analyzeDataManager.getAnalyze(delegate: self)
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
        data.setDrawValues(true)
        
        // 그래프 설정
        calChartView.leftAxis.removeAllLimitLines()
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
        
        let li = ChartLimitLine(limit: Double(rcal ?? 0), label: "권장 \(rcal ?? 0)kcal")
        li.lineWidth = 1
        li.labelPosition = .leftTop
        li.valueFont = UIFont.systemFont(ofSize: 11)
        li.lineColor = .darkGreen
        calChartView.leftAxis.addLimitLine(li)
        
        message(rcal: rcal ?? 0, avg: avg)
    }
    
    func message(rcal: Double, avg: Double) {
        if rcal - 300 > avg {
            calMessageLabel.text = "권장 칼로리(\(Int(rcal))kcal)보다 적게 섭취하셨어요"
        } else if rcal + 300 < avg {
            calMessageLabel.text = "권장 칼로리(\(Int(rcal))kcal)보다 많이 섭취하셨어요"
        } else {
            calMessageLabel.text = "적절하게 섭취하고 있어요"
        }
    }
    
    func drawStackedProgress(percentages:[Float], width:Float, height:Float, x:Float, y:Float){
        var currentX = x

        let text = ["탄수화물", "단백질", "지방"]
        let colors = [UIColor.barRed, UIColor.barGreen, UIColor.barYellow]
        var index = -1
        for percentage in percentages{
            index += 1
            let DynamicView=UIView(frame: CGRect(x: CGFloat(currentX), y: CGFloat(y), width: CGFloat(Double(percentage)*Double(width)), height: CGFloat(height)))
            let label = UILabel()
            label.font = .systemFont(ofSize: 13, weight: .medium)
            label.textColor = .darkGray
            label.textAlignment = .center
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "\(text[index])\n\(Int(percentage * 100))%"
            
            if index == 0 {
                DynamicView.clipsToBounds = true
                DynamicView.layer.cornerRadius = 25
                DynamicView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMaxYCorner)
            } else if index == 2 {
                DynamicView.clipsToBounds = true
                DynamicView.layer.cornerRadius = 25
                DynamicView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
            }
            currentX+=Float(Double(percentages[index])*Double(width))
            DynamicView.backgroundColor=colors[index]
            
            DynamicView.addSubview(label)
            label.centerXAnchor.constraint(equalTo:DynamicView.centerXAnchor)
                        .isActive = true // ---- 1
            label.centerYAnchor.constraint(equalTo:DynamicView.centerYAnchor)
                .isActive = true
            self.ratioView.addSubview(DynamicView)
        }
    }
    
    func setProgressResult(sender: UIProgressView, data: Float){
        print(data)
        if data < 0.3 {
            sender.progressTintColor = .barRed
        } else if data < 0.6 {
            sender.progressTintColor = .barYellow
        } else if data < 1.3 {
            sender.progressTintColor = .barGreen
        } else if data < 1.6 {
            sender.progressTintColor = .barYellow
        } else {
            sender.progressTintColor = .barRed
        }
        
        sender.progress = data
    }
}

extension AnalyzeViewController: AnalyzeViewDelegate {
    func didSuccessGetAnalyze(_ result: AnalyzeResponse) {
        dismissIndicator()
        let response = result.result
        
        self.rcal = Double(response?.rcal ?? "0")
        self.todayLabel.text = response?.todayDate
        self.carbLabel.text = "\(Int(response?.totalCarb ?? 0) / 7)/\(response?.rcarb ?? "")"
        self.proLabel.text = "\(Int(response?.totalPro ?? 0) / 7)/\(response?.rpro ?? "")"
        self.fatLabel.text = "\(Int(response?.totalFat ?? 0) / 7)/\(response?.rfat ?? "")"
        analysis = response?.analysisDtos ?? [Analysis]()
        
        if response?.status == 1 {
            statusView.isHidden = true
            // 그래프에 들어갈 데이터들
            for i in analysis.reversed() {
                dates.append(i.date ?? "")
                values.append(Double(i.totalCal ?? 0))
            }
            
            setLineChart(dataPoints: dates, values: values)
            let carbPercent = Float(response?.ratioCarb ?? 0) / 100
            let proPercent = Float(response?.ratioPro ?? 0) / 100
            let fatPercent = Float(response?.ratioFat ?? 0) / 100
            
            drawStackedProgress(percentages: [carbPercent, proPercent, fatPercent], width: Float(ratioView.frame.width), height: Float(ratioView.frame.height), x: 0, y: 0)
        } else {
            statusView.isHidden = false
        }
        
        setProgressResult(sender: carbProgressView, data: Float(response?.totalCarb ?? 0) / 7 / (Float(response?.rcarb ?? "0") ?? 1))
        setProgressResult(sender: proProgressView, data: Float(response?.totalPro ?? 0) / 7 / (Float(response?.rpro ?? "0") ?? 1))
        setProgressResult(sender: fatProgressView, data: Float(response?.totalFat ?? 0) / 7 / (Float(response?.rfat ?? "0") ?? 1))
        
        carbPercentLabel.text = "\(Int(Float(response?.totalCarb ?? 0) / 7 / (Float(response?.rcarb ?? "0") ?? 1) * 100))%"
        proPercentLabel.text = "\(Int(Float(response?.totalPro ?? 0) / 7 / (Float(response?.rpro ?? "0") ?? 1) * 100))%"
        fatPercentLabel.text = "\(Int(Float(response?.totalFat ?? 0) / 7 / (Float(response?.rfat ?? "0") ?? 1) * 100))%"
    }
    
    func failedToRequest(message: String, code: Int) {
        dismissIndicator()
        presentAlert(message: message)
        if code == 403 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.changeRootViewController(LoginViewController())
            }
        }
    }
}
