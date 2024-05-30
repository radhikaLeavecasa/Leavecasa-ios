/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct TripBooking_hotel : Mappable {
	var address : String?
	var booking_items : [TripBooking_items]?
	var category : Int?
	var city_code : String?
	var city_name : String?
	var country_code : String?
	var country_name : String?
	var description : String?
//	var geolocation : TripGeolocation?
	var hotel_code : String?
	var name : String?
	var paxes : [TripPaxes]?
	var safe2stay : [String]?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		address <- map["address"]
		booking_items <- map["booking_items"]
		category <- map["category"]
		city_code <- map["city_code"]
		city_name <- map["city_name"]
		country_code <- map["country_code"]
		country_name <- map["country_name"]
		description <- map["description"]
//		geolocation <- map["geolocation"]
		hotel_code <- map["hotel_code"]
		name <- map["name"]
		paxes <- map["paxes"]
		safe2stay <- map["safe2stay"]
	}

}


struct TripHotelImage : Mappable {
    var created_at : String?
    var hotel_code : Int?
    var image_caption : String?
    var image_url : String?
    var main_image : String?
    var updated_at : String?
   

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        created_at <- map["created_at"]
        hotel_code <- map["hotel_code"]
        image_caption <- map["image_caption"]
        image_url <- map["image_url"]
        main_image <- map["main_image"]
        updated_at <- map["updated_at"]
       
    }

}
