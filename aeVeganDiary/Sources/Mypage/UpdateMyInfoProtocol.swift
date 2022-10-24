//
//  UpdateMyInfoProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/10/24.
//

import Foundation

protocol UpdateMyInfoViewDelegate{
    func didSuccessUpdateMyInfoData(_ result: UpdateMyInfoResponse)
    func failedToRequest(message: String, code: Int)
}

protocol UpdateMyInfoDataManagerDelegate{
    func putMyInfoData(_ parameters: MyInfoInput, delegate: UpdateMyInfoViewDelegate)
}
