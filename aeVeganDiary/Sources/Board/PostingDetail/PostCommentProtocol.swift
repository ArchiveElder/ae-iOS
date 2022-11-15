//
//  PostCommentProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/15.
//

import Foundation

protocol PostCommentViewDelegate{
    func didSuccessPostComment(_ result: CommentResponse)
    func failedToRequest(message: String, code: Int)
}

protocol PostCommentDataManagerDelegate {
    func postComment(_  userIdx:Int, parameters: CommentRequest, delegate: PostCommentViewDelegate)
}
