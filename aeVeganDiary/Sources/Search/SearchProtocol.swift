//
//  SearchProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/10/23.
//

import Foundation

protocol SearchViewDelegate{
    func didSuccessGetSearchData(_ result:SearchResponse)
    func failedToRequest(message: String, code: Int)
}

protocol SearchDataManagerDelegate{
    func getSearchData(delegate:SearchViewDelegate)
}
