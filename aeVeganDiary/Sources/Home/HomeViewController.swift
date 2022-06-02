//
//  HomeViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/29.
//

import UIKit
import FSCalendar

class HomeViewController: BaseViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var datePickButton: UIButton!
    @IBAction func datePickButtonAction(_ sender: Any) {
        let datePicker : UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        //datePicker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControlEvents.valueChanged)
        
        datePicker.backgroundColor = .white
        datePicker.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        datePicker.layer.cornerRadius = 10
        self.view.addSubview(datePicker)
    }
    
    @IBOutlet weak var datePickTextField: UITextField!
    
    @IBOutlet weak var weekCalendarView: FSCalendar!
    
    @IBOutlet weak var tabCollectionView: UICollectionView!
    @IBOutlet weak var mealCollectionView: UICollectionView!
    
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
        tabCollectionView.backgroundColor = .lightGray
        
        mealCollectionView.delegate = self
        mealCollectionView.dataSource = self
        mealCollectionView.register(UINib(nibName: "RegisterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RegisterCollectionViewCell")
        
        self.datePickTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
    }
    
    @objc func tapDone() {
        if let datePicker = self.datePickTextField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy.MM.dd."
            self.datePickTextField.text = dateformatter.string(from: datePicker.date)
        }
        self.datePickTextField.resignFirstResponder()
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabCollectionView {
            let mealList = ["아침", "점심", "저녁"]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCollectionViewCell", for: indexPath) as! TabCollectionViewCell
            cell.mealLabel.text = mealList[indexPath.row]
            return cell
        } else {
            let number = ["1", "2", "3"]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegisterCollectionViewCell", for: indexPath) as! RegisterCollectionViewCell
            cell.numberLabel.text = number[indexPath.row]
            cell.registerMealButton.addTarget(self, action: #selector(toRegister(sender:)), for: .touchUpInside)
            return cell
        }
    }
    
    @objc func toRegister(sender : UIButton) {
        let vc = SelectTypeViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tabCollectionView {
            return CGSize(width: tabCollectionView.frame.width / 3, height: tabCollectionView.frame.height)
        } else {
            return CGSize(width: mealCollectionView.frame.width, height: 170)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCollectionView {
            mealCollectionView.scrollToItem(at: NSIndexPath(item: indexPath.row, section: 0) as IndexPath, at: .right, animated: false)
        }
    }
    
}

extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        // iOS 14 and above
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.sizeToFit()
        
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
