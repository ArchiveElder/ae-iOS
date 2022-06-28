//
//  SearchResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/26.
//

import Foundation

struct SearchResponse: Decodable {
    var count: Int
    var data: [Food]
}

struct Food: Decodable {
    var id: Int
    var name: String
}
/*
struct SearchResponse: Codable {
    let data: Food
}

struct Food: Codable{
    let id: CLong
    let name: String
}
*/
