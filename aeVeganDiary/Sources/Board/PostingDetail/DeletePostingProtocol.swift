//
//  DeletePostingProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/14.
//

import Foundation

protocol DeletePostingViewDelegate {
    func didSuccessDeletePosting()
    func failedToRequest(message: String, code: Int)
}

protocol DeletePostingDataManagerDelegate{
    func deletePosting(_  userIdx:Int, postIdx:Int,parameters: DeletePostingRequest, delegate: DeletePostingViewDelegate)
}
