//
//  PostDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/13.
//

import Alamofire

class PostDataManager: PostDataManagerDelegate {
    func postPosting(_ parameters: PostRequest, multipartFileList: [UIImage]?, userIdx: Int, delegate: PostViewDelegate) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        let serializer = DataResponseSerializer(emptyResponseCodes: Set([200, 204, 205]))
        let param: [String : Any] = [
            "title":parameters.title,
            "content":parameters.content,
            "boardName":parameters.boardName
        ]
        
        print(param)
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if let multipartFileList = multipartFileList {
                for i in multipartFileList {
                    if let image = i.jpegData(compressionQuality: 0.5) {
                        multipartFormData.append(image, withName: "multipartFileList", fileName: "\(image).jpeg", mimeType: "image/jpeg")
                    }
                }
            }
        }, to: "http://15.164.40.10:8080/posting/\(userIdx)", usingThreshold: UInt64.init(), method: .post, headers: headers)
        .validate()
        .response(responseSerializer: serializer) { response in
            switch response.result {
            case .success(let response):
                print(response)
                delegate.didSuccessPost()
            case .failure(let error):
                print(error.localizedDescription)
                delegate.failedToPost(message: "서버와의 연결이 원활하지 않습니다", code: 0)
            }
        }
    }
}
