//
//  PostingDetailResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/10.
//

import Foundation

struct PostingDeatilResponse : Decodable {
    var postIdx : CLong
    var title : String
    var content : String
    var icon : Int
    var nickname : String
    var createdAt : String
    var imagesCount : Int
    var imagesLists : [ImageLists]
    var thumbupCount : CLong
    var commentCount : Int
    var isLiked : Int
    var isScraped : Int
    var commentLists : [CommentLists]
}

struct ImageLists : Decodable {
    var imageUrl : String
    var imgRank : Int
}

struct CommentLists : Decodable {
    var commentIdx : CLong
    var icon : Int
    var nickname : String
    var date : String
    var content : String
}

