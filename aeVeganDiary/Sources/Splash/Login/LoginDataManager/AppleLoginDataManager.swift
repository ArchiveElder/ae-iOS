//
//  AppleLoginDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/09/05.
//

import Alamofire

class AppleLoginDataManager {
    func appleLogin(_ parameters: LoginInput, viewController: LoginViewController) {
        AF.request("\(Constant.BASE_URL)/api/apple-login", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default )
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.login(result: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
