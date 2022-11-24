//
//  DeleteScrapProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/14.
//

import Foundation

protocol DeleteScrapViewDelegate {
    func didSuccessDeleteScrap(_ result: ScrapDeleteResponse)
    func failedToRequest(message: String, code: Int)
}

protocol DeleteScrapDataManagerDelegate {
    func deleteScrap(_  userIdx:Int, parameters: ScrapRequest, delegate: DeleteScrapViewDelegate)
}
