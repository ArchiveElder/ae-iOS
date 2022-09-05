//
//  BookmarkListResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/29.
//

import Foundation

struct BookmarkListResponse: Decodable {
    var count: Int
    var data: [BookmarkListData]?
}

struct BookmarkListData: Decodable {
    var bistroId: Int
    var category: String
    var name: String
    var roadAddr: String?
    var lnmAddr: String?
    var telNo: String?
    var la: String
    var lo: String
}
