//
//  GetPostingDetailDataManager.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/11.
//

import Alamofire

class GetPostingDetailDataManager : GetPostingDetailDataManagerDelegate {
    func getPostingDetailData(_ userIdx:Int, postIdx:Int, delegate:GetPostingDetailViewDelegate){
        let headers: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        AF.request("\(Constant.BASE_URL)/community/posting/post/\(userIdx)/\(postIdx)", method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: PostingDetailResponse.self) {
                response in
                switch response.result{
                case .success(let response):
                        delegate.didSuccessGetPostingDetailData(response)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    
}
