//
//  CookRecommDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/29.
//

import Alamofire

class CookRecommDataManager {
    func requestData(_ parameters: IngreInput, viewController: CookRecommViewController) {
        
        AF.request("http://3.35.123.36:8080/api/foodrecommend", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: CookRecommResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(response)
                    viewController.getRecomm(result: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
        
    }
}
