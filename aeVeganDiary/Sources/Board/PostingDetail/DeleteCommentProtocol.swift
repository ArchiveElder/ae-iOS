//
//  DeleteCommentProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/15.
//

import Foundation

protocol DeleteCommentViewDelegate {
    func didSuccessDeleteComment(_ result: DeleteCommentResponse)
    func failedToRequest(message: String, code: Int)
}

protocol DeleteCommentDataManagerDelegate {
    func deleteComment(_  userIdx:Int, parameters: DeleteCommentRequest, delegate: DeleteCommentViewDelegate)
}
