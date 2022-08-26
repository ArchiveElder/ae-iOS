//
//  BookmarkDeleteDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/26.
//

import Alamofire

class BookmarkDeleteDataManager {
    func deleteBookmark(_ parameters: BookmarkInput, viewController: MapViewController) {
        AF.request("\(Constant.BASE_URL)/api/del/bookmark", method: .delete, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
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
