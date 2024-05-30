/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct PassangerData : Mappable {
	var id : Int?
	var user_id : Int?
	var title : String?
	var first_name : String?
	var last_name : String?
	var email : String?
	var mobile : String?
	var address1 : String?
	var address2 : String?
	var city : String?
	var state : String?
	var country : String?
	var zip_code : String?
	var aadhar_number : String?
	var dob : String?
	var updated_at : String?
	var created_at : String?
    var isSelected = false
    //var gender: String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		user_id <- map["user_id"]
		title <- map["title"]
		first_name <- map["first_name"]
		last_name <- map["last_name"]
		email <- map["email"]
		mobile <- map["mobile"]
		address1 <- map["address1"]
		address2 <- map["address2"]
		city <- map["city"]
		state <- map["state"]
		country <- map["country"]
		zip_code <- map["zip_code"]
		aadhar_number <- map["aadhar_number"]
		dob <- map["dob"]
		updated_at <- map["updated_at"]
		created_at <- map["created_at"]
        //gender <- map["gender"]
        isSelected = false
	}
}
