//
//  SignupDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/07/01.
//

import Alamofire

class SignupDataManager: SignupDataManagerDelegate {
    func postSignup(_ parameters: SignupRequest, delegate: SignupViewDelegate) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/api/signup", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: SignupResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess {
                        delegate.didSuccessSignup(response)
                    }
                    // 실패했을 때
                    else {
                        switch response.code {
                        case 2001, 2002, 2003: delegate.failedToRequest(message: "로그인 토큰이 만료되었습니다. 다시 로그인 해주세요", code: 403)
                        case 2129: delegate.failedToRequest(message: "이름을 입력해주세요", code: 0)
                        case 2130: delegate.failedToRequest(message: "이름을 45자 이하로 설정해주세요", code: 0)
                        case 2132: delegate.failedToRequest(message: "나이를 1 이상으로 설정해주세요", code: 0)
                        case 2135, 2136: delegate.failedToRequest(message: "키를 1 이상으로 설정해주세요", code: 0)
                        case 2137, 2138: delegate.failedToRequest(message: "몸무게를 1 이상으로 설정해주세요", code: 0)
                        default: delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다", code: 0)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다", code: 0)
                }
        }
    }
}
