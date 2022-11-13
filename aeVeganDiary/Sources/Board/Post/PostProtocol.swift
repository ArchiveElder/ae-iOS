//
//  PostProtocol.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/13.
//

import Foundation
import UIKit

protocol PostViewDelegate {
    func didSuccessPost()
    func failedToPost(message: String, code: Int)
}

protocol PostDataManagerDelegate {
    func postPosting(_ parameters: PostRequest, multipartFileList: [UIImage]?, userIdx: Int, delegate: PostViewDelegate)
}
