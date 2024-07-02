//
//  VisaApplicationModel.swift
//  LeaveCasa
//
//  Created by acme on 01/07/24.
//

import UIKit
import ObjectMapper

struct VisaApplicationModel: Mappable {
    var amountInfo: AmountInfo?
    var country: String?
    var createdAt: String?
    var data: String?
    var details: String?
    var email: String?
    var id: Int?
    var pax: Int?
    var phone: String?
    var processingTime: String?
    var stats: [Stat]?
    var status: [String]?
    var stayPeriod: String?
    var traceId: Int?
    var updatedAt: String?
    var userId: Int?
    var username: String?
    var validity: String?
    var visaId: Int?
    var visaType: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        amountInfo <- map["amount_info"]
        country <- map["country"]
        createdAt <- map["created_at"]
        data <- map["data"]
        details <- map["details"]
        email <- map["email"]
        id <- map["id"]
        pax <- map["pax"]
        phone <- map["phone"]
        processingTime <- map["processing_time"]
        stats <- map["stats"]
        status <- map["status"]
        stayPeriod <- map["stay_period"]
        traceId <- map["trace_id"]
        updatedAt <- map["updated_at"]
        userId <- map["user_id"]
        username <- map["username"]
        validity <- map["validity"]
        visaId <- map["visa_id"]
        visaType <- map["visa_type"]
    }
}

struct AmountInfo: Mappable {
    var amount: Int?
    var currency: String?
    var leavecasaPrice: Int?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        amount <- map["amount"]
        currency <- map["currency"]
        leavecasaPrice <- map["leavecasa_price"]
    }
}

struct Stat: Mappable {
    var pax: Int?
    var photograph: String?
    var status: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        pax <- map["pax"]
        photograph <- map["photograph"]
        status <- map["status"]
    }
}
