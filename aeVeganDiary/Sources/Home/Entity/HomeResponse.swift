//
//  HomeResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/03.
//

import Foundation

struct HomeResponse: Decodable {
    var totalCalory: Int
    var totalCarb: Int
    var totalPro: Int
    var totalFat: Int
    var recommCalory: Int
    var recommCarb: Int
    var recommPro: Int
    var recommFat: Int
    var records: [Records]
}

struct Records: Decodable {
    var meal: Int
    var record: [Record]
    var mcal: Int
}

struct Record: Decodable {
    var text: String
    var date: String
    var calory: String
    var carb: String
    var protein: String
    var fat: String
    var rdate: String
    var rtime: String
    var amount: Double
}
