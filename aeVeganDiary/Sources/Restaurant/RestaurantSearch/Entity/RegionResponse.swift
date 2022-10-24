//
//  RegionResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/10.
//

import Foundation

struct RegionResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: RegionResult
}

struct RegionResult : Decodable {
    var data: [String]
}
