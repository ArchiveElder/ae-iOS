//
//  CookRecommResponse.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/29.
//

import Foundation

struct CookRecommResponse: Decodable {
    var foods : [String]
    var foodDto : [CookRecomm]
}

struct CookRecomm : Decodable {
    var food : String
    var no : [String]
    var has : [String]
    var recipeUrl : String
}
