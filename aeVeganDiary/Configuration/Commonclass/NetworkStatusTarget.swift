//
//  NetworkStatusTarget.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/19.
//

import Foundation
import Moya

public enum NetworkStatusTarget {
    case getAnalysis
}

extension NetworkStatusTarget: TargetType {
    public var baseURL: URL {
        
        guard let url = URL(string: "http://15.165.139.29:8080") else {
            fatalError("fatal error - invalid url")
        }
        return url
    }

    public var path: String {
        switch self {
        case .getAnalysis:
            return "/api/v2/analysis"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getAnalysis:
            return .get
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
            switch self {
            case .getAnalysis:
                return .requestPlain
            }
        }

        public var headers: [String: String]? {
          return ["Authorization": "Bearer \(UserManager.shared.jwt)"]
        }

        public var validationType: ValidationType {
          return .successCodes
        }
    }
