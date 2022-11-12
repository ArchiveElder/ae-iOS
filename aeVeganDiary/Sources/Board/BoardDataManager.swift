//
//  BoardDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/11.
//

import Foundation
import Alamofire
import RxSwift

class BoardDataManager {
    static func getPosts(userIdx: Int, category: String, page: Int) -> Observable<[Post]> {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        return Observable.create { observer -> Disposable in
            AF.request("http://15.164.40.10:8080/posting/board/\(userIdx)/\(category)?page=\(page)&sort=idx,desc", method: .get, headers: headers)
                .responseDecodable(of: BoardResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        print(data)
                        if response.response?.statusCode == 200 {
                            observer.onNext(data.postsList ?? [])
                        }
                    case .failure(let error):
                        observer.onError(error)
                        print(error.localizedDescription)
                    }
                }
            return Disposables.create()
        }
    }
}
