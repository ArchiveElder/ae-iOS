//
//  IngreDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/28.
//

import Alamofire

class IngreDataManager : IngreDataManagerDelegate{
    
    func getIngreData(delegate: IngreViewDelegate){
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/chaebbi/ingredient", method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: IngreResponse.self){ response in
                switch response.result{
                case .success(let response):
                    if response.isSuccess{
                        delegate.didRetrieveIngreData(response)
                    }
                    else{
                        switch response.code {
                        case 2001, 2002: delegate.failedToRequest(message: "로그인 토큰이 만료되었습니다. 다시 로그인 해주세요", code: 403)
                        default: delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다", code: 0)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다.", code: 0)
                }
                
            }
        
    }
}
