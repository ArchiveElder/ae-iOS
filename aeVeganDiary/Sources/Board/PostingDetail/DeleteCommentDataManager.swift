//
//  DeleteCommentDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/15.
//

import Alamofire

class DeleteCommentDataManager: DeleteCommentDataManagerDelegate {
    func deleteComment(_  userIdx:Int, parameters: DeleteCommentRequest, delegate: DeleteCommentViewDelegate) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/community/comment/\(userIdx)", method: .delete, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: DeleteCommentResponse.self) { response in
                switch response.result {
                case .success(let response):
                    delegate.didSuccessDeleteComment(response)
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다", code: 0)
                }
            }
    }
}
