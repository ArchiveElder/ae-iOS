//
//  BookmarkDeleteDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/26.
//

import Alamofire

class BookmarkDeleteDataManager: BookmarkDeleteDataManagerDelegate {
    func deleteBookmark(_ parameters: BookmarkRequest, delegate: BookmarkDeleteViewDelegate) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/chaebbi/bookmark", method: .delete, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: BookmarkResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    if response.isSuccess {
                        delegate.didSuccessDeleteBookmark(response)
                    }
                    // 실패했을 때
                    else {
                        switch response.code {
                        case 2001, 2002: delegate.failedToRequest(message: "로그인 토큰이 만료되었습니다. 다시 로그인 해주세요", code: 403)
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
