//
//  BookmarkDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/04.
//

import Alamofire

class BookmarkDataManager: BookmarkDataManagerDelegate {
    func postBookmark(_ parameters: BookmarkRequest, delegate: BookmarkViewDelegate) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/api/bookmark", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: BookmarkResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    if response.isSuccess {
                        delegate.didSuccessPostBookmark(response)
                    }
                    // 실패했을 때
                    else {
                        switch response.code {
                        case 2001, 2002: delegate.failedToRequest(message: "로그인 토큰이 만료되었습니다. 다시 로그인 해주세요", code: 403)
                        case 2145: delegate.failedToRequest(message: "이미 즐겨찾기한 음식점입니다", code: 0)
                        default: delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다", code: 0)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다", code: 0)
                }
            }
    }
}
