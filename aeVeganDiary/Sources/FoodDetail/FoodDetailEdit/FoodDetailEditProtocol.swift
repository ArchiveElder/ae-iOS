//
//  FoodDetailEditProtocol.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/24.
//

import UIKit

protocol FoodDetailEditViewDelegate {
    func didSuccessFoodDetailEdit(_ result: RegisterResponse)
    func failedToRequest(message: String, code: Int)
}

protocol FoodDetailEditDataManagerDelegate {
    func postFoodDetailEdit(_ parameters: FoodDetailEditRequest, foodImage: UIImage?, delegate: FoodDetailEditViewDelegate)
}
