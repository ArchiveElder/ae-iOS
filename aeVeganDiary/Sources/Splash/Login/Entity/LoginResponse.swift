//
//  LoginResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/30.
//


struct LoginResponse: Decodable {
    var userId: Int
    var token: String
    var signup: Bool
}
