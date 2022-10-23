//
//  BookmarkProtocol.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/23.
//

protocol BookmarkViewDelegate {
    func didSuccessPostBookmark(_ result: BookmarkResponse)
    func failedToRequest(message: String, code: Int)
}

protocol BookmarkDataManagerDelegate {
    func postBookmark(_ parameters: BookmarkRequest, delegate: BookmarkViewDelegate)
}
