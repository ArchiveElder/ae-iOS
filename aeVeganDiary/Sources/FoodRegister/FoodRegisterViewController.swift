//
//  FoodRegisterViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/30.
//

import UIKit

class FoodRegisterViewController: BaseViewController {
    lazy var registerDataManager: RegisterDataManagerDelegate = RegisterDataManager()
    
    lazy var foodDetailDataManager : FoodDetailDataManagerDelegate = FoodDetailDataManager()
    
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
        let vc = SearchViewController()
        vc.rdate = self.rdate
        vc.meal = self.meal ?? 0
        vc.foodImage = self.foodImage
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet weak var changeView: UIView!
    
    @IBOutlet weak var recognizeInfoView: UIView!
    @IBAction func recognizeInfoButton(_ sender: Any) {
        recognizeInfoView.isHidden = !recognizeInfoView.isHidden
    }
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216))
    let dateFormatterA = DateFormatter()
    let dateFormatter24 = DateFormatter()
    
    // 서버통신 변수
    var rdate = ""
    var meal:Int? = nil
    var foodImage: UIImage? = nil
    var amount: Double = 200
    var cal: Double = 0
    var carb: Double = 0
    var pro: Double = 0
    var fat: Double = 0
    var id = SearchInput(id:0)
    var foodDetailResponse: FoodDetailResponse?
    var foodDetail = [FoodDetail]()
    
    var name: String = ""
    var calory: Double = 0.0
    
    var toMore = false
    
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
        amountTextField.addTarget(self, action: #selector(changeAmount), for: .editingDidEnd)
    }
    
    @objc func changeAmount() {
        if amountTextField.text == "" || amountTextField.text == "0" {
            amountTextField.text = String(amount)
        } else {
            let ratio = (Double(amountTextField.text!) ?? 1) / Double(amount)
            
            self.caloryLabel.text = "\(Int(cal * ratio))"
            self.carbLabel.text = "\(Int(carb * ratio))"
            self.proteinLabel.text = "\(Int(pro * ratio))"
            self.fatLabel.text = "\(Int(fat * ratio))"
        }
        
        print(cal)
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
        if search == 1 {
            foodImageViewHeight.constant = 0
            foodImageView.isHidden = true
            changeView.isHidden = true
            showIndicator()
            //FoodDetailDataManager().requestData(id, viewController: self)
            foodDetailDataManager.requestData(id, delegate: self)
        } else {
            foodImageViewHeight.constant = 320
            foodImageView.image = foodImage
            changeView.isHidden = false
            showIndicator()
            FoodPredictDataManager().foodPredict(foodImage ?? UIImage(), viewController: self)
        }
        
        if let foodImage = foodImage {
            foodImageViewHeight.constant = 320
            foodImageView.image = foodImage
            foodImageView.isHidden = false
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
        let alert = UIAlertController(title: "등록을 완료하시겠어요?", message: nil, preferredStyle: .alert)
        let actionDone = UIAlertAction(title: "완료", style: .default, handler: {_ in
            self.toMore = false
            self.register()
        })
        alert.addAction(actionDone)
        
        let actionMore = UIAlertAction(title: "완료하고 더 등록하기", style: .default, handler: {_ in
            self.toMore = true
            self.register()
            
        })
        alert.addAction(actionMore)
        
        let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func register() {
        self.showIndicator()
        self.dateFormatter24.dateFormat = "HH:mm"
        let time = self.dateFormatter24.string(from: self.datePicker.date)
        let input = RegisterRequest(text: self.foodNameLabel.text!, calory: self.caloryLabel.text!, carb: self.carbLabel.text!, protein: self.proteinLabel.text!, fat: self.fatLabel.text!, rdate: self.rdate, rtime: time, amount: Double(self.amountTextField.text!) ?? 0, meal: self.meal ?? 0)
        print(input)
        self.registerDataManager.postRegister(input, foodImage: self.foodImage ?? UIImage(), delegate: self)
    }

}

extension FoodRegisterViewController : FoodDetailViewDelegate {
    
    func didSuccessGetFoodDetailData(_ result: FoodDetailResponse) {
        dismissIndicator()
        self.foodDetailResponse = result
        self.foodDetail = result.result!.data
        foodNameLabel.text = foodDetail[0].name
        caloryLabel.text = String(foodDetail[0].calory)
        self.cal = foodDetail[0].calory
        carbLabel.text = String(foodDetail[0].carb)
        self.carb = foodDetail[0].carb
        proteinLabel.text = String(foodDetail[0].pro)
        self.pro = foodDetail[0].pro
        fatLabel.text = String(foodDetail[0].fat)
        self.fat = foodDetail[0].fat
    }
    
}

extension FoodRegisterViewController: RegisterViewDelegate {
    func didSuccessRegister(_ result: RegisterResponse) {
        dismissIndicator()
        if self.toMore {
            guard let pvc = self.presentingViewController else { return }

            self.dismiss(animated: true) {
                let vc = SelectTypeViewController()
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.rdate = self.rdate
                vc.meal = self.meal
                pvc.present(vc, animated: false)
            }
        } else {
            self.dismiss(animated: true)
        }
    }
    
    func foodPredict(result: FoodPredictResponse) {
        dismissIndicator()
        print(result)
        //self.foodCalory1.text = String(result.calory)
        //self.foodCalory2.text = String(result.calory)
        //self.foodName1.text = String(result.name)
        self.foodNameLabel.text = result.name
        self.amountTextField.text = "\(result.capacity ?? 0)"
        self.amount = Double(result.capacity ?? 0)
        self.caloryLabel.text = "\(result.calory ?? 0)"
        self.cal = result.calory ?? 0
        self.carbLabel.text = "\(result.carb ?? 0)"
        self.carb = result.carb ?? 0
        self.proteinLabel.text = "\(result.pro ?? 0)"
        self.pro = result.pro ?? 0
        self.fatLabel.text = "\(result.fat ?? 0)"
        self.fat = result.fat ?? 0
        
        self.notFoodLabel.text = "\(result.name ?? "")이(가) 아닌가요?"
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
