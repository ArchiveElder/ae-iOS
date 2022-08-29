//
//  RestaurantSearchResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/12.
//

import Foundation

struct RestaurantSearchResponse : Decodable {
    var categories : [String]
    var size : Int
    var categoryList : [CategoryListDto]
}

struct CategoryListDto : Decodable {
    var bistroId : Int
    var isBookmark : Int
    var category : String?
    var name : String
    var roadAddr : String?
    var lnmAddr : String?
    var telNo : String?
}
