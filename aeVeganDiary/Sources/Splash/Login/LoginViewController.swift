//
//  LoginViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/28.
//

import UIKit
import KakaoSDKUser
import AuthenticationServices

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
    
    @IBOutlet weak var appleLoginButton: ASAuthorizationAppleIDButton!
    @IBAction func appleLoginButtonAction(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }


}

extension LoginViewController {
    func request(accessToken: String) {
        self.showIndicator()
        let input = LoginInput(accessToken: accessToken)
        LoginDataManager().login(input, viewController: self)
    }
    
    func requestAppleLogin(accessToken: String) {
        self.showIndicator()
        let input = LoginInput(accessToken: accessToken)
        AppleLoginDataManager().appleLogin(input, viewController: self)
    }
    
    func login(result: LoginResponse) {
        self.dismissIndicator()
        if result.signup {
            let vc = NicknameInitViewController()
            let navController = UINavigationController(rootViewController: vc)
            navController.view.backgroundColor = .white
            navController.navigationBar.isTranslucent = false
            self.changeRootViewController(navController)
        } else {
            UserDefaults.standard.setValue(result.userId, forKey: "UserId")
            UserDefaults.standard.setValue(result.token, forKey: "UserJwt")
            self.changeRootViewController(BaseTabBarController())
        }
        
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}

// MARK: - Apple Login Extensions

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    // 로그인 진행하는 화면 표출
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            
            if let authorizationCode = appleIDCredential.authorizationCode,
               let identityToken = appleIDCredential.identityToken,
               let tokenString = String(data: identityToken, encoding: .utf8) {
                print("tokenString: \(tokenString)")
                requestAppleLogin(accessToken: tokenString)
            }
            
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorization didcmpletewitherror")
    }
}
