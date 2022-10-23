//
//  RegisterRequest.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/23.
//

import Foundation

struct RegisterRequest: Encodable {
    var text: String
    var calory: String
    var carb: String
    var protein: String
    var fat: String
    var rdate: String
    var rtime: String
    var amount: Double
    var meal: Int
}
