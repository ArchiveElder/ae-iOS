//
//  EditPostResponse.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/21.
//

import Foundation

struct EditPostResponse: Decodable {
    var postIdx: Int?
    var title: String?
    var content: String?
    var boardName: String?
    var userIdx: Int?
    var imagesLists: [EditPostImage]?
}

struct EditPostImage: Decodable {
    var imageUrl: String?
    var imgRank: Int?
}
