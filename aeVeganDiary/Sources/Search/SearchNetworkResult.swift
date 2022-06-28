//
//  SearchNetworkResult.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/26.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
