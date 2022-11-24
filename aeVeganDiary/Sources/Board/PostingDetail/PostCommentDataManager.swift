//
//  PostCommentDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/15.
//

import Alamofire

class PostCommentDataManager: PostCommentDataManagerDelegate {
    func postComment(_  userIdx:Int, parameters: CommentRequest, delegate: PostCommentViewDelegate) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/community/comment/\(userIdx)", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: CommentResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    delegate.didSuccessPostComment(response)
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다", code: 0)
                }
            }
    }
}
