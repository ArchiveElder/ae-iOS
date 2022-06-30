//
//  HomeDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/03.
//

import Alamofire

class HomeDataManager {
    func requestData(_ parameters: HomeInput, viewController: HomeViewController) {
        AF.request("\(Constant.BASE_URL)/api/daterecord", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: HomeResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.getData(result: response)
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
