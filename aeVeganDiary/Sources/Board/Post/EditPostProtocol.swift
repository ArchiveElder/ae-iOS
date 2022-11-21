//
//  EditPostProtocol.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/21.
//

import Foundation

protocol EditPostViewDelegate {
    func didSuccessGetEdit(response: EditPostResponse)
    func failedToGetEdit(message: String, code: Int)
}

protocol EditPostDataManagerDelegate {
    func getEditing(userIdx: Int, postIdx: Int, delegate: EditPostViewDelegate)
}
