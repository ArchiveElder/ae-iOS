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
    var result: SearchResult
}

struct SearchResult : Decodable {
    var count: Int
    var data: [Food]
}

struct Food: Decodable {
    var id: Int
    var name: String
}

