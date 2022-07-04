//
//  SearchDataManager2.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/04.
//
import Alamofire

class SearchDataManager2{
    func requestData(_ parameters: SearchInput, viewController: SearchViewController){
        AF.request("\(Constant.BASE_URL)/api/food", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: SearchResponse2.self) { response in
                switch response.result {
                case .success(let response):
                    //viewController.searchResponse2 = response
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
