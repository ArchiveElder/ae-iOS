//
//  MyInfoDataManager2.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/02.
//

import Alamofire

class MyInfoDataManager2{
    func putMyInfoData(_ parameters: MyInfoInput, viewController: MyInfoViewController){
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/api/userupdate", method: .put, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseData(emptyResponseCodes: [200], completionHandler: { response in
                switch response.result {
                case .success( _):
                    viewController.update()
                case .failure(let error):
                    print(error.localizedDescription)
                }
        })
    }
}
