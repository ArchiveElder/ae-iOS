//
//  SearchBookmarkDeleteDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/30.
//

import Alamofire

class SearchBookmarkDeleteDataManager {
    func deleteBookmark(_ parameters: SearchBookmarkInput, viewController: RestaurantSearchViewController) {
        AF.request("\(Constant.BASE_URL)/api/del/bookmark", method: .delete, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: SearchBookmarkResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.bookmarkDelete()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
