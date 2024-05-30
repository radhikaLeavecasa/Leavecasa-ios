//
//  FlightCalenderListModel.swift
//  LeaveCasa
//
//  Created by acme on 15/11/22.
//

import Foundation

class FlightCalenderListModel{
    
    var AirlineCode : String?
    var AirlineName : String?
    var BaseFare    : String?
    var DepartureDate : String?
    var fare        : Double?
    var FuelSurcharge : Int?
    var IsLowestFareOfMonth : Int?
    var OtherCharges : Int?
    var Tax         : Double?
    
    convenience init(response:[String:Any]) {
        self.init()
        
        self.AirlineCode = response[WSResponseParams.WS_RESP_PARAM_AIRLINE_CODE] as? String ?? ""
        self.AirlineName = response[WSResponseParams.WS_RESP_PARAM_AIRLINE_NAME] as? String ?? ""
        self.BaseFare = response[WSResponseParams.WS_RESP_PARAM_BASE_FARE] as? String ?? ""
        self.DepartureDate = response[WSResponseParams.WS_RESP_PARAM_DEPARTUREDATE] as? String ?? ""
        self.fare = response[WSResponseParams.WS_RESP_PARAM_FARE_CAP] as? Double ?? 0
        self.FuelSurcharge = response[WSResponseParams.WS_RESP_PARAM_FUEL_CHARGE] as? Int ?? 0
        self.IsLowestFareOfMonth = response[WSResponseParams.WS_RESP_PARAM_IS_LOWEST_FARE] as? Int ?? 0
        self.OtherCharges = response[WSResponseParams.WS_RESP_PARAM_OTHER_CHARGES] as? Int ?? 0
        self.Tax = response[WSResponseParams.WS_RESP_PARAM_TAX] as? Double ?? 0
    }
    
}
