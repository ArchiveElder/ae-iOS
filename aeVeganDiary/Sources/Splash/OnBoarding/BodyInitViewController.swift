//
//  BodyInitViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/09.
//

import UIKit

class BodyInitViewController: BaseViewController {

    @IBAction func doneButton(_ sender: Any) {
        if (heightTextField.text != "") && (weightTextField.text != "") && indexOfOneAndOnly != nil {
            showIndicator()
            let input = SignupInput(name: self.name, age: self.age, gender: self.gender, height: heightTextField.text!, weight: weightTextField.text!, activity: activities[indexOfOneAndOnly ?? 25])
            SignupDataManager().signUp(input, viewController: self)
        } else {
            presentBottomAlert(message: "정보를 모두 입력해주세요")
        }
        
    }
    
    var name = ""
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

extension BodyInitViewController {
    func getData() {
        dismissIndicator()
        self.changeRootViewController(BaseTabBarController())
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
