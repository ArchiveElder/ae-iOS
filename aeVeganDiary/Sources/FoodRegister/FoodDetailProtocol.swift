//
//  FoodDetailProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/10/23.
//

import Foundation

protocol FoodDetailViewDelegate {
    func didSuccessGetFoodDetailData(_ result: FoodDetailResponse)
    func failedToRequest(message: String, code: Int)
}

protocol FoodDetailDataManagerDelegate{
    func requestData(_ parameters: SearchInput, delegate: FoodDetailViewDelegate)
}
