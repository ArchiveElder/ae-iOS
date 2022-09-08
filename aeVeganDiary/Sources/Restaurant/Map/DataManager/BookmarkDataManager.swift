//
//  BookmarkDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/04.
//

import Alamofire

class BookmarkDataManager {
    func postBookmark(_ parameters: BookmarkInput, viewController: MapViewController) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/api/bookmark", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: BookmarkResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.bookmark()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
