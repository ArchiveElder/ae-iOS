//
//  FoodPredictResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/04.
//

struct FoodPredictResponse: Decodable {
    var name: String?
    var capacity: Int?
    var calory: Double?
    var carb: Double?
    var pro: Double?
    var fat: Double?
}
