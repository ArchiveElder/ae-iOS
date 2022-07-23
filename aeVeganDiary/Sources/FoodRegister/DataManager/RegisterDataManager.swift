//
//  RegisterDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/03.
//

import Alamofire

class RegisterDataManager {
    func registerMeal(_ parameters: RegisterInput, _ foodImage: UIImage, viewController: FoodRegisterViewController) {
        let param: [String : Any] = [
                "image": foodImage,
                "text" : parameters.text,
                "calory": parameters.calory,
                "carb": parameters.carb,
                "protein": parameters.protein,
                "fat": parameters.fat,
                "rdate": parameters.rdate,
                "rtime": parameters.rtime,
                "amount": parameters.amount,
                "meal": parameters.meal
            ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if let image = foodImage.jpegData(compressionQuality: 0.5) {
                multipartFormData.append(image, withName: "image", fileName: "\(image).jpeg", mimeType: "image/jpeg")
            }
        }, to: "\(Constant.BASE_URL)/api/record", usingThreshold: UInt64.init(), method: .post, headers: Constant.HEADERS)
        .validate()
        .responseDecodable(of: RegisterResponse.self) { response in
            switch response.result {
            case .success(let response):
                viewController.postMeal()
                print(response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
}
