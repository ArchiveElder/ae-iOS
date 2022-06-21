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
                    print(oauthToken?.accessToken ?? "없엉...")
                    /// 로그인 관련 메소드 추가
                    
                    let vc = NicknameInitViewController()
                    let navController = UINavigationController(rootViewController: vc)
                    navController.view.backgroundColor = .white
                    navController.navigationBar.isTranslucent = false
                    self.changeRootViewController(navController)
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
                    print(oauthToken?.accessToken ?? "없엉...")
                    /// 로그인 관련 메소드 추가
                    let vc = NicknameInitViewController()
                    let navController = UINavigationController(rootViewController: vc)
                    navController.view.backgroundColor = .white
                    navController.navigationBar.isTranslucent = false
                    self.changeRootViewController(navController)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // Do any additional setup after loading the view.
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
