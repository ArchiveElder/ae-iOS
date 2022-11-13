//
//  PostRequest.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/13.
//

import Foundation

struct PostRequest: Encodable {
    var title: String
    var content: String
    var groupName: String
}
