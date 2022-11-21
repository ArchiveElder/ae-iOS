//
//  MyInfoDataManager2.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/02.
//

import Alamofire

class UpdateMyInfoDataManager : UpdateMyInfoDataManagerDelegate{
    func putMyInfoData(_ parameters: MyInfoInput, delegate: UpdateMyInfoViewDelegate){
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        print(headers)
        AF.request("\(Constant.BASE_URL)/chaebbi/user/info-update", method: .put, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: UpdateMyInfoResponse.self) { response in
                //.responseData(emptyResponseCodes: [200], completionHandler: { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    print(response.code)
                    if response.isSuccess {
                        delegate.didSuccessUpdateMyInfoData(response)
                    }
                    // 실패했을 때
                    else {
                        switch response.code {
                        case 2001, 2002, 2003: delegate.failedToRequest(message: "로그인 토큰이 만료되었습니다. 다시 로그인 해주세요", code: 403)
                        case 2122:
                            delegate.failedToRequest(message: "나이를 다시 입력해주세요.", code: 0)
                        case 2123:
                            delegate.failedToRequest(message: "키를 입력해주세요.", code: 0)
                        case 2124:
                            delegate.failedToRequest(message: "키를 다시 입력해주세요.", code: 0)
                        case 2125:
                            delegate.failedToRequest(message: "몸무게를 입력해주세요.", code: 0)
                        case 2126:
                            delegate.failedToRequest(message: "몸무게를 다시 입력해주세요.", code: 0)
                        case 2128:
                            delegate.failedToRequest(message: "활동 수준을 선택해주세요.", code: 0)
                        default: delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다", code: 0)
                            }
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
            }
    }
}
