///
//  HotelCitylist.swift
//  LeaveCasa
//
//  Created by acme on 30/04/24.
//

import UIKit
import ObjectMapper

struct HotelCityModel: Mappable {
    var id: Int?
    var code: Int?
    var city: String?
    var countryCode: String?
    var country: String?
    var state: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        code <- map["code"]
        city <- map["City"]
        countryCode <- map["CountryCode"]
        country <- map["Country"]
        state <- map["State"]
    }
}
