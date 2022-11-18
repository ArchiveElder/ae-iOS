//
//  ScrapDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/18.
//

import Foundation
import Alamofire
import RxSwift


class ScrapDataManager {
    static func getScrap(userIdx : Int, page: Int) -> Observable<[MyScrapLists]> {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        return Observable.create { observer -> Disposable in
            AF.request("http://15.164.40.10:8080/posting/myscrap/\(userIdx)?page=\(page)&sort=idx,desc", method: .get, headers: headers)
                .responseDecodable(of: MyScrapResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        print(data)
                        if response.response?.statusCode == 200 {
                            observer.onNext(data.postsLists ?? [])
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
