//
//  MyInfoDataManager2.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/02.
//

import Alamofire

class MyInfoDataManager2{
    func updateMyInfo(_ parameters: MyInfoInput, viewController: MyInfoViewController){
        AF.request("\(Constant.BASE_URL)/api/userupdate", method: .put, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
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
