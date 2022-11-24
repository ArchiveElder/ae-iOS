//
//  PostingDetailResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/10.
//

import Foundation

struct PostingDetailResponse : Decodable {
    var postIdx : Int?
    var title : String?
    var content : String?
    var icon : Int?
    var userIdx : Int?
    var nickname : String?
    var createdAt : String?
    var imagesCount : Int?
    var imagesLists : [ImageLists]?
    var thumbupCount : Int?
    var commentCount : Int?
    var liked : Bool?
    var scraped : Bool?
    var boardName : String?
    var commentsLists : [CommentsLists]?
}

struct ImageLists : Decodable {
    var imageUrl : String?
    var imgRank : Int?
}

struct CommentsLists : Decodable {
    var commentIdx : Int?
    var icon : Int?
    var userIdx : Int?
    var nickname : String?
    var date : String?
    var content : String?
}

