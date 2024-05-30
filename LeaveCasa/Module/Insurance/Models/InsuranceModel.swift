//
//  InsuranceModel.swift
//  LeaveCasa
//
//  Created by acme on 07/05/24.
//

import UIKit
import ObjectMapper

struct InsuranceModel: Mappable {
    var responseStatus:Int?
    var error: Error?
    var traceId: String?
    var results: [InsuranceResults]?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        responseStatus <- map["ResponseStatus"]
        error <- map["Error"]
        traceId <- map["TraceId"]
        results <- map["Results"]
    }
}

struct InsuranceResults: Mappable {
    var planCode: String = ""
    var resultIndex: Int = 0
    var planType: Int = 0
    var planName: String = ""
    var planDescription: String = ""
    var planCoverage: Int = 0
    var coverageDetails: [CoverageDetail]?
    var planCategory: Int = 0
    var premiumList: [Premium]?
    var price: PriceModel?
    var policyStartDate: String = ""
    var policyEndDate: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        planCode <- map["PlanCode"]
        resultIndex <- map["ResultIndex"]
        planType <- map["PlanType"]
        planName <- map["PlanName"]
        planDescription <- map["PlanDescription"]
        planCoverage <- map["PlanCoverage"]
        coverageDetails <- map["CoverageDetails"]
        planCategory <- map["PlanCategory"]
        premiumList <- map["PremiumList"]
        price <- map["Price"]
        policyStartDate <- map["PolicyStartDate"]
        policyEndDate <- map["PolicyEndDate"]
    }
}

struct CoverageDetail: Mappable {
    var coverage: String = ""
    var sumInsured: String = ""
    var excess: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        coverage <- map["Coverage"]
        sumInsured <- map["SumInsured"]
        excess <- map["Excess"]
    }
}

struct Premium: Mappable {
    var passengerCount: Int = 0
    var minAge: Int = 0
    var maxAge: Int = 0
    var baseCurrencyPrice: PriceModel?
    var price: PriceModel?
    var baseCurrencyCancellationCharge: Int = 0
    var cancellationCharge: Int = 0
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        passengerCount <- map["PassengerCount"]
        minAge <- map["MinAge"]
        maxAge <- map["MaxAge"]
        baseCurrencyPrice <- map["BaseCurrencyPrice"]
        price <- map["Price"]
        baseCurrencyCancellationCharge <- map["BaseCurrencyCancellationCharge"]
        cancellationCharge <- map["CancellationCharge"]
    }
}

struct PriceModel: Mappable {
    var currency: String = ""
    var grossFare: Int = 0
    var publishedPrice: Int = 0
    var publishedPriceRoundedOff: Int = 0
    var offeredPrice: Int = 0
    var offeredPriceRoundedOff: Int = 0
    var commissionEarned: Int = 0
    var tdsOnCommission: Int = 0
    var serviceTax: Int = 0
    var swachhBharatTax: Int = 0
    var krishiKalyanTax: Int = 0
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        currency <- map["Currency"]
        grossFare <- map["GrossFare"]
        publishedPrice <- map["PublishedPrice"]
        publishedPriceRoundedOff <- map["PublishedPriceRoundedOff"]
        offeredPrice <- map["OfferedPrice"]
        offeredPriceRoundedOff <- map["OfferedPriceRoundedOff"]
        commissionEarned <- map["CommissionEarned"]
        tdsOnCommission <- map["TdsOnCommission"]
        serviceTax <- map["ServiceTax"]
        swachhBharatTax <- map["SwachhBharatTax"]
        krishiKalyanTax <- map["KrishiKalyanTax"]
    }
}
