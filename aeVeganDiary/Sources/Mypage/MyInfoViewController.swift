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
    lazy var checkNicknameDataManager : CheckNicknameDataManagerDelegate = CheckNicknameDataManager()
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet weak var editDoneButton: UIButton!
    
    //유저 조회 시 기존 닉네임
    var nickname = ""
    //중복 방지 눌렀을 때 텍스트 필드의 값
    var inputNickname = ""
    //중복 방지 ok된 텍스트 필드의 값
    var approvedNickname = ""
    //editdone에 보낼 최종 닉네임
    var resultNickname = ""
    //닉네임 텍스트 변경 되었는지
    var changeState : Bool = false
    var age = 0
    var height = "0"
    var weight = "0"
    var activity = 0
    
    
   // var checkNicknameResponse = CheckNicknameResponse?
    //var checkNickname = [MyInfoResult]
    
    
    @IBOutlet weak var checkNicknameButton: UIButton!
    
    @IBAction func checkNickname(_ sender: Any) {
        dismissKeyboard()
        inputNickname = nicknameTextField.text ?? ""
        var checkNicknameInput = CheckNicknameInput(nickname: inputNickname ?? "")
        checkNicknameDataManager.postNickname(checkNicknameInput, delegate: self)
        
        //viewdidload에서 입력된 닉네임이 현재 닉네임과 같으면 중복확인 버튼 비활성화하기
    }
    
    @IBAction func editDoneAction(_ sender: Any) {

        //중복 확인 안눌렀을 때 or 중복 확인 된 후에 값 변경했을 때
        if(changeState == true){
            presentBottomAlert(message: "닉네임을 중복 확인 해주세요.")
        } else if(changeState == false && approvedNickname == nicknameTextField.text && approvedNickname != ""){
            let input = MyInfoInput(age: Int(ageTextField.text!) ?? 0, height: self.heightTextField.text!, weight: self.weightTextField.text!, activity: activities[indexOfOneAndOnly ?? 1], nickname: approvedNickname)
            updateMyInfoDataManager.putMyInfoData(input, delegate: self)
            //navigationController?.popViewController(animated: true)
            self.dismiss(animated: true)
        }
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
                    activityButtons[index].backgroundColor = .systemGray5
                }
                sender.isSelected = true
                sender.backgroundColor = .mainGreen
                indexOfOneAndOnly = activityButtons.firstIndex(of: sender)
            }
            else {
                sender.isSelected = false
                sender.backgroundColor = .systemGray5
                indexOfOneAndOnly = nil
            }
        }
        else {
            sender.isSelected = true
            sender.backgroundColor = .mainGreen
            indexOfOneAndOnly = activityButtons.firstIndex(of: sender)
        }
        
    }
     
    //textfield 값 변경 감지 함수
    @objc func textFieldDidChange(_ sender: Any?) {
        
        //조회 된 닉네임과 텍스트 필드 내의 닉네임이 같을 때 (닉네임 변경 안했을 때)
        if(nickname == nicknameTextField.text){
            changeState = false
            approvedNickname = nickname
        } else {
            changeState = true
            approvedNickname = ""
        }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackButton()
        setNavigationTitle(title: "내 정보 수정")
        
        editDoneButton.backgroundColor = .middleGreen
        self.nicknameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        approvedNickname = nickname
        
        view.backgroundColor = .white
        dismissKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nicknameTextField.text = nickname
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
                activityButtons[index].backgroundColor = .systemGray5
            }
        }
        
        if(nickname == nicknameTextField.text){
            changeState = false
            approvedNickname = nickname
        } else {
            changeState = true
            approvedNickname = ""
        }
       

    }

}


extension MyInfoViewController : UpdateMyInfoViewDelegate {
    func didSuccessUpdateMyInfoData(_ result: UpdateMyInfoResponse) {
        print(result)
        UserDefaults.standard.setValue(result.result?.userId, forKey: "UserId")
        if result.result?.token != "" {
            UserManager.shared.jwt = result.result?.token ?? ""
        }
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

extension MyInfoViewController : CheckNicknameViewDelegate {
    func didSuccessCheckNickname(_ result: CheckNicknameResponse) {
        dismissIndicator()
        print(result)
        if(result.result?.exist == false) {
            presentBottomAlert(message:"닉네임 사용이 가능합니다.")
            changeState = false
            approvedNickname = inputNickname
        } else if(result.result?.exist == true) {
            presentBottomAlert(message:"닉네임이 이미 존재합니다.")
            approvedNickname = ""
        }
    }
}



//서버통신 보내서 exist 가 false 뜬 닉네임만 사용 가능
//닉네임 입력 안했을 때 닉네임 입력해주세요 토스트
