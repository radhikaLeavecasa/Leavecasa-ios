//
//  SelectSeatViewModel.swift
//  LeaveCasa
//
//  Created by acme on 14/12/22.
//

import Foundation

class SelectSeatViewModel{
    
    var AirlineCode : String?
    var FlightNumber : String?
    var CraftType : String?
    var Code : String?
    var RowNo : String?
    var SeatNo : String?
    var SeatType : Int?
    var SeatWayType : Int?
    var Compartment : Int?
    var Deck : Int?
    var Currency: String?
    var Price : Double?
    
    convenience init(response:[String:Any]) {
        self.init()
        self.AirlineCode = response[WSResponseParams.WS_RESP_PARAM_AIRLINE_CODE] as? String ?? ""
        self.FlightNumber = response[WSResponseParams.WS_RESP_PARAM_FLIGHT_NO] as? String ?? ""
        self.CraftType = response[WSResponseParams.WS_RESP_PARAM_CRAFT_TYPE] as? String ?? ""
        self.Code = response[WSResponseParams.WS_RESP_PARAM_CODE] as? String ?? ""
        self.RowNo = response[WSResponseParams.WS_RESP_PARAM_ROW_NO] as? String ?? ""
        self.SeatNo = response[WSResponseParams.WS_RESP_PARAM_SEAT_NO] as? String ?? ""
        self.SeatType = response[WSResponseParams.WS_RESP_PARAM_SEAT_TYPE] as? Int ?? 0
        self.SeatWayType = response[WSResponseParams.WS_RESP_PARAM_SEAT_WAY_TYPE] as? Int ?? 0
        self.Compartment = response[WSResponseParams.WS_RESP_PARAM_COMPARTMENT] as? Int ?? 0
        self.Deck = response[WSResponseParams.WS_RESP_PARAM_DECK] as? Int ?? 0
        self.Currency = response[WSResponseParams.WS_RESP_PARAM_CURRENCY] as? String ?? ""
        self.Price = response[WSResponseParams.WS_RESP_PARAM_PRICE] as? Double ?? 0.0
        
    }
}
