//
//  CheckNicknameDataManagerProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/07.
//

import Foundation


protocol CheckNicknameViewDelegate {
    func didSuccessCheckNickname(_ result:CheckNicknameResponse)
    func failedToRequest(message: String, code: Int)
}

protocol CheckNicknameDataManagerDelegate {
    func postNickname(_ parameters: CheckNicknameInput, delegate: CheckNicknameViewDelegate)
}
