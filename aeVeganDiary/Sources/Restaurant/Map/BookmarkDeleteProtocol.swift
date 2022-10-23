//
//  BookmarkDeleteProtocol.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/23.
//

protocol BookmarkDeleteViewDelegate {
    func didSuccessDeleteBookmark(_ result: BookmarkResponse)
    func failedToRequest(message: String, code: Int)
}

protocol BookmarkDeleteDataManagerDelegate {
    func deleteBookmark(_ parameters: BookmarkRequest, delegate: BookmarkDeleteViewDelegate)
}
