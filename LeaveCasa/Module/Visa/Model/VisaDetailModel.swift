//
//  VisaDetailModel.swift
//  LeaveCasa
//
//  Created by acme on 25/06/24.
//

import UIKit
import ObjectMapper

struct VisaDetailModel: Mappable {
    var id: Int?
    var country: String?
    var images: String?
    var visaType: String?
    var validity: [String]?
    var stayPeriod: [String]?
    var documents: [Document]?
    var processingTime: String?
    var landingFees: String?
    var guidelines: [String]?
    var currency: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        country <- map["country"]
        images <- map["images"]
        visaType <- map["visa_type"]
        validity <- map["validity"]
        stayPeriod <- map["stay_period"]
        documents <- map["documents"]
        processingTime <- map["processing_time"]
        landingFees <- map["landing_fees"]
        guidelines <- map["guidelines"]
        currency <- map["currency"]
    }
}

struct Document: Mappable {
    var name: String?
    var desc: String?
    var type: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        desc <- map["desc"]
        type <- map["type"]
    }
}
