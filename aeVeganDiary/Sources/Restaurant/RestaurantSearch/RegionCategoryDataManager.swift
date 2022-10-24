//
//  RegionCategoryDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/10.
//

import Alamofire

class RegionCategoryDataManager : RegionDataManagerDelegate {
    func postRegionCategory(_ parameters: RegionInput, delegate:RegionViewDelegate) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/api/bistromiddle", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: RegionResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess{
                        delegate.didSuccessGetMiddleRegion(response)
                    }
                    else{
                        switch response.code {
                        case 2001, 2002: delegate.failedToRequest(message: "로그인 토큰이 만료되었습니다. 다시 로그인 해주세요", code: 403)
                        case 2142:
                            delegate.failedToRequest(message: "도시를 선택해주세요", code: 0)
                        default: delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다", code: 0)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
