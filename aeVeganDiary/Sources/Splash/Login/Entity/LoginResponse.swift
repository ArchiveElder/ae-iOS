//
//  LoginResponse.swift
//  aeVeganDiary
//
//  Created by κΆνμ on 2022/06/30.
//


struct LoginResponse: Decodable {
    var userId: Int
    var token: String
    var signup: Bool
}
