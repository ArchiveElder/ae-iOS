//
//  RecommendResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/06.
//

import Foundation

struct RecommendResponse: Decodable {
    var result: [Result]
}

struct Result: Decodable {
    var id: Int
    var vegetarian: Int
    var name: String
    var capacity: Int
    var calory: Int
    var carb: Int
    var pro: Int
    var fat: Int
}
