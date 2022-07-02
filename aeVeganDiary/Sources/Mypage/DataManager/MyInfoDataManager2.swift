//
//  MyInfoDataManager2.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/02.
//

import Alamofire

class MyInfoDataManager2{
    
    func getMyInfoData(viewController: MyInfoViewController){
        AF.request("\(Constant.BASE_URL)/api/userinfo", method: .get, encoding: JSONEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: MyInfoResponse.self) {
                response in
                switch response.result{
                case .success(let response):
                    viewController.getData(result: response)
                    print("성공")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    func updateMyInfo(_ parameters: MyInfoInput, viewController: MyInfoViewController){
        AF.request("\(Constant.BASE_URL)/api/userupdate", method: .put, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
            .validate()
            .responseData(emptyResponseCodes: [200], completionHandler: { response in
                switch response.result {
                case .success( _):
                    //viewController.getData()
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
        })
    }
}
