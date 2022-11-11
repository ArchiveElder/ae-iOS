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
    static func getPosts(userIdx: Int, page: Int, size: Int) -> Observable<[Post]> {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        
        return Observable.create { observer -> Disposable in
            AF.request("\(Constant.BASE_URL)/posting/allposts/\(userIdx)?page=\(page)&size=\(size)", method: .get, headers: headers)
                .responseDecodable(of: BoardResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        print(data)
                        if response.response?.statusCode == 200 {
                            observer.onNext(data.postLists ?? [])
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
