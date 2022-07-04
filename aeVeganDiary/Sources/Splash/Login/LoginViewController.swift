//
//  LoginViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/28.
//

import UIKit
import KakaoSDKUser

class LoginViewController: BaseViewController {

    @IBAction func kakaoLoginButton(_ sender: Any) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("카카오 로그인 성공")
                    
                    _ = oauthToken
        
                    self.request(accessToken: oauthToken?.accessToken ?? "없엉...")
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")

                    //do something
                    _ = oauthToken
                    
                    self.request(accessToken: oauthToken?.accessToken ?? "없엉...")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // Do any additional setup after loading the view.
        
    }


}

extension LoginViewController {
    func request(accessToken: String) {
        self.showIndicator()
        let input = LoginInput(accessToken: accessToken)
        LoginDataManager().login(input, viewController: self)
    }
    
    func login(result: LoginResponse) {
        self.dismissIndicator()
        UserDefaults.standard.setValue(result.userId, forKey: "UserId")
        UserDefaults.standard.setValue(result.token, forKey: "UserJwt")
        if result.signup {
            let vc = NicknameInitViewController()
            let navController = UINavigationController(rootViewController: vc)
            navController.view.backgroundColor = .white
            navController.navigationBar.isTranslucent = false
            self.changeRootViewController(navController)
        } else {
            self.changeRootViewController(BaseTabBarController())
        }
        
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
