//
//  FoodDetailResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/25.
//

import Foundation

struct FoodDetailResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: FoodDetailResult?
    
    private enum CodingKeys: String, CodingKey {
        case isSuccess
        case code
        case message
        case result
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isSuccess = try! values.decode(Bool.self, forKey: .isSuccess)
        code = try! values.decode(Int.self, forKey: .code)
        message = try! values.decode(String.self, forKey: .message)
        result = try? values.decode(FoodDetailResult.self, forKey: .result)
    }
}

struct FoodDetailResult : Decodable{
    var count: Int
    var data: [FoodDetail]
}

struct FoodDetail: Decodable {
    var name: String
    var capacity: Int
    var calory: Double
    var carb: Double
    var pro: Double
    var fat: Double
}
