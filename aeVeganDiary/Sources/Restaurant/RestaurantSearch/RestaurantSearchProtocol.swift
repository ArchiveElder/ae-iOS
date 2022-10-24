//
//  RestaurantSearchProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/10/24.
//

import Foundation

protocol RestaurantSearchViewDelegate {
    func didSuccessGetRestaurantSearch(_ result:RestaurantSearchResponse)
    func failedToRequest(message: String, code: Int)
}

protocol RestaurantSearchDataManagerDelegate{
    func postRestaurantSearch(_ parameters: RestaurantSearchInput, delegate:RestaurantSearchViewDelegate)
}
