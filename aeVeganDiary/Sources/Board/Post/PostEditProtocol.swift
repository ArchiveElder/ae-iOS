//
//  PostEditProtocol.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/21.
//

import Foundation
import UIKit

protocol PostEditViewDelegate {
    func didSuccessEdit()
    func failedToEdit(message: String, code: Int)
}

protocol PostEditDataManagerDelegate {
    func postEditing(_ parameters: PostRequest, multipartFileList: [UIImage]?, userIdx: Int, postIdx: Int, delegate: PostEditViewDelegate)
}
