//
//  FoodDetailResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/25.
//

import Foundation

struct FoodDetailResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: FoodDetailResult
}

struct FoodDetailResult : Decodable{
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
