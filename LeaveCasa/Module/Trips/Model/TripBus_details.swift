/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct TripBus_details : Mappable {
	var bookingFee : String?
	var busType : String?
	var cancellationCalculationTimestamp : String?
	var cancellationMessage : String?
	var cancellationPolicy : String?
	var dateOfIssue : String?
	var destinationCity : String?
	var destinationCityId : String?
	var doj : String?
	var dropLocation : String?
	var dropLocationId : String?
	var dropTime : String?
	var firstBoardingPointTime : String?
	var hasRTCBreakup : String?
	var hasSpecialTemplate : String?
	var inventoryId : String?
	var inventoryItems : TripInventoryItems?
    var arrInventoryItems : [TripInventoryItems]?
	var mTicketEnabled : String?
	var partialCancellationAllowed : String?
	var pickUpContactNo : String?
	var pickUpLocationAddress : String?
	var pickupLatitude : String?
	var pickupLocation : String?
	var pickupLocationId : String?
	var pickupLocationLandmark : String?
	var pickupTime : String?
	var pnr : String?
	var primeDepartureTime : String?
	var primoBooking : String?
	var reschedulingPolicy : TripReschedulingPolicy?
	var serviceCharge : String?
	var sourceCity : String?
	var sourceCityId : String?
	var status : String?
	var tin : String?
	var travels : String?
	var vaccinatedBus : String?
	var vaccinatedStaff : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		bookingFee <- map["bookingFee"]
		busType <- map["busType"]
		cancellationCalculationTimestamp <- map["cancellationCalculationTimestamp"]
		cancellationMessage <- map["cancellationMessage"]
		cancellationPolicy <- map["cancellationPolicy"]
		dateOfIssue <- map["dateOfIssue"]
		destinationCity <- map["destinationCity"]
		destinationCityId <- map["destinationCityId"]
		doj <- map["doj"]
		dropLocation <- map["dropLocation"]
		dropLocationId <- map["dropLocationId"]
		dropTime <- map["dropTime"]
		firstBoardingPointTime <- map["firstBoardingPointTime"]
		hasRTCBreakup <- map["hasRTCBreakup"]
		hasSpecialTemplate <- map["hasSpecialTemplate"]
		inventoryId <- map["inventoryId"]
		inventoryItems <- map["inventoryItems"]
        arrInventoryItems <- map["inventoryItems"]
		mTicketEnabled <- map["MTicketEnabled"]
		partialCancellationAllowed <- map["partialCancellationAllowed"]
		pickUpContactNo <- map["pickUpContactNo"]
		pickUpLocationAddress <- map["pickUpLocationAddress"]
		pickupLatitude <- map["pickupLatitude"]
		pickupLocation <- map["pickupLocation"]
		pickupLocationId <- map["pickupLocationId"]
		pickupLocationLandmark <- map["pickupLocationLandmark"]
		pickupTime <- map["pickupTime"]
		pnr <- map["pnr"]
		primeDepartureTime <- map["primeDepartureTime"]
		primoBooking <- map["primoBooking"]
		reschedulingPolicy <- map["reschedulingPolicy"]
		serviceCharge <- map["serviceCharge"]
		sourceCity <- map["sourceCity"]
		sourceCityId <- map["sourceCityId"]
		status <- map["status"]
		tin <- map["tin"]
		travels <- map["travels"]
		vaccinatedBus <- map["vaccinatedBus"]
		vaccinatedStaff <- map["vaccinatedStaff"]
	}

}
