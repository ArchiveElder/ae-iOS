//
//  RegisterProtocol.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/23.
//

import UIKit

protocol RegisterViewDelegate {
    func didSuccessRegister(_ result: RegisterResponse)
    func failedToRequest(message: String, code: Int)
}

protocol RegisterDataManagerDelegate {
    func postRegister(_ parameters: RegisterRequest, foodImage: UIImage, delegate: RegisterViewDelegate)
}
