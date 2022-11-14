//
//  DeleteThumbUpProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/14.
//

import Foundation

protocol DeleteThumbUpViewDelegate {
    func didSuccessDeleteThumbUp(_ result: ThumbUpDeleteResponse)
    func failedToRequest(message: String, code: Int)
}

protocol DeleteThumbUpDataManagerDelegate {
    func deleteThumbUp(_  userIdx:Int, parameters: ThumbUpRequest, delegate: DeleteThumbUpViewDelegate)
}
