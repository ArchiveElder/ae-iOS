//
//  GetMyInfoProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/10/24.
//

import Foundation

protocol GetMyInfoViewDelegate {
    func didSuccessGetMyInfoData(_ result:MyInfoResponse)
    func failedToRequest(message: String, code: Int)
}

protocol GetMyInfoDataManagerDelegate{
    func getMyInfoData(delegate:GetMyInfoViewDelegate)
}
