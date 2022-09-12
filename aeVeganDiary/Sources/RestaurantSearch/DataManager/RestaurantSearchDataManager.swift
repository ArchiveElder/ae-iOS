//
//  RestaurantSearchDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/12.
//

import Alamofire

class RestaurantSearchDataManager {
    
    func postRestaurantSearch(_ parameters: RestaurantSearchInput, viewController: LargeCategoryViewController) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/api/categories", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: RestaurantSearchResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.getRestaurantSearch(result: response)
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
}
