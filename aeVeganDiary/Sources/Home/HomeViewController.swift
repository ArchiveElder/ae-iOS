//
//  HomeViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/29.
//

import UIKit
import FSCalendar

class HomeViewController: BaseViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var datePickTextField: UITextField!
    
    @IBOutlet weak var weekCalendarView: FSCalendar!
    
    @IBOutlet weak var tabCollectionView: UICollectionView!
    @IBOutlet weak var mealCollectionView: UICollectionView!
    
    let dateFormatter = DateFormatter()
    
    var selected: Int? = 0
    
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
        
        dateFormatter.dateFormat = "yyyy.MM.dd."
        self.datePickTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        self.datePickTextField.text = dateFormatter.string(from: Date())
        
        self.view.backgroundColor = .lightGray
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showIndicator()
        let input = HomeInput(date: "2022.06.01.")
        HomeDataManager().requestData(input, viewController: self)
    }*/

    
    // datePicker에서 Done 누르면 실행
    @objc func tapDone() {
        if let datePicker = self.datePickTextField.inputView as? UIDatePicker {
            // textField 업데이트
            self.datePickTextField.text = dateFormatter.string(from: datePicker.date)
        }
        // textField에서 커서 제거
        self.datePickTextField.resignFirstResponder()
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 탭 collectionView
        if collectionView == tabCollectionView {
            let mealList = ["아침", "점심", "저녁"]
            let mealKcal = [114, 0, 0]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCollectionViewCell", for: indexPath) as! TabCollectionViewCell
            cell.mealLabel.text = mealList[indexPath.row]
            if mealKcal[indexPath.row] == 0  {
                cell.kcalLabel.isHidden = true
                cell.nullView.isHidden = false
                cell.kcal.isHidden = true
            }
            else {
                cell.kcalLabel.isHidden = false
                cell.nullView.isHidden = true
                cell.kcalLabel.text = String(mealKcal[indexPath.row])
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
            let number = ["1", "2", "3"]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegisterCollectionViewCell", for: indexPath) as! RegisterCollectionViewCell
            cell.numberLabel.text = number[indexPath.row]
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
            return CGSize(width: mealCollectionView.frame.width, height: 170)
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

extension UITextField {
    // datePicker 설정
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        // iOS 14 and above
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.sizeToFit()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd."
        let date = dateFormatter.date(from: self.text ?? "2022.01.01")
        datePicker.date = date!
        
        
        self.inputView = datePicker
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}

extension HomeViewController {
    func getData() {
        print("됐다!")
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
