//
//  FoodPredictDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/04.
//

import Alamofire

class FoodPredictDataManager {
    func foodPredict(_ foodImage: UIImage, viewController: FoodRegisterViewController) {
        let param: [String : Any] = [
                "file": foodImage
            ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if let image = foodImage.jpegData(compressionQuality: 1) {
                multipartFormData.append(image, withName: "file", fileName: "\(image).jpeg", mimeType: "image/jpeg")
            }
            print(param)
        }, to: "http://3.35.123.36:8080/api/foodpredict", usingThreshold: UInt64.init(), method: .post)
        .validate()
        .responseDecodable(of: FoodPredictResponse.self) { response in
            switch response.result {
            case .success(let response):
                viewController.foodPredict(result: response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
}
