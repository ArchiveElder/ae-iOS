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
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var caloryLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var notFoodLabel: UILabel!
    @IBAction func changeFoodButtonAction(_ sender: Any) {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    @IBOutlet weak var changeView: UIView!
    
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216))
    let dateFormatterA = DateFormatter()
    let dateFormatter24 = DateFormatter()
    
    // 서버통신 변수
    var rdate = ""
    var meal:Int? = nil
    var foodImage = UIImage()
    var amount = 200
    var id = SearchInput(id:0)
    var foodDetailResponse: FoodDetailResponse?
    var foodDetail = [FoodDetail]()
    
    var name: String = ""
    var calory: Double = 0.0
    
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet var foodImageViewHeight: NSLayoutConstraint!
    
    var search = 0
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mealLabel: UILabel!
    
    
    let mealText = ["아침", "점심", "저녁"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //NavigationController
        setNavigationTitle(title: "식사 등록하기")
        
        if search == 0 {
            setDismissButton()
        } else {
            setToRootButton()
        }
        
        setDoneButton()
        
        dismissKeyboardWhenTappedAround()
    }
    
    func setToRootButton() {
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(self, action: #selector(toRoot), for: .touchUpInside)
        backButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addBackButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.setLeftBarButton(addBackButton, animated: false)
    }
    
    @objc func toRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if search == 0 {
            foodImageViewHeight.constant = 320
            foodImageView.image = foodImage
            changeView.isHidden = false
            showIndicator()
            FoodPredictDataManager().foodPredict(foodImage, viewController: self)
        } else {
            foodImageViewHeight.constant = 0
            foodImageView.isHidden = true
            changeView.isHidden = true
            showIndicator()
            FoodDetailDataManager().requestData(id, viewController: self)
        }
        
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
        let input = RegisterInput(text: "볶음밥", calory: "400", carb: "13", protein: "23", fat: "4", rdate: self.rdate, rtime: time, amount: Double(self.amount), meal: self.meal ?? 0)
        RegisterDataManager().registerMeal(input, foodImage, viewController: self)
    }

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
    
    func getData(result: FoodDetailResponse){
        dismissIndicator()
        self.foodDetailResponse = result
        self.foodDetail = result.data
        foodNameLabel.text = foodDetail[0].name
        caloryLabel.text = String(foodDetail[0].calory)
        carbLabel.text = String(foodDetail[0].carb)
        proteinLabel.text = String(foodDetail[0].pro)
        fatLabel.text = String(foodDetail[0].fat)
    }
    
    func foodPredict(result: FoodPredictResponse) {
        dismissIndicator()
        print(result)
        //self.foodCalory1.text = String(result.calory)
        //self.foodCalory2.text = String(result.calory)
        //self.foodName1.text = String(result.name)
        
    }
}
