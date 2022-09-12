//
//  BookmarkListDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/29.
//

import Alamofire

class BookmarkListDataManager {
    func getBookmarkList(viewController: BookmarkViewController) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/api/bookmarklist", method: .get, headers: headers)
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
