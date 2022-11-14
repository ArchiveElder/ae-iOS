//
//  PostThumbUpDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/13.
//

import Alamofire

class PostThumbUpDataManager: PostThumbUpDataManagerDelegate {
    func postThumbUp(_  userIdx:Int, parameters: ThumbUpRequest, delegate: PostThumbUpViewDelegate) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("http://15.164.40.10:8080/thumbup/\(userIdx)", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: ThumbUpResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    delegate.didSuccessPostThumbUp(response)
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다", code: 0)
                }
            }
    }
}
