//
//  RestaurantSearchResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/12.
//

import Foundation

struct RestaurantSearchResponse : Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: RestaurantSearchResult?
    
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
        result = try? values.decode(RestaurantSearchResult.self, forKey: .result)
    }
}

struct RestaurantSearchResult : Decodable {
    var categories : [String]
    var size : Int
    var categoryList : [CategoryListDto]
}

struct CategoryListDto : Decodable {
    var bistroId : Int
    var isBookmark : Int
    var category : String?
    var name : String
    var roadAddr : String?
    var lnmAddr : String?
    var telNo : String?
}
