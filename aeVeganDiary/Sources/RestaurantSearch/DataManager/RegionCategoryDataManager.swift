//
//  RegionCategoryDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/10.
//

import Alamofire

class RegionCategoryDataManager {
    func postRegionCategory(_ parameters: RegionInput, viewController: LargeCategoryViewController) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/api/bistromiddle", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: RegionResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.getMiddleRegion(result: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
