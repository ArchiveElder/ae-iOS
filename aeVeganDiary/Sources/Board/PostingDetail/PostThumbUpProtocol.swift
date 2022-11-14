//
//  PostThumbUpProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/14.
//

import Foundation

protocol PostThumbUpViewDelegate{
    func didSuccessPostThumbUp(_ result: ThumbUpResponse)
    func failedToRequest(message: String, code: Int)
}

protocol PostThumbUpDataManagerDelegate {
    func postThumbUp(_  userIdx:Int, parameters: ThumbUpRequest, delegate: PostThumbUpViewDelegate)
}
