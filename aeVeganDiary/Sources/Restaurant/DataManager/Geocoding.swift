//
//  Geocoding.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/07/28.
//

import Alamofire
import SwiftyJSON

struct geoJSON: Decodable {
    var status: String
    var meta: Meta?
    var addresses: [Addresses]?
    var errorMessage: String?
}

struct Meta: Decodable {
    var totalCount: Int?
    var page: Int?
    var count: Int?
}

struct Addresses: Decodable {
    var roadAddress: String?
    var jibunAddress: String?
    var englishAddress: String?
    var addressElements: [AddressElements]?
    var x: String?
    var y: String?
    var distance: Double?
}

struct AddressElements: Decodable {
    var types: [String]?
    var longName: String?
    var shortName: String?
    var code: String?
}



class Geocoding {
    func getCoordinates(_ parameters: String, viewController: MapViewController) {
        let NAVER_CLIENT_ID = "i5sifrmz5f"
        let NAVER_CLIENT_SECRET = "EBFG21VqhdEF4Td3qghOWLnixUWPTgZumSF51THz"
        let NAVER_GEOCODE_URL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query="
        
        let encodeAddress = parameters.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let header1 = HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value: NAVER_CLIENT_ID)
        let header2 = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: NAVER_CLIENT_SECRET)
        let headers = HTTPHeaders([header1,header2])
        
        AF.request(NAVER_GEOCODE_URL + encodeAddress, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: geoJSON.self) { response in
                switch response.result {
                case .success(let response):
                    viewController.getCoor(latitude: response.addresses?.first?.x ?? "", longtitude: response.addresses?.first?.y ?? "")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
