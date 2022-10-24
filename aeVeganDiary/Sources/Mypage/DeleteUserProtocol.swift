//
//  DeleteUserProtocol.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/10/24.
//

import Foundation

protocol DeleteUserViewDelegate{
    func didSuccessDeleteUser(_ result:DeleteUserResponse)
    func failedToRequest(message: String, code: Int)
}

protocol DeleteUserDataManagerDelegate{
    func deleteUserData(_ parameters: DeleteUserRequest, delegate: DeleteUserViewDelegate)
}
