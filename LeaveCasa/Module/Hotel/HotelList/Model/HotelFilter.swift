//
//  HotelFilter.swift
//  LeaveCasa
//
//  Created by acme on 03/10/22.
//

import Foundation

class HotelFilter{
    
    var created_at : String?
    var facility_name : String?
    var id : Int?
    var updated_at : String?
    var name : String?
    
    convenience init(response:[String:Any]){
        self.init()
        self.id = response[WSResponseParams.WS_RESP_PARAM_ID] as? Int ?? 0
        self.created_at = response[CommonParam.CREATED_AT] as? String ?? ""
        self.name = response[CommonParam.NAME] as? String ?? ""
        self.facility_name = response[CommonParam.FACILITY_NAME] as? String ?? ""
    }
}
