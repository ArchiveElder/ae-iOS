//
//  PostingResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/18.
//

import Foundation

struct PostingResponse : Decodable {
    var postsLists : [PostingLists]?
}

struct PostingLists: Decodable {
    var commentCount : Int?
    var content : String?
    var createdAt : String?
    var icon : Int?
    var nickname : String?
    var postIdx : Int?
    var thumbupCount : Int?
    var title : String?
    var userIdx : Int?
}
