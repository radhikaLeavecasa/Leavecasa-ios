/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct NotificationData : Mappable {
	var id : Int?
	var subject : String?
	var content : String?
	var user_device_id : String?
	var user_id : Int?
	var booking_id : String?
	var booking_type : String?
	var read_status : String?
	var type : String?
	var updated_at : String?
	var created_at : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		subject <- map["subject"]
		content <- map["content"]
		user_device_id <- map["user_device_id"]
		user_id <- map["user_id"]
		booking_id <- map["booking_id"]
		booking_type <- map["booking_type"]
		read_status <- map["read_status"]
		type <- map["type"]
		updated_at <- map["updated_at"]
		created_at <- map["created_at"]
	}

}
