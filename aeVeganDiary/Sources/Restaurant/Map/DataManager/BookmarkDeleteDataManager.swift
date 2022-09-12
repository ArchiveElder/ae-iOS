//
//  BookmarkDeleteDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/26.
//

import Alamofire

class BookmarkDeleteDataManager {
    func deleteBookmark(_ parameters: BookmarkInput, viewController: MapViewController) {
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
