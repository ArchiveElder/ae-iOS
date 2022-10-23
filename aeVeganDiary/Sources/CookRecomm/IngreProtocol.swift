//
//  IngreProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/10/23.
//

import Foundation

protocol IngreViewDelegate {
    func didRetrieveIngreData(_ result: IngreResponse)
    func failedToRequest(message: String, code: Int)
}

protocol IngreDataManagerDelegate{
    func getIngreData(delegate:IngreViewDelegate)
}
