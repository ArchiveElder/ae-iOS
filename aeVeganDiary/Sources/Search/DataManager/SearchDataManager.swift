//
//  SearchDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/26.
//

import Alamofire

class SearchDataManager{
    
    func getSearchData(viewController: SearchViewController){
        AF.request("\(Constant.BASE_URL)/api/foodname", method: .get, encoding: JSONEncoding.default, headers: Constant.HEADERS)
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
    
/*
    func getData(completion : @escaping (NetworkResult<Any>)->Void) {
        
        let header : HTTPHeaders = ["Content-Type" : "application/json"]
        
        let dataRequest = AF.request("\(Constant.BASE_URL)/api/daterecord", method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData {
            dataResponse in
            switch dataResponse.result {
            case.success(let response):
                guard let statusCode = dataResponse.response?.statusCode else{return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
                
            case .failure : completion(.pathErr)
                
            }
        }
    }
    
    private func judgeStatus(by statusCode:Int, _ data : Data) ->
    NetworkResult<Any> {
        switch statusCode{
        case 200: return isValidData(data:data)
        case 400: return .pathErr //요청이 잘못됨
        case 500: return .serverErr //서버 에러
        default: return .networkFail
        }
}
    private func isValidData(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try?
                decoder.decode(SearchResponse.self, from:data) else {return .pathErr}
        return . success(decodedData.data)
    }
}
 
*/
