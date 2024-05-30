/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct TripPassenger: Mappable {
    var address: String?
    var age: String?
    var email: String?
    var email2: String?
    var gender: String?
    var idNumber: String?
    var idType: String?
    var mobile: String?
    var name: String?
    var primary: String?
    var singleLadies: String?
    var title: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        address <- map["address"]
        age <- map["age"]
        email <- map["email"]
        email2 <- map["Email"]
        gender <- map["gender"]
        idNumber <- map["idNumber"]
        idType <- map["idType"]
        mobile <- map["mobile"]
        name <- map["name"]
        primary <- map["primary"]
        singleLadies <- map["singleLadies"]
        title <- map["title"]
    }
}

