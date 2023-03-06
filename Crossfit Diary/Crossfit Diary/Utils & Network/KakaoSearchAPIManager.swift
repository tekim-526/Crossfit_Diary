//
//  NaverSearchAPIManager.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/20.
//

import Foundation

import Alamofire
import SwiftyJSON
import CoreLocation

struct Place: Decodable {
    let placeName: String
    let roadAdressName: String
    let longitudeX: String
    let latitudeY: String
    let phone: String?
}
    
struct KakaoSearchAPIManager {
    
    static func kakaoSearchPlace(searchName: String, x: CLLocationDegrees, y: CLLocationDegrees, completionHandler: @escaping ([Place]) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakaoAK)"]
        let parameters: [String: Any] = ["query": searchName, "page": 1, "size": 15]

        AF.request("https://dapi.kakao.com/v2/local/search/keyword.json?y=\(y)&x=\(x)&radius=3000", method: .get, parameters: parameters, headers: headers).responseData { response in
            var placeList = [Place]()
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let data = json["documents"]
                for i in 0...data.count - 1 {
                    let placeName = data[i]["place_name"].stringValue
                    let longitudeX = data[i]["x"].stringValue
                    let latitiudeY = data[i]["y"].stringValue
                    let roadAdressName = data[i]["road_address_name"].stringValue
                    let phone = data[i]["phone"].string
                    placeList.append(Place(placeName: placeName, roadAdressName: roadAdressName, longitudeX: longitudeX, latitudeY: latitiudeY, phone: phone))
                }
                completionHandler(placeList)
            case .failure(let error):
                print(error)
            }
        }
    }
}

