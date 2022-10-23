//
//  HomeProtocol.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/22.
//

protocol HomeViewDelegate {
    func didSuccessGetDaterecord(_ result: HomeResponse)
    func failedToRequest(message: String, code: Int)
}

protocol HomeDataManagerDelegate {
    func getDaterecord(_ parameters: HomeRequest, delegate: HomeViewDelegate)
}
