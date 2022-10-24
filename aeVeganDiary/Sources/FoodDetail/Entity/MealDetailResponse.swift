//
//  MealDetailResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/28.
//

import Foundation

struct MealDetailResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: MealDetailResult?
    
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
        result = try? values.decode(MealDetailResult.self, forKey: .result)
    }
}

struct MealDetailResult: Decodable {
    var data: [DetailRecord]
}

struct DetailRecord: Decodable {
    var text: String
    var cal: String
    var carb: String
    var protein: String
    var fat: String
    var image_url: String?
    var date: String
    var time: String
    var amount: Double
    var meal: Int
}
