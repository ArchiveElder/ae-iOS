//
//  MapResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/07/29.
//

import Foundation

struct MapResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: MapResult?
    
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
        result = try? values.decode(MapResult.self, forKey: .result)
    }
}

struct MapResult: Decodable {
    var data: [MapData]
}

struct MapData: Decodable {
    var isBookmark: Int
    var bistro_id: Int
    var category: String
    var name: String
    var roadAddr: String
    var lnmAddr: String
    var telNo: String?
    var menuInfo: String
    var la: Double
    var lo: Double
}
