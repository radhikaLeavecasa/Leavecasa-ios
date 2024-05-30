//
//  BusListViewModel.swift
//  LeaveCasa
//
//  Created by acme on 27/10/22.
//

import Foundation
import ObjectMapper

class BusListViewModel{
    lazy var buses = [Bus]()
    lazy var markups = Markup()
    var delegate : ResponseProtocol?
    
    func searchBus(param:[String:Any],souceName:String,destinationName:String,checkinDate:Date, view: UIViewController){
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .busSearch, param: param) { status, msg, responseData in
            
            print(responseData)
            if status == true{
                let response = responseData as? [String:Any] ?? [:]
                print(response)
                
                if let response = response[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [String: Any] {
                    if let availableTrips = response[WSResponseParams.WS_RESP_PARAM_AVAILABLE_TRIPS] as? [[String: Any]] {
                        if let busArr = Mapper<Bus>().mapArray(JSONArray: availableTrips) as [Bus]? {
                            self.buses = busArr
                            self.buses = self.buses.sorted{Double($0.fareDetailsArray.first?[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? Double($0.fareDetails[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? 0.0 < Double($1.fareDetailsArray.first?[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? Double($1.fareDetails[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? 0.0}
                        }
                    }else if let availableTrips = response[WSResponseParams.WS_RESP_PARAM_AVAILABLE_TRIPS] as? [String: Any] {
                        if let busArr = Mapper<Bus>().mapArray(JSONArray: [availableTrips]) as [Bus]? {
                            self.buses = busArr
                            self.buses = self.buses.sorted{Double($0.fareDetailsArray.first?[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? Double($0.fareDetails[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? 0.0 < Double($1.fareDetailsArray.first?[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? Double($1.fareDetails[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? 0.0}
                        }
                    }
                    if let markups = response[WSResponseParams.WS_RESP_PARAM_MARKUP] as? [String: Any] , let markup = Mapper<Markup>().map(JSON: markups) as Markup? {
                        self.markups = markup
                    }
                    DispatchQueue.main.async {
                        self.delegate?.onSuccess()
                    }
                }
                
            }else{
                view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg)
                self.delegate?.onFail?(msg: msg)
                LoaderClass.shared.stopAnimation()
            }
        }
    }
}
