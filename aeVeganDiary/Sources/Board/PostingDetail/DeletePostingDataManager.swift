//
//  DeletePostingDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/14.
//

import Alamofire

class DeletePostingDataManager: DeletePostingDataManagerDelegate {
    func deletePosting(_  userIdx:Int, postIdx:Int, parameters: DeletePostingRequest, delegate: DeletePostingViewDelegate) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        let serializer = DataResponseSerializer(emptyResponseCodes: Set([200, 204, 205]))
        AF.request("http://15.164.40.10:8080/posting/\(userIdx)/\(postIdx)", method: .delete, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .response(responseSerializer: serializer) { response in
                switch response.result {
                case .success(let response):
                    delegate.didSuccessDeletePosting()
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다", code: 0)
                }
            }
    }
}
