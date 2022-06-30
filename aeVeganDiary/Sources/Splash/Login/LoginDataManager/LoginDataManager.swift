//
//  LoginDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/30.
//

import Alamofire

class LoginDataManager {
    func login(_ parameters: LoginInput, viewController: LoginViewController) {
        AF.request("\(Constant.BASE_URL)/api/login", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default )
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
