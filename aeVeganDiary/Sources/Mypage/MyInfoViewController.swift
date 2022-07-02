//
//  MyInfoViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/30.
//

import UIKit

class MyInfoViewController: BaseViewController {
    
    @IBOutlet var EditButton: UIButton!
    @IBOutlet var ageField: UITextField!
    @IBOutlet var heightField: UITextField!
    @IBOutlet var weightField: UITextField!
    
    @IBAction func EditDone(_ sender: Any) {
        let input = MyInfoInput(age: Int(ageField.text!) ?? 0, height: self.heightField.text!, weight: self.weightField.text!, activity: activities[indexOfOneAndOnly ?? 25])
        MyInfoDataManager2().updateMyInfo(input, viewController: self)
        let vc = MypageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: 서버 통신 변수 선언
    var myInfoResponse : MyInfoResponse?
    
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
            nextButton.isEnabled = falfse
        }*/
    }
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackButton()
        setNavigationTitle(title: "내 정보 수정")
        
        view.backgroundColor = .white
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showIndicator()
        MyInfoDataManager2().getMyInfoData(viewController: self)
        
    }

}

//MARK: 서버 통신
extension MyInfoViewController {
    
    func getData(result: MyInfoResponse){
        dismissIndicator()
        self.myInfoResponse = result
        
        ageField.text = String(result.age)
        heightField.text = result.height
        weightField.text = result.weight
        
    }
}
