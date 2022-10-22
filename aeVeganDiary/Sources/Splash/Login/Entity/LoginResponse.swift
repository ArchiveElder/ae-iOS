//
//  LoginResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/30.
//

struct LoginResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: LoginResult?
    
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
        result = try? values.decode(LoginResult.self, forKey: .result)
    }
}

struct LoginResult: Decodable {
    var userId: Int?
    var token: String?
    var signup: Bool?
}
