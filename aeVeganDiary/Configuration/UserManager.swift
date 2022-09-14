//
//  UserManager.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/09/08.
//

import Foundation
import KeychainSwift
import Alamofire

class UserManager {
    static let shared = UserManager()
    
    /*var jwt: String {
        get {
            return KeychainSwift().get("jwt") ?? ""
        }
        set {
            KeychainSwift().set(newValue, forKey: "jwt")
        }
    }*/
    
    var jwt: String {
        get {
            return UserDefaults.standard.string(forKey: "jwt") ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "jwt")
        }
    }
}
