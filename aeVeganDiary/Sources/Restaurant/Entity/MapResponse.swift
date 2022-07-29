//
//  MapResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/07/29.
//

import Foundation

struct MapResponse: Decodable {
    var data: [MapData]
}

struct MapData: Decodable {
    var category: String
    var name: String
    var roadAddr: String
    var lnmAddr: String
    var telNo: String?
    var menuInfo: String
    var la: String
    var lo: String
}
