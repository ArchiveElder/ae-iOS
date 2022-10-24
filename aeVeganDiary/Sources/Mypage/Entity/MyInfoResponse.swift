//
//  MyInfoResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/02.
//

import Foundation

struct MyInfoResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: MyInfoResult
}

struct MyInfoResult : Decodable {
    var name: String
    var gender: Int
    var age: Int
    var height: String
    var weight: String
    var icon: Int
    var activity: Int
}
