//
//  RegionResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/10.
//

import Foundation

struct RegionResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: RegionResult?
    
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
        result = try? values.decode(RegionResult.self, forKey: .result)
    }
}

struct RegionResult : Decodable {
    var data: [String]
}
