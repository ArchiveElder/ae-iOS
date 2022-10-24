//
//  FoodDetailEditDataManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/24.
//

import Alamofire

class FoodDetailEditDataManager: FoodDetailEditDataManagerDelegate {
    func postFoodDetailEdit(_ parameters: FoodDetailEditRequest, foodImage: UIImage?, delegate: FoodDetailEditViewDelegate) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        let param: [String : Any] = [
                "recordId": parameters.recordId,
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
            if let image = foodImage?.jpegData(compressionQuality: 0.5) {
                multipartFormData.append(image, withName: "image", fileName: "\(image).jpeg", mimeType: "image/jpeg")
            }
        }, to: "\(Constant.BASE_URL)/api/record-update", usingThreshold: UInt64.init(), method: .post, headers: headers)
        .validate()
        .responseDecodable(of: RegisterResponse.self) { response in
            switch response.result {
            case .success(let response):
                // 성공했을 때
                if response.isSuccess {
                    delegate.didSuccessFoodDetailEdit(response)
                }
                // 실패했을 때
                else {
                    switch response.code {
                    case 2001, 2002: delegate.failedToRequest(message: "로그인 토큰이 만료되었습니다. 다시 로그인 해주세요", code: 403)
                    case 2101, 2102, 2103, 2104, 2105, 2106, 2107, 2108, 2109: delegate.failedToRequest(message: "값을 모두 입력해주세요", code: 0)
                    case 2112, 2113: delegate.failedToRequest(message: "식사 시간을 입력해주세요", code: 0)
                    case 2114, 2115: delegate.failedToRequest(message: "식사량을 입력해주세요", code: 0)
                    default: delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다", code: 0)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다", code: 0)
            }
        }
    }
  
}
