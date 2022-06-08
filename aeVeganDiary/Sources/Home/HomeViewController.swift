//
//  HomeViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/29.
//

import UIKit
import FSCalendar

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var datePickTextField: UITextField!
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216))
    
    @IBOutlet weak var weekCalendarView: FSCalendar!
    
    @IBOutlet weak var arcProgressBar: ArcProgressView!
    @IBOutlet weak var recommKcal: UILabel!
    @IBOutlet weak var consumeKcal: UILabel!
    
    @IBOutlet weak var tabCollectionView: UICollectionView!
    @IBOutlet weak var mealCollectionView: UICollectionView!
    
    let dateFormatter = DateFormatter()
    
    var selected: Int? = 0
    
    @IBOutlet weak var calLabel: UILabel!
    
    // ProgressBar
    @IBOutlet weak var carbProgressBar: UIProgressView!
    @IBOutlet weak var carbLabel: UILabel!
    
    @IBOutlet weak var proteinProgressBar: UIProgressView!
    @IBOutlet weak var proteinLabel: UILabel!
    
    @IBOutlet weak var fatProgressBar: UIProgressView!
    @IBOutlet weak var fatLabel: UILabel!
    
    // MARK: 서버 통신 변수 선언
    var homeResponse: HomeResponse?
    var records = [Records]()
    
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var recommCal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationTitle(title: "기록")
        
        //FSCalendar Custom
        weekCalendarView.delegate = self
        weekCalendarView.dataSource = self
        weekCalendarView.scope = .week
        weekCalendarView.locale = Locale(identifier: "ko_KR")
        weekCalendarView.headerHeight = 8
        weekCalendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        weekCalendarView.appearance.weekdayTextColor = .darkGray
        
        //CollectionView
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView.register(UINib(nibName: "TabCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TabCollectionViewCell")
        tabCollectionView.backgroundColor = .clear
        
        mealCollectionView.delegate = self
        mealCollectionView.dataSource = self
        mealCollectionView.register(UINib(nibName: "RegisterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RegisterCollectionViewCell")
        mealCollectionView.register(UINib(nibName: "MealCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MealCollectionViewCell")
        mealCollectionView.backgroundColor = .clear
        
        
        dateFormatter.dateFormat = "yyyy.MM.dd."
        self.datePickTextField.text = dateFormatter.string(from: Date())
        self.weekCalendarView.select(Date())
        self.datePickTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone), datePicker: datePicker)
        
        // ProgressView
        
        carbProgressBar.clipsToBounds = true
        carbProgressBar.layer.cornerRadius = 4
        carbProgressBar.clipsToBounds = true
        carbProgressBar.layer.sublayers![1].cornerRadius = 4// 뒤에 있는 회색 track
        carbProgressBar.subviews[1].clipsToBounds = true
        
        proteinProgressBar.clipsToBounds = true
        proteinProgressBar.layer.cornerRadius = 4
        proteinProgressBar.clipsToBounds = true
        proteinProgressBar.layer.sublayers![1].cornerRadius = 4// 뒤에 있는 회색 track
        proteinProgressBar.subviews[1].clipsToBounds = true
        
        fatProgressBar.clipsToBounds = true
        fatProgressBar.layer.cornerRadius = 4
        fatProgressBar.clipsToBounds = true
        fatProgressBar.layer.sublayers![1].cornerRadius = 4// 뒤에 있는 회색 track
        fatProgressBar.subviews[1].clipsToBounds = true
        
        arcProgressBar.setProgressOne(to: 1, withAnimation: false, maxSpeed: 45.0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        request(dateText: datePickTextField.text!)
    }

    
    // datePicker에서 Done 누르면 실행
    @objc func tapDone() {
        if let datePicker = self.datePickTextField.inputView as? UIDatePicker {
            // textField 업데이트
            self.datePickTextField.text = dateFormatter.string(from: datePicker.date)
            self.weekCalendarView.select(datePicker.date)
        }
        // textField에서 커서 제거
        self.datePickTextField.resignFirstResponder()
        
        request(dateText: dateFormatter.string(from: datePicker.date))
    }

}

// MARK: FSCalendar
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        datePickTextField.text = dateFormatter.string(from: date)
        datePicker.date = date
        request(dateText: dateFormatter.string(from: date))
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
         return false
    }
}

// MARK: CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 탭 collectionView
        if collectionView == tabCollectionView {
            let mealList = ["아침", "점심", "저녁"]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCollectionViewCell", for: indexPath) as! TabCollectionViewCell
            cell.mealLabel.text = mealList[indexPath.row]
            cell.kcalLabel.isHidden = true
            cell.nullView.isHidden = false
            cell.kcal.isHidden = true
            if records.count != 0 && records[indexPath.row].mcal != 0 {
                cell.kcalLabel.isHidden = false
                cell.nullView.isHidden = true
                cell.kcalLabel.text = String(records[indexPath.row].mcal)
                cell.kcal.isHidden = false
            }
            
            if selected == indexPath.row {
                cell.tabBackgroundView.backgroundColor = .white
            } else {
                cell.tabBackgroundView.backgroundColor = .lGray
            }
            
            return cell
        } else {
            // 식사 collectionView
            if records.count != 0 && records[indexPath.row].record.count != 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCollectionViewCell", for: indexPath) as! MealCollectionViewCell
                cell.records = records[indexPath.row]
                cell.addButton.addTarget(self, action: #selector(toRegister(sender:)), for: .touchUpInside)
                cell.productVC = self
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegisterCollectionViewCell", for: indexPath) as! RegisterCollectionViewCell
                cell.registerMealButton.addTarget(self, action: #selector(toRegister(sender:)), for: .touchUpInside)
                return cell
            }
            
        }
    }
    
    // 식단 등록하기 버튼 누르면 팝업 띄움
    @objc func toRegister(sender : UIButton) {
        let vc = SelectTypeViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.rdate = datePickTextField.text ?? ""
        vc.meal = selected
        present(vc, animated: false)
    }
    
    // collectionView 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tabCollectionView {
            return CGSize(width: tabCollectionView.frame.width / 3 - 1.2, height: tabCollectionView.frame.height)
        } else {
            return CGSize(width: mealCollectionView.frame.width, height: mealCollectionView.frame.height)
        }
        
    }
    
    // 탭 collectionView의 cell들 누르면 실행되는 코드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCollectionView {
            mealCollectionView.scrollToItem(at: NSIndexPath(item: indexPath.row, section: 0) as IndexPath, at: .right, animated: false)
            selected = indexPath.row
            collectionView.reloadData()
        }
    }
    
}


// MARK: 서버 통신
extension HomeViewController {
    func request(dateText: String) {
        showIndicator()
        let input = HomeInput(date: dateText)
        HomeDataManager().requestData(input, viewController: self)
    }
    
    func getData(result: HomeResponse) {
        dismissIndicator()
        self.homeResponse = result
        self.records = result.records
        
        let cal = result.recommCalory - result.totalCalory
        recommKcal.text = "\(String(result.recommCalory)) kcal"
        consumeKcal.text = "\(String(result.totalCalory)) kcal"
        
        if cal < 0 {
            self.calLabel.text = "0 kcal"
        } else {
            self.calLabel.text = "\(String(cal)) kcal"
        }
        
        self.carbLabel.text = "\(result.totalCarb) / \(result.recommCarb)"
        self.proteinLabel.text = "\(result.totalPro) / \(result.recommPro)"
        self.fatLabel.text = "\(result.totalFat) / \(result.recommFat)"
        
        self.records.sort(by: { $0.meal < $1.meal })
        self.tabCollectionView.reloadData()
        self.mealCollectionView.reloadData()
        let firstIndex = records.firstIndex(where: { $0.mcal == 0 }) ?? 0
        print(firstIndex)
        selected = firstIndex
        tabCollectionView.scrollToItem(at: IndexPath(item: firstIndex, section: 0), at: .left, animated: false)
        mealCollectionView.scrollToItem(at: IndexPath(item: firstIndex, section: 0), at: .left, animated: false)
        
        setProgressResult(sender: carbProgressBar, data: Float(result.totalCarb) / Float(result.recommCarb))
        setProgressResult(sender: proteinProgressBar, data: Float(result.totalPro) / Float(result.recommPro))
        setProgressResult(sender: fatProgressBar, data: Float(result.totalFat) / Float(result.recommFat))
        arcProgressBar.setProgressOne(to: Double(result.totalCarb) / Double(result.recommCarb), withAnimation: false, maxSpeed: 45)
    }
    
    func setProgressResult(sender: UIProgressView, data: Float){
        if data < 0.3 {
            sender.progressTintColor = .barRed
        } else if data < 0.6 {
            sender.progressTintColor = .barYellow
        } else {
            sender.progressTintColor = .barGreen
        }
        
        sender.progress = data
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
