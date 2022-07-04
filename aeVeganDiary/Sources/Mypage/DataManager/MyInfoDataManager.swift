//
//  MyInfoDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/02.
//

import Alamofire

class MyInfoDataManager{
    
    func getMyInfoData(viewController: MypageViewController){
        AF.request("\(Constant.BASE_URL)/api/userinfo", method: .get, encoding: JSONEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: MyInfoResponse.self) {
                response in
                switch response.result{
                case .success(let response):
                    viewController.getData(result: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    
}
