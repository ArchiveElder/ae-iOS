//
//  AnalyzeResponse.swift
//  aeVeganDiary
//
//  Created by κΆνμ on 2022/06/30.
//

import Foundation

struct AnalyzeResponse: Decodable {
    var status: Int
    var ratioCarb: Int?
    var ratioPro: Int?
    var ratioFat: Int?
    var totalCarb: Int?
    var totalPro: Int?
    var totalFat: Int?
    var analysisDtos: [Analysis]?
}

struct Analysis: Decodable {
    var date: String?
    var totalCal: Int?
}
