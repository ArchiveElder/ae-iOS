//
//  IngreDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/28.
//

import Alamofire

class IngreDataManager{
    
    func getIngreData(viewController: CookRecommViewController){
        AF.request("\(Constant.BASE_URL)/api/foodname", method: .get, encoding: JSONEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: IngreResponse.self){ response in
                switch response.result{
                case .success(let response):
                viewController.getData(result: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        
    }
}
