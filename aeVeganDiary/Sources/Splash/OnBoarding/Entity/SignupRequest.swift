//
//  SignupRequest.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/23.
//

struct SignupRequest: Encodable {
    var nickname: String
    var age: Int
    var gender: Int
    var height: String
    var weight: String
    var activity: Int
}
