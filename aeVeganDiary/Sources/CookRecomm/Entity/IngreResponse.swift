//
//  IngreResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/28.
//

import Foundation

struct IngreResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: IngreResult
}

struct IngreResult : Decodable {
    var count: Int
    var data: [Ingre]
}

struct Ingre: Decodable {
    var id: Int
    var name: String
}

