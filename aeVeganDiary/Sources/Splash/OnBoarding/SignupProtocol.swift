//
//  SignupProtocol.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/23.
//

protocol SignupViewDelegate {
    func didSuccessSignup(_ result: SignupResponse)
    func failedToRequest(message: String, code: Int)
}

protocol SignupDataManagerDelegate {
    func postSignup(_ parameters: SignupRequest, delegate: SignupViewDelegate)
}
