//
//  AnalyzeProtocol.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/23.
//


protocol AnalyzeViewDelegate {
    func didSuccessGetAnalyze(_ result: AnalyzeResponse)
    func failedToRequest(message: String, code: Int)
}

protocol AnalyzeDataManagerDelegate {
    func getAnalyze(delegate: AnalyzeViewDelegate)
}
