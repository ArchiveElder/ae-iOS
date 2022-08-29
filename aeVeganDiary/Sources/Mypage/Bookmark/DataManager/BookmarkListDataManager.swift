//
//  BookmarkListDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/29.
//

import Alamofire

class BookmarkListDataManager {
    func getBookmarkList(viewController: BookmarkViewController) {
        AF.request("\(Constant.BASE_URL)/api/bookmarklist", method: .get, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: BookmarkListResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.getList(response: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
