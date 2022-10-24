//
//  DeleteUserResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/10/24.
//

import Foundation

struct DeleteUserResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: String
}
