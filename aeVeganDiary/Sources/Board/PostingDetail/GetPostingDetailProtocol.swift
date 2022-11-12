//
//  GetPostingDetailProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/11.
//

import Foundation

protocol GetPostingDetailViewDelegate{
    func didSuccessGetPostingDetailData(_ result: PostingDetailResponse)
    func failedToRequest(message: String, code: Int)
}

protocol GetPostingDetailDataManagerDelegate{
    func getPostingDetailData (_ userIdx:CLong, postIdx:CLong, delegate:GetPostingDetailViewDelegate)
}
