//
//  SignupInput.swift
//  aeVeganDiary
//
//  Created by κΆνμ on 2022/07/01.
//

import Foundation

struct SignupInput: Encodable {
    var name: String
    var age: Int
    var gender: Int
    var height: String
    var weight: String
    var activity: Int
}
