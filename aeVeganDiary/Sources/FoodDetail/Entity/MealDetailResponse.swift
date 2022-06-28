//
//  MealDetailResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/28.
//

import Foundation

struct MealDetailResponse: Decodable {
    var data: [DetailRecord]
}

struct DetailRecord: Decodable {
    var text: String
    var cal: String
    var carb: String
    var protein: String
    var fat: String
    var image_url: String
    var date: String
    var time: String
    var amount: Double
}
