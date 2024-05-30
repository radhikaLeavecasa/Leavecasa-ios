/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct MealDynamic : Mappable {
	var airlineCode : String?
	var flightNumber : String?
	var wayType : Int?
	var code : String?
	var description : Int?
	var airlineDescription : String?
	var quantity : Int?
	var currency : String?
	var price : Int?
	var origin : String?
	var destination : String?

    var MealDynamicDict : [String:Any]  {
        return ["AirlineCode" : airlineCode ?? "" ,"FlightNumber":flightNumber ?? "","WayType":wayType ?? 0,"Code":code ?? "","Description":description ?? 0, "AirlineDescription" : airlineDescription ?? "", "Quantity":quantity ?? 0 , "Currency":currency ?? "","Price":price ?? 0 ,"Origin":origin ?? "" ,"Destination":destination ?? ""]
    }
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		airlineCode <- map["AirlineCode"]
		flightNumber <- map["FlightNumber"]
		wayType <- map["WayType"]
		code <- map["Code"]
		description <- map["Description"]
		airlineDescription <- map["AirlineDescription"]
		quantity <- map["Quantity"]
		currency <- map["Currency"]
		price <- map["Price"]
		origin <- map["Origin"]
		destination <- map["Destination"]
	}
}

struct Meal : Mappable {
    
    var code : String?
    var description : String?
    

    var MealDynamicDict : [String:Any]  {
        return ["Code":code ?? "","Description":description ?? ""]
    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        code <- map["Code"]
        description <- map["Description"]
       
    }

}
struct CityState : Mappable {
    
    var code : String?
    var name : String?
    var data : [CityState]?

    var MealDynamicDict : [String:Any]  {
        return ["code":code ?? "",WSResponseParams.WS_RESP_PARAM_LOCALNAME:name ?? ""]
    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        code <- map["code"]
        name <- map[WSResponseParams.WS_RESP_PARAM_LOCALNAME]
        data <- map[WSResponseParams.WS_REPS_PARAM_DATA]
    }
}
