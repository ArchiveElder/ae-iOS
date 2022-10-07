//
//  SearchDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/26.
//

import Alamofire

class SearchDataManager{
    
    func getSearchData(viewController: SearchViewController){
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/api/foodname", method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: SearchResponse.self){ response in
                switch response.result{
                case .success(let response):
                viewController.getData(result: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        
    }
}
    
