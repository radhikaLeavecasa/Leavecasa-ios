/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct TripFlightItinerary: Mappable {
    var commentDetails: String?
    var isAutoReissuanceAllowed: Bool?
    var issuancePcc: String?
    var journeyType: Int?
    var tripIndicator: Int?
    var bookingAllowedForRoamer: Bool?
    var bookingId: Int?
    var isCouponAppilcable: Bool?
    var isManual: Bool?
    var pNR: String?
    var agentReferenceNo: String?
    var isDomestic: Bool?
    var resultFareType: String?
    var source: Int?
    var origin: String?
    var destination: String?
    var airlineCode: String?
    var lastTicketDate: String?
    var validatingAirlineCode: String?
    var airlineRemark: String?
    var airlineTollFreeNo: String?
    var isLCC: Bool?
    var nonRefundable: Bool?
    var fareType: String?
    var creditNoteNo: String?
    var fare: TripFare?
    var creditNoteCreatedOn: String?
    var passenger = [TripPassenger]()
    var cancellationCharges: String?
    var segments = [TripSegments]()
    var fareRules = [TripFareRules]()
    var status: Int?
    var invoiceAmount: Int?
    var invoiceNo: String?
    var invoiceStatus: Int?
    var invoiceCreatedOn: String?
    var remarks: String?
    var isWebCheckInAllowed: Bool?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        commentDetails <- map["CommentDetails"]
        isAutoReissuanceAllowed <- map["IsAutoReissuanceAllowed"]
        issuancePcc <- map["IssuancePcc"]
        journeyType <- map["JourneyType"]
        tripIndicator <- map["TripIndicator"]
        bookingAllowedForRoamer <- map["BookingAllowedForRoamer"]
        bookingId <- map["BookingId"]
        isCouponAppilcable <- map["IsCouponAppilcable"]
        isManual <- map["IsManual"]
        pNR <- map["PNR"]
        agentReferenceNo <- map["AgentReferenceNo"]
        isDomestic <- map["IsDomestic"]
        resultFareType <- map["ResultFareType"]
        source <- map["Source"]
        origin <- map["Origin"]
        destination <- map["Destination"]
        airlineCode <- map["AirlineCode"]
        lastTicketDate <- map["LastTicketDate"]
        validatingAirlineCode <- map["ValidatingAirlineCode"]
        airlineRemark <- map["AirlineRemark"]
        airlineTollFreeNo <- map["AirlineTollFreeNo"]
        isLCC <- map["IsLCC"]
        nonRefundable <- map["NonRefundable"]
        fareType <- map["FareType"]
        creditNoteNo <- map["CreditNoteNo"]
        fare <- map["Fare"]
        creditNoteCreatedOn <- map["CreditNoteCreatedOn"]
        passenger <- map["Passenger"]
        cancellationCharges <- map["CancellationCharges"]
        segments <- map["Segments"]
        fareRules <- map["FareRules"]
        status <- map["Status"]
        invoiceAmount <- map["InvoiceAmount"]
        invoiceNo <- map["InvoiceNo"]
        invoiceStatus <- map["InvoiceStatus"]
        invoiceCreatedOn <- map["InvoiceCreatedOn"]
        remarks <- map["Remarks"]
        isWebCheckInAllowed <- map["IsWebCheckInAllowed"]
    }
}
//import Foundation
//import ObjectMapper
//
//struct TripFlightItinerary {
//	var commentDetails : String?
//	var isAutoReissuanceAllowed : Bool?
//	var issuancePcc : String?
//	var journeyType : Int?
//	var tripIndicator : Int?
//	var bookingAllowedForRoamer : Bool?
//	var bookingId : Int?
//	var isCouponAppilcable : Bool?
//	var isManual : Bool?
//	var pNR : String?
//	var agentReferenceNo : String?
//	var isDomestic : Bool?
//	var resultFareType : String?
//	var source : Int?
//	var origin : String?
//	var destination : String?
//	var airlineCode : String?
//	var lastTicketDate : String?
//	var validatingAirlineCode : String?
//	var airlineRemark : String?
//	var airlineTollFreeNo : String?
//	var isLCC : Bool?
//	var nonRefundable : Bool?
//	var fareType : String?
//	var creditNoteNo : String?
//	var fare : TripFare?
//	var creditNoteCreatedOn : String?
//	var passenger = [TripPassenger]()
//	var cancellationCharges : String?
//	var segments = [TripSegments]()
//	var fareRules : [TripFareRules]?
//	//var penaltyCharges : [String]?
//	var status : Int?
//	//var invoice : [TripInvoice]?
//	var invoiceAmount : Int?
//	var invoiceNo : String?
//	var invoiceStatus : Int?
//	var invoiceCreatedOn : String?
//	var remarks : String?
//	var isWebCheckInAllowed : Bool?
//
//	init?(map: [String:Any]) {
//
//        commentDetails = map["CommentDetails"] as? String ?? ""
//		isAutoReissuanceAllowed = map["IsAutoReissuanceAllowed"] as? Bool ?? false
//		issuancePcc = map["IssuancePcc"] as? String ?? ""
//		journeyType = map["JourneyType"] as? Int ?? 0
//		tripIndicator = map["TripIndicator"] as? Int ?? 0
//		bookingAllowedForRoamer = map["BookingAllowedForRoamer"] as? Bool ?? false
//		bookingId = map["BookingId"] as? Int ?? 0
//		isCouponAppilcable = map["IsCouponAppilcable"] as? Bool ?? false
//		isManual = map["IsManual"] as? Bool ?? false
//		pNR = map["PNR"] as? String ?? ""
//		agentReferenceNo = map["AgentReferenceNo"] as? String ?? ""
//		isDomestic = map["IsDomestic"] as? Bool ?? false
//		resultFareType = map["ResultFareType"] as? String ?? ""
//		source = map["Source"] as? Int ?? 0
//		origin = map["Origin"] as? String ?? ""
//		destination = map["Destination"] as? String ?? ""
//		airlineCode = map["AirlineCode"] as? String ?? ""
//		lastTicketDate = map["LastTicketDate"] as? String ?? ""
//		validatingAirlineCode = map["ValidatingAirlineCode"] as? String ?? ""
//		airlineRemark = map["AirlineRemark"] as? String ?? ""
//		airlineTollFreeNo = map["AirlineTollFreeNo"] as? String ?? ""
//		isLCC = map["IsLCC"] as? Bool ?? false
//		nonRefundable = map["NonRefundable"] as? Bool ?? false
//		fareType = map["FareType"] as? String ?? ""
//		creditNoteNo = map["CreditNoteNo"] as? String ?? ""
//        fare = TripFare.init(map: map["Fare"] as? [String:Any] ?? [:])
//		creditNoteCreatedOn = map["CreditNoteCreatedOn"] as? String ?? ""
//
//        if let SearchResults = map["Passenger"] as? [[String:Any]] {
//            for index in SearchResults {
//                guard let model = TripPassenger.init(map: index) else { return nil }
//                self.passenger.append(model)
//            }
//        }
//
//		cancellationCharges = map["CancellationCharges"] as? String ?? ""
//        if let SearchResults = map["Segments"] as? [[String:Any]] {
//            for index in SearchResults {
//                let model = TripSegments.init(map: index)
//                self.segments.append(model)
//            }
//        }
//
//        if let SearchResults = map["FareRules"] as? [[String:Any]] {
//            for index in SearchResults {
//                let model = TripFareRules.init(map: index)
//                self.fareRules?.append(model)
//            }
//        }
//
//		//penaltyCharges = map["PenaltyCharges"]
//		status = map["Status"] as? Int ?? 0
//        //invoice = map[CommonParam.INVOICE.lowercased()]
//		invoiceAmount = map["InvoiceAmount"] as? Int ?? 0
//		invoiceNo = map["InvoiceNo"] as? String ?? ""
//		invoiceStatus = map["InvoiceStatus"] as? Int ?? 0
//		invoiceCreatedOn = map["InvoiceCreatedOn"] as? String ?? ""
//		remarks = map["Remarks"] as? String ?? ""
//		isWebCheckInAllowed = map["IsWebCheckInAllowed"] as? Bool ?? false
//	}
//
//}
