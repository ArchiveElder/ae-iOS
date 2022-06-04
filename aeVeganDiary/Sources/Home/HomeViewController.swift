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
    
    var mealKcal: [Int] = []
    
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
        mealCollectionView.backgroundColor = .clear
        
        dateFormatter.dateFormat = "yyyy.MM.dd."
        self.datePickTextField.text = dateFormatter.string(from: Date())
        self.weekCalendarView.select(Date())
        self.datePickTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone), datePicker: datePicker)
        
        // ProgressView
        carbProgressBar.transform = carbProgressBar.transform.scaledBy(x: 1, y: 2)
        proteinProgressBar.transform = proteinProgressBar.transform.scaledBy(x: 1, y: 2)
        fatProgressBar.transform = fatProgressBar.transform.scaledBy(x: 1, y: 2)
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
            /*if mealKcal[indexPath.row] == 0  {
                
            }
            else {
                cell.kcalLabel.isHidden = false
                cell.nullView.isHidden = true
                cell.kcalLabel.text = String(mealKcal[indexPath.row])
                cell.kcal.isHidden = false
            }*/
            
            if selected == indexPath.row {
                cell.tabBackgroundView.backgroundColor = .white
            } else {
                cell.tabBackgroundView.backgroundColor = .lGray
            }
            
            return cell
        } else {
            // 식사 collectionView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegisterCollectionViewCell", for: indexPath) as! RegisterCollectionViewCell
            cell.registerMealButton.addTarget(self, action: #selector(toRegister(sender:)), for: .touchUpInside)
            return cell
        }
    }
    
    // 식단 등록하기 버튼 누르면 팝업 띄움
    @objc func toRegister(sender : UIButton) {
        let vc = SelectTypeViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
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
        
        if cal < 0 {
            self.calLabel.text = "0 kcal"
        } else {
            self.calLabel.text = "\(String(cal)) kcal"
        }
        
        self.carbLabel.text = "\(result.totalCarb) / \(result.recommCarb)"
        self.proteinLabel.text = "\(result.totalPro) / \(result.recommPro)"
        self.fatLabel.text = "\(result.totalFat) / \(result.recommFat)"
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
