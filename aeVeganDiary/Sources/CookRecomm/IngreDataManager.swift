//
//  IngreDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/28.
//

import Alamofire

class IngreDataManager{
    
    func getIngreData(viewController: RecommCookViewController){
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/api/ingredient", method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: IngreResponse.self){ response in
                switch response.result{
                case .success(let response):
                viewController.getIngreData(result: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        
    }
}
