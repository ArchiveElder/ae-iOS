//
//  MapDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/07/29.
//

import Alamofire

class MapDataManager {
    func requestRestaurant(viewController: MapViewController) {
        AF.request("\(Constant.BASE_URL)/api/allbistro", method: .get, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: MapResponse.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.getResList(result: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
