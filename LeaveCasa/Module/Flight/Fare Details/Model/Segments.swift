/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct Segments : Mappable {
	var baggage : String?
	var cabinBaggage : String?
	var cabinClass : Int?
	var tripIndicator : Int?
	var segmentIndicator : Int?
	var airline : Airline?
	var origin : Origin?
	var destination : Destination?
	var duration : Int?
	var groundTime : Int?
	var mile : Int?
	var stopOver : Bool?
	var flightInfoIndex : String?
	var stopPoint : String?
	var stopPointArrivalTime : String?
	var stopPointDepartureTime : String?
	var craft : String?
	var remark : String?
	var isETicketEligible : Bool?
	var flightStatus : String?
	var status : String?
	var fareClassification : FareClassification?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		baggage <- map["Baggage"]
		cabinBaggage <- map["CabinBaggage"]
		cabinClass <- map["CabinClass"]
		tripIndicator <- map["TripIndicator"]
		segmentIndicator <- map["SegmentIndicator"]
		airline <- map["Airline"]
		origin <- map["Origin"]
		destination <- map["Destination"]
		duration <- map["Duration"]
		groundTime <- map["GroundTime"]
		mile <- map["Mile"]
		stopOver <- map["StopOver"]
		flightInfoIndex <- map["FlightInfoIndex"]
		stopPoint <- map["StopPoint"]
		stopPointArrivalTime <- map["StopPointArrivalTime"]
		stopPointDepartureTime <- map["StopPointDepartureTime"]
		craft <- map["Craft"]
		remark <- map["Remark"]
		isETicketEligible <- map["IsETicketEligible"]
		flightStatus <- map["FlightStatus"]
		status <- map["Status"]
		fareClassification <- map["FareClassification"]
	}

}