//
//  EditPostDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/21.
//

import Alamofire

class EditPostDataManager: EditPostDataManagerDelegate {
    func getEditing(userIdx: Int, postIdx: Int, delegate: EditPostViewDelegate) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/community/posting/editpost/\(userIdx)/\(postIdx)", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: EditPostResponse.self) { response in
                switch response.result {
                case .success(let response):
                    delegate.didSuccessGetEdit(response: response)
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToGetEdit(message: "서버와의 연결이 원활하지 않습니다", code: 0)
                }
            }
    }
}
