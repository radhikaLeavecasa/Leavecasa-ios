/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct Seats : Mappable {
    var airlineCode = String()
    var flightNumber = String()
    var craftType = String()
    var origin = String()
    var destination = String()
    var availablityType = Int()
    var description = Int()
    var code = String()
    var rowNo = String()
    var seatNo = String()
    var seatType = Int()
    var seatWayType = Int()
    var compartment = Int()
    var deck = Int()
    var currency = String()
    var price = Int()

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        airlineCode <- map["AirlineCode"]
        flightNumber <- map["FlightNumber"]
        craftType <- map["CraftType"]
        origin <- map["Origin"]
        destination <- map["Destination"]
        availablityType <- map["AvailablityType"]
        description <- map["Description"]
        code <- map["Code"]
        rowNo <- map["RowNo"]
        seatNo <- map["SeatNo"]
        seatType <- map["SeatType"]
        seatWayType <- map["SeatWayType"]
        compartment <- map["Compartment"]
        deck <- map["Deck"]
        currency <- map["Currency"]
        price <- map["Price"]
    }
}

struct SeatsPreference : Mappable {
    
    var code : String?
    var description : String?
    

    var seatsPreferenceDict : [String:Any]  {
        return ["Code":code ?? "","Description":description ?? ""]
    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        code <- map["Code"]
        description <- map["Description"]
       
    }
}
