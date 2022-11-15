//
//  CommentRequest.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/15.
//

import Foundation

struct CommentRequest: Encodable {
    var postIdx: Int
    var content: String
}
