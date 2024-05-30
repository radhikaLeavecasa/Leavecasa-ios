/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct ResultsSSR : Mappable {
	var isHoldAllowedWithSSR : Bool?
	var resultIndex : String?
	var source : Int?
	var isLCC : Bool?
	var isRefundable : Bool?
	var isPanRequiredAtBook : Bool?
	var isPanRequiredAtTicket : Bool?
	var isPassportRequiredAtBook : Bool?
	var isPassportRequiredAtTicket : Bool?
	var gSTAllowed : Bool?
	var isCouponAppilcable : Bool?
	var isGSTMandatory : Bool?
	var airlineRemark : String?
	var resultFareType : String?
	var fare : Fare?
	var fareBreakdown : [FareBreakdown]?
	var segments : [[Segments]]?
	var lastTicketDate : String?
	var ticketAdvisory : String?
	var fareRules : [FareRules]?
	var airlineCode : String?
	var validatingAirline : String?
	var fareClassification : FareClassification?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		isHoldAllowedWithSSR <- map["IsHoldAllowedWithSSR"]
		resultIndex <- map["ResultIndex"]
		source <- map["Source"]
		isLCC <- map["IsLCC"]
		isRefundable <- map["IsRefundable"]
		isPanRequiredAtBook <- map["IsPanRequiredAtBook"]
		isPanRequiredAtTicket <- map["IsPanRequiredAtTicket"]
		isPassportRequiredAtBook <- map["IsPassportRequiredAtBook"]
		isPassportRequiredAtTicket <- map["IsPassportRequiredAtTicket"]
		gSTAllowed <- map["GSTAllowed"]
		isCouponAppilcable <- map["IsCouponAppilcable"]
		isGSTMandatory <- map["IsGSTMandatory"]
		airlineRemark <- map["AirlineRemark"]
		resultFareType <- map["ResultFareType"]
		fare <- map["Fare"]
		fareBreakdown <- map["FareBreakdown"]
		segments <- map["Segments"]
		lastTicketDate <- map["LastTicketDate"]
		ticketAdvisory <- map["TicketAdvisory"]
		fareRules <- map["FareRules"]
		airlineCode <- map["AirlineCode"]
		validatingAirline <- map["ValidatingAirline"]
		fareClassification <- map["FareClassification"]
	}

}
