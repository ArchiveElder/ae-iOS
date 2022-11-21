//
//  BodyInitViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/09.
//

import UIKit

class BodyInitViewController: BaseViewController {
    
    lazy var signupDataManager: SignupDataManagerDelegate = SignupDataManager()

    @IBAction func doneButtonAction(_ sender: Any) {
        if (heightTextField.text != "") && (weightTextField.text != "") && indexOfOneAndOnly != nil {
            showIndicator()
            let input = SignupRequest(nickname: self.nickname, age: self.age, gender: self.gender, height: heightTextField.text!, weight: weightTextField.text!, activity: activities[indexOfOneAndOnly ?? 25])
            signupDataManager.postSignup(input, delegate: self)
        } else {
            presentBottomAlert(message: "정보를 모두 입력해주세요")
        }
        
    }
    
    var nickname = ""
    var age = 0
    var gender = 0
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    var indexOfOneAndOnly: Int?
    var activities = [25, 33, 40]
    @IBOutlet var activityButtons: [UIButton]!
    @IBAction func activityButtonAction(_ sender: UIButton) {
        if indexOfOneAndOnly != nil {
            if !sender.isSelected {
                for index in activityButtons.indices {
                    activityButtons[index].isSelected = false
                    activityButtons[index].backgroundColor = .lightGray
                }
                sender.isSelected = true
                sender.backgroundColor = .darkGreen
                indexOfOneAndOnly = activityButtons.firstIndex(of: sender)
            }
            else {
                sender.isSelected = false
                sender.backgroundColor = .lightGray
                indexOfOneAndOnly = nil
            }
        }
        else {
            sender.isSelected = true
            sender.backgroundColor = .darkGreen
            indexOfOneAndOnly = activityButtons.firstIndex(of: sender)
        }
        
        /*if indexOfOneAndOnly != nil && ageTextField.text != "" {
            nextButton.isEnabled = true
        }
        else {
            nextButton.isEnabled = false
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setBackButton()
        setNavigationTitle(title: "프로필 설정")
        dismissKeyboardWhenTappedAround()
    }

}

extension BodyInitViewController: SignupViewDelegate {
    func didSuccessSignup(_ result: SignupResponse) {
        dismissIndicator()
        UserDefaults.standard.setValue(false, forKey: "SignUp")
        UserDefaults.standard.setValue(result.result?.userId, forKey: "UserId")
        UserManager.shared.jwt = result.result?.token ?? ""
        self.changeRootViewController(BaseTabBarController())
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
