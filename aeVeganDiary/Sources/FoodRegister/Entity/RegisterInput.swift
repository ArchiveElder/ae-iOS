//
//  RegisterInput.swift
//  aeVeganDiary
//
//  Created by κΆνμ on 2022/06/03.
//

import Foundation

struct RegisterInput: Encodable {
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

