/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct TripData : Mappable {
	var id : Int?
	var name : String?
	var email : String?
	var api_token : String?
	var mobile : String?
	var address : String?
	var dob : String?
	var profile_pic : String?
	var path : String?
	var flight_booking : [TripFlightBooking]?
	var hotel : [TripHotel]?
	var bus : [TripBus]?
    var insurance: [InsuranceBookingResponse]?

	init?(map: Map) {
          
	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		name <- map["name"]
		email <- map["email"]
		api_token <- map["api_token"]
		mobile <- map["mobile"]
		address <- map["address"]
		dob <- map["dob"]
		profile_pic <- map["profile_pic"]
		path <- map["path"]
		flight_booking <- map["flight_booking"]
        hotel <- map["hotel"]
		bus <- map["bus"]
        insurance <- map["insurance"]
	}
}

struct InsuranceBookingResponse: Mappable {
    var bookingId: Int?
    var createdAt: String?
    var details: BookingDetails?
    var id: Int?
    var refundData: Any? // You can replace Any with a specific type if needed
    var status: String?
    var traceId: String?
    var updatedAt: String?
    var userData: Any? // You can replace Any with a specific type if needed
    var userId: Int?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        bookingId <- map["booking_id"]
        createdAt <- map["created_at"]
        details <- map["details"]
        id <- map["id"]
        refundData <- map["refund_data"]
        status <- map["status"]
        traceId <- map["trace_id"]
        updatedAt <- map["updated_at"]
        userData <- map["user_data"]
        userId <- map["user_id"]
    }
}
struct BookingDetails: Mappable {
    var response: InsuranceGetDetailModel?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        response <- map["Response"]
    }
}
