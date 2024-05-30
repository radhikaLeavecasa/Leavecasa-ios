/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct Baggage : Mappable {
	var airlineCode : String?
	var flightNumber : String?
	var wayType : Int?
	var code : String?
    var text : String?
	var description : Int?
	var weight : Int?
	var currency : String?
	var price : Int?
	var origin : String?
	var destination : String?

    var baggageDict : [String:Any]  {
        return ["AirlineCode" : airlineCode ?? "" ,"FlightNumber":flightNumber ?? "","WayType":wayType ?? 0,"Code":code ?? "","Description" : description ?? "", "Currency":currency ?? "","Price":price ?? 0 ,"Origin":origin ?? "" ,"Destination":destination ?? "","Weight":weight ?? 0]
    }
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		airlineCode <- map["AirlineCode"]
		flightNumber <- map["FlightNumber"]
		wayType <- map["WayType"]
		code <- map["Code"]
		description <- map["Description"]
		weight <- map["Weight"]
		currency <- map["Currency"]
		price <- map["Price"]
		origin <- map["Origin"]
		destination <- map["Destination"]
        text <- map["Text"]
	}

}

struct BaggageNonLCC : Mappable {
   
    var code : String?
    var description : String?

    var baggageDict : [String:Any]  {
        return ["Code":code ?? "","Description" : description ?? ""]
    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        code <- map["Code"]
        description <- map["Description"]
    }

}
