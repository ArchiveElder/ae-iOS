//
//  SearchBookmarkDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/29.
//

import Alamofire

class SearchBookmarkDataManager {
    func postBookmark(_ parameters: BookmarkInput, viewController: RestaurantSearchViewController) {
        AF.request("\(Constant.BASE_URL)/api/bookmark", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: BookmarkResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.bookmark(result: response)
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
