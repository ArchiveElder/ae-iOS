//
//  SignupResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/07/01.
//

import Foundation

struct SignupResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: SignupResult?
    
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
        result = try? values.decode(SignupResult.self, forKey: .result)
    }
}

struct SignupResult: Decodable {
    var token: String?
    var userId: String?
}
