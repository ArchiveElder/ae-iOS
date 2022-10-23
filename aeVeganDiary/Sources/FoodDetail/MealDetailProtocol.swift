//
//  MealDetailProtocol.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/23.
//

protocol MealDetailViewDelegate {
    func didSuccessGetMealDetail(_ result: MealDetailResponse)
    func failedToRequest(message: String, code: Int)
}

protocol MealDetailDataManagerDelegate {
    func getMealDetail(_ parameters: MealDetailRequest, delegate: MealDetailViewDelegate)
}
