//
//  NicknameInitViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/09.
//

import UIKit

class NicknameInitViewController: BaseViewController {

    lazy var checkNicknameDataManager : CheckNicknameDataManagerDelegate = CheckNicknameDataManager()
    //중복 방지 눌렀을 때 텍스트 필드의 값
    var inputNickname = ""
    //중복 방지 ok된 텍스트 필드의 값
    var approvedNickname = ""
    //닉네임 텍스트 변경 되었는지
    var changeState : Bool = true
    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButtonAction(_ sender: Any) {
        
        //중복 확인 안눌렀을 때 or 중복 확인 된 후에 값 변경했을 때
        if(changeState == true){
            presentBottomAlert(message: "닉네임을 중복 확인 해주세요.")
        } else if (changeState == false && nicknameTextField.text != "") && (ageTextField.text != "") && (indexOfOneAndOnly != nil) {
            let vc = BodyInitViewController()
            vc.nickname = approvedNickname
            vc.age = Int(ageTextField.text!) ?? 0
            vc.gender = indexOfOneAndOnly!
            navigationController?.pushViewController(vc, animated: true)
        } else {
            presentBottomAlert(message: "정보를 모두 입력해주세요")
        }
        
    }
    
    @IBAction func checkNickname(_ sender: Any) {
        dismissKeyboard()
        inputNickname = nicknameTextField.text ?? ""
        var checkNicknameInput = CheckNicknameInput(nickname: inputNickname ?? "")
        checkNicknameDataManager.postNickname(checkNicknameInput, delegate: self)
    }
    
    @IBOutlet weak var checkNicknameButton: UIButton!
    
    @IBOutlet weak var nicknameTextField: UITextField!
    
    
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
        
        self.nicknameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        view.backgroundColor = .white
        setNavigationTitle(title: "프로필 설정")
        dismissKeyboardWhenTappedAround()
    }
    
    //textfield 값 변경 감지 함수
    @objc func textFieldDidChange(_ sender: Any?) {
        
        //조회 된 닉네임과 텍스트 필드 내의 닉네임이 같을 때 (닉네임 변경 안했을 때)
        if(approvedNickname == nicknameTextField.text){
            changeState = false
        } else {
            changeState = true
            approvedNickname = ""
        }
        //print(changeState)
        //print("텍스트 필드 변경된 값:",nicknameTextField.text)
       }

}

extension NicknameInitViewController : CheckNicknameViewDelegate {
    func didSuccessCheckNickname(_ result: CheckNicknameResponse) {
        dismissIndicator()
        print(result)
        if(result.result?.exist == false) {
            presentBottomAlert(message:"닉네임 사용이 가능합니다.")
            changeState = false
            approvedNickname = nicknameTextField.text ?? ""
            
        } else if(result.result?.exist == true) {
            presentBottomAlert(message:"닉네임이 이미 존재합니다.")
            changeState = true
            approvedNickname = ""
        }
    }
    
    func failedToRequest(message: String, code: Int) {
        
    }
    
    
}
