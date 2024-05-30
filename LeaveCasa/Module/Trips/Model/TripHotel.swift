/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct TripHotel : Mappable {
	var id : Int?
	var log_id : Int?
	var customer_id : Int?
	var booking_id : String?
	var booked_by : Int?
	var total_amount : String?
	var from_date : String?
	var to_date : String?
	var payment_from : String?
	var booking_status : String?
	var updated_at : String?
	var created_at : String?
	var tripHotel : TripBooking_hotel?
    var hotelImages : [TripHotelImage]?
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		log_id <- map["log_id"]
		customer_id <- map["customer_id"]
		booking_id <- map["booking_id"]
		booked_by <- map["booked_by"]
		total_amount <- map["total_amount"]
		from_date <- map["from_date"]
		to_date <- map["to_date"]
		payment_from <- map["payment_from"]
		booking_status <- map["booking_status"]
		updated_at <- map["updated_at"]
		created_at <- map["created_at"]
        tripHotel <- map["hotel"]
        hotelImages <- map["hotel_images"]
	}
}
