//
//  HomeResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/03.
//

import Foundation

struct HomeResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: HomeResult?
    
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
        result = try? values.decode(HomeResult.self, forKey: .result)
    }
}

struct HomeResult: Decodable {
    var totalCalory: Int
    var totalCarb: Int
    var totalPro: Int
    var totalFat: Int
    var recommCalory: Int
    var recommCarb: Int
    var recommPro: Int
    var recommFat: Int
    var records: [Records]
}

struct Records: Decodable {
    var meal: Int
    var mcal: Int
    var record: [Record]
}

struct Record: Decodable {
    var record_id: Int
    var text: String
    var date: String
    var calory: String
    var carb: String
    var protein: String
    var fat: String
    var rdate: String
    var rtime: String
    var amount: Double
}
