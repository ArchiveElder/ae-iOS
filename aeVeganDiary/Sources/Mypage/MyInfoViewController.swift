//
//  MyInfoViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/30.
//

import UIKit

class MyInfoViewController: BaseViewController {
    
    lazy var updateMyInfoDataManager : UpdateMyInfoDataManagerDelegate = UpdateMyInfoDataManager()
    lazy var deleteUserDataManager : DeleteUserDataManagerDelegate = DeleteUserDataManager()
    
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    
    var age = 0
    var height = "0"
    var weight = "0"
    var activity = 0
    
    @IBAction func editDoneAction(_ sender: Any) {
        let input = MyInfoInput(age: Int(ageTextField.text!) ?? 0, height: self.heightTextField.text!, weight: self.weightTextField.text!, activity: activities[indexOfOneAndOnly ?? 1])
        //UpdateMyInfoDataManager().putMyInfoData(input, viewController: self)
        updateMyInfoDataManager.putMyInfoData(input, delegate: self)
        // 서버 통신 결과는 여기서 작성하면 안됨! 통신 실패할수도 있기 때문에
    }
    
    @IBAction func deleteUerButtonAction(_ sender: Any) {
        presentAlert(title: "정말 탈퇴하시겠어요?", message: "탈퇴하면 모든 정보가 삭제됩니다.", isCancelActionIncluded: true, preferredStyle: .alert, handler: {_ in
            self.deleteUserDataManager.deleteUserData(DeleteUserRequest(), delegate: self)
        })
    }
    
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
                sender.backgroundColor = .mainGreen
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
            sender.backgroundColor = .mainGreen
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
        dismissKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ageTextField.text = String(age)
        heightTextField.text = String(height)
        weightTextField.text = String(weight)
        indexOfOneAndOnly = activities.firstIndex(of: activity)
        // 버튼 outlet collection 배열에서 indexOfOneAndOnly 인 인덱스를 찾아서 그 인덱스에 해당하는 버튼만 selected로 설정
        for index in activityButtons.indices {
            if index == indexOfOneAndOnly {
                activityButtons[index].isSelected = true
                activityButtons[index].backgroundColor = .mainGreen
            } else {
                activityButtons[index].isSelected = false
                activityButtons[index].backgroundColor = .lightGray
            }
        }
    }

}


extension MyInfoViewController : UpdateMyInfoViewDelegate {
    func didSuccessUpdateMyInfoData(_ result: UpdateMyInfoResponse) {
        //서버통신 성공하면 view를 pop 해준다
        navigationController?.popViewController(animated: true)
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

extension MyInfoViewController : DeleteUserViewDelegate {
    func didSuccessDeleteUser(_ result: DeleteUserResponse) {
        dismissIndicator()
        
        let vc = LoginViewController()
        let navController = UINavigationController(rootViewController: vc)
        self.changeRootViewController(navController)
    }
}
