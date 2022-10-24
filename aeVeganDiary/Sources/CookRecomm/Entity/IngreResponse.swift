//
//  IngreResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/28.
//

import Foundation

struct IngreResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: IngreResult?
    
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
        result = try? values.decode(IngreResult.self, forKey: .result)
    }
}

struct IngreResult : Decodable {
    var count: Int
    var data: [Ingre]
}

struct Ingre: Decodable {
    var id: Int
    var name: String
}

