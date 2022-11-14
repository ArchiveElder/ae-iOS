//
//  PostScrapDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/14.
//

import Alamofire

class PostScrapDataManager: PostScrapDataManagerDelegate {
    func postScrap(_  userIdx:Int, parameters: ScrapRequest, delegate: PostScrapViewDelegate) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("http://15.164.40.10:8080/scrap/\(userIdx)", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: ScrapResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    delegate.didSuccessPostScrap(response)
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다", code: 0)
                }
            }
    }
}
