//
//  RegisterResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/03.
//

import Foundation

struct RegisterResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: RegisterResult?
    
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
        result = try? values.decode(RegisterResult.self, forKey: .result)
    }
}

struct RegisterResult: Decodable {
    var id: Int
}
