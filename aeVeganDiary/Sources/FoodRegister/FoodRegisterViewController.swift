//
//  FoodRegisterViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/30.
//

import UIKit

class FoodRegisterViewController: BaseViewController {
    // datePicker
    @IBOutlet weak var timeTextField: UITextField!
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216))
    let dateFormatterA = DateFormatter()
    let dateFormatter24 = DateFormatter()
    
    // 서버통신 변수
    var rdate = ""
    var meal:Int? = nil
    var foodImage = UIImage()
    var amount = 1.0
    
    @IBOutlet weak var foodImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mealLabel: UILabel!
    let mealText = ["아침", "점심", "저녁"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //NavigationController
        setNavigationTitle(title: "식사 등록하기")
        setBackButton()
        setDoneButton()
        
        dismissKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foodImageView.image = foodImage
        dateLabel.text = rdate
        mealLabel.text = "\(mealText[meal ?? 0]) 식사"
        
        let nowDate = Date()
        dateFormatterA.dateFormat = "a hh:mm"
        dateFormatterA.locale = Locale(identifier:"ko_KR")
        let convertNowStr = dateFormatterA.string(from: nowDate)
        timeTextField.text = convertNowStr
        
        datePicker.datePickerMode = .time
        // iOS 14 and above
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.sizeToFit()
        self.timeTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone), datePicker: datePicker, dateFormatter: dateFormatterA)
    }
    
    // datePicker에서 Done 누르면 실행
    @objc func tapDone() {
        if let datePicker = self.timeTextField.inputView as? UIDatePicker {
            // textField 업데이트
            self.timeTextField.text = dateFormatterA.string(from: datePicker.date)
        }
        // textField에서 커서 제거
        self.timeTextField.resignFirstResponder()
    }
    
    // 완료 버튼 설정
    func setDoneButton() {
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(done))
        
        self.navigationItem.setRightBarButton(doneButton, animated: false)
    }
    
    @objc func done() {
        showIndicator()
        dateFormatter24.dateFormat = "HH:mm"
        let time = dateFormatter24.string(from: datePicker.date)
        let input = RegisterInput(rdate: self.rdate, rtime: time, meal: self.meal ?? 0, creates: [Creates(text: "볶음밥", calory: "400", carb: "13", protein: "23", fat: "4", amount: self.amount)])
        print(input)
        RegisterDataManager().registerMeal(input, viewController: self)
    }
    /*
    // 인분/g 바꾸는 메뉴 생성
    @objc func showMeasure(sender : UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "단위를 선택해주세요.", preferredStyle: .actionSheet)

        let gAction = UIAlertAction(title: "g", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("g")
            sender.setTitle("g", for: .normal)
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        })
        
        let perAction = UIAlertAction(title: "인분", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("per")
            sender.setTitle("인분", for: .normal)
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(gAction)
        optionMenu.addAction(perAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
     }*/

}

extension FoodRegisterViewController {
    func postMeal() {
        dismissIndicator()
        self.dismiss(animated: true)
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
