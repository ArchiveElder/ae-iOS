//
//  RegisterDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/03.
//

import Alamofire

class RegisterDataManager {
    func registerMeal(_ parameters: RegisterInput, viewController: FoodRegisterViewController) {
        AF.request("\(Constant.BASE_URL)/api/record", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: RegisterResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.postMeal()
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
