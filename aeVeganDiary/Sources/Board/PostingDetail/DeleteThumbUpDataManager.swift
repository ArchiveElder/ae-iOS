//
//  DeleteThumbUpDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/14.
//

import Alamofire

class DeleteThumbUpDataManager: DeleteThumbUpDataManagerDelegate {
    func deleteThumbUp(_  userIdx:Int, parameters: ThumbUpRequest, delegate: DeleteThumbUpViewDelegate) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/community/thumbup/\(userIdx)", method: .delete, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: ThumbUpDeleteResponse.self) { response in
                switch response.result {
                case .success(let response):
                    delegate.didSuccessDeleteThumbUp(response)
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다", code: 0)
                }
            }
    }
}

