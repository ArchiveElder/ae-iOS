//
//  LoginDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/30.
//

import Alamofire

class LoginDataManager: LoginDataManagerDelegate {
    func postLogin(_ parameters: LoginRequest, delegate: LoginViewDelegate) {
        AF.request("\(Constant.BASE_URL)/api/v2/login", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(response)
                    // 성공했을 때
                    if response.isSuccess {
                        delegate.didSuccessLogin(response)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
}
