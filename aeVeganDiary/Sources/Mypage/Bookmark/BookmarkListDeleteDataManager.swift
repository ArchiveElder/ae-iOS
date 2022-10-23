//
//  BookmarkListDeleteDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/29.
//

import Alamofire

class BookmarkListDeleteDataManager {
    func deleteBookmark(_ parameters: BookmarkRequest, viewController: BookmarkViewController) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/api/del/bookmark", method: .delete, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: BookmarkResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.bookmarkDelete()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
