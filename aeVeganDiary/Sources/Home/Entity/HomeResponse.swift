//
//  HomeResponse.swift
//  aeVeganDiary
//
//  Created by κΆνμ on 2022/06/03.
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
    var mcal: Int
    var record: [Record]
}

struct Record: Decodable {
    var record_id: Int
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
