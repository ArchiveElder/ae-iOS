//
//  BookmarkDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/04.
//

import Alamofire

class BookmarkDataManager {
    func postBookmark(_ parameters: BookmarkInput, viewController: MapViewController) {
        AF.request("\(Constant.BASE_URL)/api/bookmark", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
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
