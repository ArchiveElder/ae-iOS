//
//  AnalyzeResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/30.
//

import Foundation

struct AnalyzeResponse: Codable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: AnalyzeResult?
    
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
        result = try? values.decode(AnalyzeResult.self, forKey: .result)
    }
}

struct AnalyzeResult: Codable {
    var status: Int
    var todayDate: String?
    var rcal: String?
    var rcarb: String?
    var rpro: String?
    var rfat: String?
    var ratioCarb: Int?
    var ratioPro: Int?
    var ratioFat: Int?
    var totalCarb: Int?
    var totalPro: Int?
    var totalFat: Int?
    var analysisDtos: [Analysis]?
}

struct Analysis: Codable {
    var date: String?
    var totalCal: Int?
}
