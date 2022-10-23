//
//  BookmarkListProtocol.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/23.
//

protocol BookmarkListViewDelegate {
    func didSuccessGetBookmarkList(_ result: BookmarkListResponse)
    func failedToRequest(message: String, code: Int)
}

protocol BookmarkListDataManagerDelegate {
    func getBookmarkList(delegate: BookmarkListViewDelegate)
}
