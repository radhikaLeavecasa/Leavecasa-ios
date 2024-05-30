//
//  InsuranceGetDetailModel.swift
//  LeaveCasa
//
//  Created by acme on 20/05/24.
//

import UIKit
import ObjectMapper

struct InsuranceGetDetailModel: Mappable {
    var responseStatus:Int?
    var error: Error?
    var traceId: String?
    var status: String?
    var itinerary: ItineraryModel?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        responseStatus <- map["ResponseStatus"]
        error <- map["Error"]
        status <- map["status"]
        traceId <- map["TraceId"]
        itinerary <- map["Itinerary"]
    }
}

struct ItineraryModel: Mappable {
    var bookingId: Int?
    var insuranceId: Int?
    var planType: Int?
    var planName: String?
    var planDescription: String?
    var planCoverage: Int?
    var coverageDetails: [CoverageDetail]?
    var planCategory: Int?
    var paxInfo: [PaxInfoModel]?
    var policyEndDate: String?
    var policyStartDate: String?
    
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        bookingId <- map["BookingId"]
        insuranceId <- map["InsuranceId"]
        planType <- map["PlanType"]
        planName <- map["PlanName"]
        planDescription <- map["PlanDescription"]
        planCoverage <- map["PlanCoverage"]
        coverageDetails <- map["CoverageDetails"]
        planCategory <- map["PlanCategory"]
        paxInfo <- map["PaxInfo"]
        policyEndDate <- map["PolicyEndDate"]
        policyStartDate <- map["PolicyStartDate"]
    }
}

struct PaxInfoModel: Mappable {
    var addressLine1: String?
        var addressLine2: String?
        var beneficiaryName: String?
        var city: String?
        var claimCode: Any?
        var country: String?
        var dob: String?
        var documentURL: String?
        var emailId: String?
        var errorMsg: String?
        var firstName: String?
        var gender: String?
        var lastName: String?
        var majorDestination: String?
        var maxAge: Int?
        var minAge: Int?
        var oldPolicyNumber: String?
        var passportNo: String?
        var paxId: Int?
        var phoneNumber: Int?
        var pinCode: Int?
        var policyNo: String?
        var policyStatus: Int?
        var price: Price?
        var referenceId: String?
        var relationshipToInsured: String?
        var relationToBeneficiary: String?
        var siebelPolicyNumber: String?
        var state: String?
        var title: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        addressLine1 <- map["AddressLine1"]
        addressLine2 <- map["AddressLine2"]
        beneficiaryName <- map["BeneficiaryName"]
        city <- map["City"]
        claimCode <- map["ClaimCode"]
        country <- map["Country"]
        dob <- map["DOB"]
        documentURL <- map["DocumentURL"]
        emailId <- map["EmailId"]
        errorMsg <- map["ErrorMsg"]
        firstName <- map["FirstName"]
        gender <- map["Gender"]
        lastName <- map["LastName"]
        majorDestination <- map["MajorDestination"]
        maxAge <- map["MaxAge"]
        minAge <- map["MinAge"]
        oldPolicyNumber <- map["OldPolicyNumber"]
        passportNo <- map["PassportNo"]
        paxId <- map["PaxId"]
        phoneNumber <- map["PhoneNumber"]
        pinCode <- map["PinCode"]
        policyNo <- map["PolicyNo"]
        policyStatus <- map["PolicyStatus"]
        price <- map["Price"]
        referenceId <- map["ReferenceId"]
        relationshipToInsured <- map["RelationShipToInsured"]
        relationToBeneficiary <- map["RelationToBeneficiary"]
        siebelPolicyNumber <- map["SiebelPolicyNumber"]
        state <- map["State"]
        title <- map["Title"]
    }
}

struct Price: Mappable {
    var commissionEarned: Int?
    var currency: String?
    var grossFare: Int?
    var krishiKalyanTax: Int?
    var offeredPrice: Int?
    var offeredPriceRoundedOff: Int?
    var publishedPrice: Int?
    var publishedPriceRoundedOff: Int?
    var serviceTax: Int?
    var swachhBharatTax: Int?
    var tdsOnCommission: Int?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        commissionEarned <- map["CommissionEarned"]
        currency <- map["Currency"]
        grossFare <- map["GrossFare"]
        krishiKalyanTax <- map["KrishiKalyanTax"]
        offeredPrice <- map["OfferedPrice"]
        offeredPriceRoundedOff <- map["OfferedPriceRoundedOff"]
        publishedPrice <- map["PublishedPrice"]
        publishedPriceRoundedOff <- map["PublishedPriceRoundedOff"]
        serviceTax <- map["ServiceTax"]
        swachhBharatTax <- map["SwachhBharatTax"]
        tdsOnCommission <- map["TdsOnCommission"]
    }
}
