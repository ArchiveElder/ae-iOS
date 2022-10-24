//
//  RegionProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/10/23.
//

import Foundation

protocol RegionViewDelegate{
    func didSuccessGetMiddleRegion(_ result:RegionResponse)
    func failedToRequest(message: String, code: Int)
}

protocol RegionDataManagerDelegate{
    func postRegionCategory(_ parameters: RegionInput, delegate:RegionViewDelegate)
}
