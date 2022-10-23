//
//  BookmarkListResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/29.
//

import Foundation

struct BookmarkListResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: BookmarkListResult?
    
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
        result = try? values.decode(BookmarkListResult.self, forKey: .result)
    }
}

struct BookmarkListResult: Decodable {
    var count: Int
    var data: [BookmarkListData]?
}

struct BookmarkListData: Decodable {
    var bistroId: Int
    var category: String
    var name: String
    var roadAddr: String?
    var lnmAddr: String?
    var telNo: String?
    var la: String
    var lo: String
}
