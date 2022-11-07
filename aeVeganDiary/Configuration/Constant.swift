//
//  Constant.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/28.
//

import Alamofire

struct Constant {
    static let BASE_URL = "http://15.165.139.29:8080"
    //static let BASE_URL = "http://43.200.212.116:8080"
    
    //static var HEADERS: HTTPHeaders = ["Authorization": "Bearer \(UserManager.shared.jwt )"]
    
    struct System {
        static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
        static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        static func latestVersion() -> String? {
            let appleID = "1643485964"
            guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appleID)"),
                  let data = try? Data(contentsOf: url),
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results[0]["version"] as? String else {
                return nil
            }
            return appStoreVersion
        }
    }
}
