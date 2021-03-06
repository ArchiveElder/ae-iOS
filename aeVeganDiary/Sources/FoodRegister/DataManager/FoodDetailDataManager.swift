//
//  FoodDetailDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/25.
//

import Alamofire

class FoodDetailDataManager{
    func requestData(_ parameters: SearchInput, viewController: FoodRegisterViewController){
        AF.request("\(Constant.BASE_URL)/api/food", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: FoodDetailResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(response)
                    viewController.getData(result: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
