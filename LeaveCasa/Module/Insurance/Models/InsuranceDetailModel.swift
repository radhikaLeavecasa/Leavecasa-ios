//
//  InsuranceDetailModel.swift
//  LeaveCasa
//
//  Created by acme on 09/05/24.
//

import UIKit
import ObjectMapper

struct InsuranceDetails {
    var title = ""
    var firstName = ""
    var lastName = ""
    var gender = ""
    var dob = ""
    var email = ""
    var destination = ""
    var mobile = ""
    var address = ""
    var country = ""
    var countryCode = ""
    var state = ""
    var city = ""
    var passportNumber = ""
    var pincode = ""
    var beneficiaryFullName = ""
    var beneficiaryTitle = ""
    var insuredRelation = ""
    var isSameAddress = false
    var isSameMobile = false
    var isSameEmail = false
    var isSameFullName = false
}

struct CountryModel : Mappable {
    
    var code: String?
    var name: String?
    var codeAlpha: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        code <- map[CommonParam.CODE]
        name <- map[WSResponseParams.WS_RESP_PARAM_LOCALNAME]
        codeAlpha <- map[WSResponseParams.WS_REPS_PARAM_CODE_ALPHA]
    }
}

