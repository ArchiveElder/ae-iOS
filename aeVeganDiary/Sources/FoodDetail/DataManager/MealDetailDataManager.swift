//
//  MealDetailDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/28.
//

import Alamofire

class MealDetailDataManager {
    func requestData(_ parameters: MealDetailInput, viewController: MealDetailViewController) {
        AF.request("\(Constant.BASE_URL)/api/detailrecord", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: MealDetailResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.getData(result: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
