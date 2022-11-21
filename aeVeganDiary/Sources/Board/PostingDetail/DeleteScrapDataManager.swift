//
//  DeleteScrapDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/14.
//

import Alamofire

class DeleteScrapDataManager: DeleteScrapDataManagerDelegate {
    func deleteScrap(_  userIdx:Int, parameters: ScrapRequest, delegate: DeleteScrapViewDelegate) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/community/scrap/\(userIdx)", method: .delete, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: ScrapDeleteResponse.self) { response in
                switch response.result {
                case .success(let response):
                    delegate.didSuccessDeleteScrap(response)
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다", code: 0)
                }
            }
    }
}
