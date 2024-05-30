/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct TripBus : Mappable {
	var id : Int?
	var customer_id : Int?
	var total_amount : Int?
	var from_destination : String?
	var to_destination : String?
	var request_data : String?
	var booked_by : String?
	var booking_id : String?
	var journey_date : String?
	var booking_status : String?
	var payment_from : String?
	var updated_at : String?
	var created_at : String?
	var bus_details : TripBus_details?
    var response_data: String?
    
	init?(map: Map) {
        if let jsonData = response_data?.data(using: .utf8) {
            do {
                // Convert Data to JSON object
                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    // Use JSON object
                    print(jsonObject)
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        } else {
            print("Error converting string to data")
        }
	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		customer_id <- map["customer_id"]
		total_amount <- map["total_amount"]
		from_destination <- map["from_destination"]
		to_destination <- map["to_destination"]
		request_data <- map["request_data"]
		booked_by <- map["booked_by"]
		booking_id <- map["booking_id"]
		journey_date <- map["journey_date"]
		booking_status <- map["booking_status"]
		payment_from <- map["payment_from"]
		updated_at <- map["updated_at"]
		created_at <- map["created_at"]
		bus_details <- map["bus_details"]
        
	}
}


