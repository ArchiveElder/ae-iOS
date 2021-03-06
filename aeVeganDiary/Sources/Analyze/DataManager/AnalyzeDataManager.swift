//
//  AnalyzeDataManager.swift
//  aeVeganDiary
//
//  Created by κΆνμ on 2022/06/30.
//

import Alamofire

class AnalyzeDataManager {
    func requestData(viewController: AnalyzeViewController) {
        AF.request("\(Constant.BASE_URL)/api/analysis", method: .get, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: AnalyzeResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.getData(response: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
