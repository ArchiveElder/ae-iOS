//
//  NicknameInitViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/09.
//

import UIKit

class NicknameInitViewController: BaseViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButton(_ sender: Any) {
        navigationController?.pushViewController(BodyInitViewController(), animated: true)
    }
    
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
