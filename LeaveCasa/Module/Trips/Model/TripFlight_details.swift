/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct TripFlightDetails: Mappable {
    var pNR: String?
    var bookingId: Int?
    var sSRDenied: Bool?
    var sSRMessage: String?
    var status: Int?
    var isPriceChanged: Bool?
    var isTimeChanged: Bool?
    var flightItinerary: TripFlightItinerary?
    var ticketStatus: Int?
    var invoiceAmount: Int?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        invoiceAmount <- map["InvoiceAmount"]
        pNR <- map["PNR"]
        bookingId <- map["BookingId"]
        sSRDenied <- map["SSRDenied"]
        sSRMessage <- map["SSRMessage"]
        status <- map["Status"]
        isPriceChanged <- map["IsPriceChanged"]
        isTimeChanged <- map["IsTimeChanged"]
        flightItinerary <- map["FlightItinerary"]
        ticketStatus <- map["TicketStatus"]
    }
}

struct PaymentData: Mappable {
    var total_amount: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        total_amount <- map["total_amount"]
    }
}

