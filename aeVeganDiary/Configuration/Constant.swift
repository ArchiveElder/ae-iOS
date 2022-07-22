//
//  Constant.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/28.
//

import Alamofire

struct Constant {
    static let BASE_URL = "http://ec2-15-165-139-29.ap-northeast-2.compute.amazonaws.com:8080"
    
    static var HEADERS: HTTPHeaders = ["Authorization": "Bearer \(UserDefaults.standard.string(forKey: "UserJwt") ?? "")"]
}
