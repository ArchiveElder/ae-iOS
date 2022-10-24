//
//  DeleteMealProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/10/24.
//

import Foundation

protocol DeleteMealViewDelegate{
    func didSuccessDeleteMeal(_ result:DeleteMealResponse)
    func failedToRequest(message: String, code: Int)
}

protocol DeleteMealDataManagerDelegate{
    func deleteMealData(_ parameters: DeleteMealRequest, delegate: DeleteMealViewDelegate)
}
