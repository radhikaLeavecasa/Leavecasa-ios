/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct TripFare: Mappable {
    var currency: String?
    var baseFare: Int?
    var tax: Int?
    var yQTax: Int?
    var additionalTxnFeeOfrd: Int?
    var additionalTxnFeePub: Int?
    var pGCharge: Int?
    var otherCharges: Double?
    var discount: Int?
    var publishedFare: Double?
    var commissionEarned: Double?
    var pLBEarned: Double?
    var incentiveEarned: Double?
    var offeredFare: Double?
    var tdsOnCommission: Double?
    var tdsOnPLB: Double?
    var tdsOnIncentive: Double?
    var serviceFee: Int?
    var totalBaggageCharges: Int?
    var totalMealCharges: Int?
    var totalSeatCharges: Int?
    var totalSpecialServiceCharges: Int?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        currency <- map["Currency"]
        baseFare <- map["BaseFare"]
        tax <- map["Tax"]
        yQTax <- map["YQTax"]
        additionalTxnFeeOfrd <- map["AdditionalTxnFeeOfrd"]
        additionalTxnFeePub <- map["AdditionalTxnFeePub"]
        pGCharge <- map["PGCharge"]
        otherCharges <- map["OtherCharges"]
        discount <- map["Discount"]
        publishedFare <- map["PublishedFare"]
        commissionEarned <- map["CommissionEarned"]
        pLBEarned <- map["PLBEarned"]
        incentiveEarned <- map["IncentiveEarned"]
        offeredFare <- map["OfferedFare"]
        tdsOnCommission <- map["TdsOnCommission"]
        tdsOnPLB <- map["TdsOnPLB"]
        tdsOnIncentive <- map["TdsOnIncentive"]
        serviceFee <- map["ServiceFee"]
        totalBaggageCharges <- map["TotalBaggageCharges"]
        totalMealCharges <- map["TotalMealCharges"]
        totalSeatCharges <- map["TotalSeatCharges"]
        totalSpecialServiceCharges <- map["TotalSpecialServiceCharges"]
    }
}

