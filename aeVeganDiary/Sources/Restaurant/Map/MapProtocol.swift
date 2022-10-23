//
//  MapProtocol.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/23.
//

protocol MapViewDelegate {
    func didSuccessGetMap(_ result: MapResponse)
    func failedToRequest(message: String, code: Int)
}

protocol MapDataManagerDelegate {
    func getMap(delegate: MapViewDelegate)
}
