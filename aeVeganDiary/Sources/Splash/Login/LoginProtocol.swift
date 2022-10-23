//
//  LoginProtocol.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/20.
//

protocol LoginViewDelegate {
    func didSuccessLogin(_ result: LoginResponse)
    func failedToRequest(message: String)
}

protocol LoginDataManagerDelegate {
    func postLogin(_ parameters: LoginRequest, delegate: LoginViewDelegate)
}
