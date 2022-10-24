//
//  SearchResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/26.
//

import Foundation

struct SearchResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: SearchResult?
    
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
        result = try? values.decode(SearchResult.self, forKey: .result)
    }
}

struct SearchResult : Decodable {
    var count: Int
    var data: [Food]
}

struct Food: Decodable {
    var id: Int
    var name: String
}

