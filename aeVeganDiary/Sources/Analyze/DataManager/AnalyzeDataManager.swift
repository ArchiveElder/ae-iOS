//
//  AnalyzeDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/30.
//

import Alamofire

class AnalyzeDataManager {
    func requestData(viewController: AnalyzeViewController) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/api/analysis", method: .get, headers: headers)
            .validate()
            .responseDecodable(of: AnalyzeResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(response)
                    viewController.getData(response: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
