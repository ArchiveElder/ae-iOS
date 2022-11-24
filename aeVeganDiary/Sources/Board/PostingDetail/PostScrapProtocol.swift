//
//  PostScrapProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/14.
//

import Foundation

protocol PostScrapViewDelegate{
    func didSuccessPostScrap(_ result: ScrapResponse)
    func failedToRequest(message: String, code: Int)
}

protocol PostScrapDataManagerDelegate {
    func postScrap(_  userIdx:Int, parameters: ScrapRequest, delegate: PostScrapViewDelegate)
}
