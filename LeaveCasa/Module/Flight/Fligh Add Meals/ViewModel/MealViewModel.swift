//
//  MealViewModel.swift
//  LeaveCasa
//
//  Created by acme on 13/12/22.
//

import Foundation

class MealViewModel{
    lazy var AirlineCode = String()
    lazy var AirlineDescription = String()
    lazy var Code = String()
    lazy var Currency = String()
    lazy var Description = Int()
    lazy var Destination = String()
    lazy var FlightNumber = String()
    lazy var Origin = String()
    lazy var Price = Int()
    lazy var Quantity = Int()
    lazy var WayType = Int()
    
    convenience init(response:[String:Any]) {
        self.init()
        self.AirlineCode = response[WSResponseParams.WS_RESP_PARAM_AIRLINE_CODE] as? String ?? ""
        self.AirlineDescription = response[WSResponseParams.WS_RESP_PARAM_TOTAL_AIRLINE_DESC] as? String ?? ""
        self.Code = response[WSResponseParams.WS_RESP_PARAM_CODE] as? String ?? ""
        self.Currency = response[WSResponseParams.WS_RESP_PARAM_CURRENCY] as? String ?? ""
        self.Description = response[WSResponseParams.WS_RESP_PARAM_DESCRIPTION] as? Int ?? 0
        self.Destination = response[WSResponseParams.WS_RESP_PARAM_DESTINATION] as? String ?? ""
        self.FlightNumber = response[WSResponseParams.WS_RESP_PARAM_FLIGHT_NO] as? String ?? ""
        self.Origin = response[WSResponseParams.WS_RESP_PARAM_ORIGIN] as? String ?? ""
        self.Price = response[WSResponseParams.WS_RESP_PARAM_PRICE] as? Int ?? 0
        self.Quantity = response[WSResponseParams.WS_RESP_PARAM_QUANTITY] as? Int ?? 0
        self.WayType = response[WSResponseParams.WS_RESP_PARAM_WAY_TYPE] as? Int ?? 0
    }
}
