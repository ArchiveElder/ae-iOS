//
//  SearchResponse2.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/04.
//

import Foundation

struct SearchResponse2: Decodable {
    var count: Int
    var data: [FoodDetail]
}

struct FoodDetail: Decodable {
    var name: String
    var capacity: Int
    var calory: Double
    var carb: Double
    var pro: Double
    var fat: Double
}
