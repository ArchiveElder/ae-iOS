//
//  BoardResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/11.
//

import Foundation

struct BoardResponse: Decodable {
    var postsList: [Post]?
}

struct Post: Decodable {
    var postIdx: Int
    var boardName: String
    var title: String
    var userIdx: Int
    var icon: Int
    var nickname: String
    var createdAt: String
    var hasImg: Int
    var likeCnt: Int
    var commentCnt: Int
    var isScraped: Int
}
