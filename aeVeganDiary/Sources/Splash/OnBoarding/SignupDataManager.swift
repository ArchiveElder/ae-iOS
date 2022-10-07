//
//  SignupDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/07/01.
//

import Alamofire

class SignupDataManager {
    func postSignUp(_ parameters: SignupInput, viewController: BodyInitViewController) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/api/signup", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseData(emptyResponseCodes: [200], completionHandler: { response in
                switch response.result {
                case .success( _):
                    viewController.getData()
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
        })
    }
}
