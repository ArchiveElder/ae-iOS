//
//  CommonViewModel.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/19.
//

import Foundation
import RxSwift
import Moya

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}

enum DecodeError: Error {
    case decodeError
}

class CommonViewModel {
    let provider: MoyaProvider<NetworkStatusTarget>

    init() {
        provider = MoyaProvider<NetworkStatusTarget>()
    }
}

extension CommonViewModel {

    func process<T: Codable, E>(
        type: T.Type,
        result: Result<Response, MoyaError>,
        completion: @escaping (Result<E, Error>) -> Void
    ) {
        switch result {
        case .success(let response):
            /*if response.statusCode == 400 {
                let errorResponse = try! response.map(InputErrorResponse.self)
                completion (.failure(SessacErrorCase(messageId: errorResponse.message[0].messages[0].id)))
            } else if response.statusCode >= 401 {
                TokenUtils.delete(AppConfiguration.service, account: "accessToken")
                let errorResponse = try! response.map(AccessErrorResponse.self)
                completion (.failure(SessacErrorCase(messageId: errorResponse.error)))
            } else {
                let data = try! JSONDecoder().decode(type, from: response.data)
                completion(.success(data as! E))
            }*/
            if 200..<300 ~= response.statusCode {
                if let data = try? JSONDecoder().decode(type, from: response.data) {
                    completion(.success(data as! E))
                } else {
                    completion(.failure(DecodeError.decodeError))
                }
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

