//
//  PostingResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/18.
//

import Foundation

struct MyPostingResponse : Decodable {
    var postsLists : [MyPostingLists]?
}

struct MyPostingLists: Decodable {
    var commentCount : Int?
    var content : String?
    var createdAt : String?
    var icon : Int?
    var nickname : String?
    var postIdx : Int?
    var thumbupCount : Int?
    var title : String?
    var userIdx : Int?
    var boardName : String?
    var hasImg : Int?
}
