//
//  NicknameInitViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/09.
//

import UIKit

class NicknameInitViewController: BaseViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButtonAction(_ sender: Any) {
        if (nameTextField.text != "") && (ageTextField.text != "") && (indexOfOneAndOnly != nil) {
            let vc = BodyInitViewController()
            vc.name = nameTextField.text!
            vc.age = Int(ageTextField.text!) ?? 0
            vc.gender = indexOfOneAndOnly!
            navigationController?.pushViewController(vc, animated: true)
        } else {
            presentBottomAlert(message: "정보를 모두 입력해주세요")
        }
        
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    var indexOfOneAndOnly: Int?
    @IBOutlet var genderButtons: [UIButton]!
    @IBAction func genderSelect(_ sender: UIButton) {
        if indexOfOneAndOnly != nil {
            if !sender.isSelected {
                for index in genderButtons.indices {
                    genderButtons[index].isSelected = false
                    genderButtons[index].backgroundColor = .lightGray
                }
                sender.isSelected = true
                sender.backgroundColor = .darkGreen
                indexOfOneAndOnly = genderButtons.firstIndex(of: sender)
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
            indexOfOneAndOnly = genderButtons.firstIndex(of: sender)
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
        setNavigationTitle(title: "프로필 설정")
        dismissKeyboardWhenTappedAround()
    }

}
