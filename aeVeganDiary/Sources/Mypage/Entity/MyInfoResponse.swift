//
//  MyInfoResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/02.
//

import Foundation

struct MyInfoResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: MyInfoResult?
    
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
        result = try? values.decode(MyInfoResult.self, forKey: .result)
    }
}

struct MyInfoResult : Decodable {
    var name: String
    var gender: Int
    var age: Int
    var height: String
    var weight: String
    var icon: Int
    var activity: Int
}
