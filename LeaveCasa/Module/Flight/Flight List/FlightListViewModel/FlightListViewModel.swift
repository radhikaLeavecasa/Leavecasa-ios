//
//  FlightListViewModel.swift
//  LeaveCasa
//
//  Created by acme on 15/11/22.
//

import Foundation
import Alamofire
import ObjectMapper

class FlightListViewModel{
    
    var dateModel = [FlightCalenderListModel]()
    var delegate : ResponseProtocol?
    var flights = [[Flight]]()
    var tokenId = ""
    var traceId = ""
    var logId = 0
    
    func getCalenderData(param:[String:Any],view:UIViewController){
        
        WebService.callApi(api: .calenderFare, param:param,encoding: JSONEncoding.default) { status, msg, response in
            debugPrint(response)
              self.dateModel.removeAll()
            if status == true{
                let response = response as? [String:Any] ??  [:]
                if let response = response[WSResponseParams.WS_RESP_PARAM_RESPONSE] as? [String:Any]{
                    if let Response = response[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:Any]{
                        if let SearchResults = Response[WSResponseParams.WS_RESP_PARAM_SEARCH_RESULT] as? [[String:Any]]{
                            for index in SearchResults{
                                let model = FlightCalenderListModel.init(response: index)
                                self.dateModel.append(model)
                                LoaderClass.shared.stopAnimation()
                            }
                        }
                    }
                }
                LoaderClass.shared.stopAnimation()
                self.delegate?.onSuccess()
            }else{
                LoaderClass.shared.stopAnimation()
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
    
    func searchFlight(param:[String:Any],view:UIViewController){
        self.flights.removeAll()
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .flightSearch, param: param,encoding: JSONEncoding.default) { status, msg, response in

            if status == true {
                self.flights.removeAll()
                if let responseValue = response as? [String: AnyObject] {
                    debugPrint(responseValue)
                    let responseValue = responseValue[WSResponseParams.WS_RESP_PARAM_RESPONSE] as? [String:AnyObject] ?? [:]
                    if let responseDict = responseValue[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:AnyObject] {
                        
                        var allFlights = [[Flight]] ()
                        
                        if let results = responseDict[WSResponseParams.WS_RESP_PARAM_RESULTS_CAP] as? [AnyObject] {
                            var flights = [[String: AnyObject]]()
                            
                            for result in results {
                                if let flight = result as? [[String: AnyObject]] {
                                    flights = flight
                                }
                                if let results = Mapper<Flight>().mapArray(JSONArray: flights) as [Flight]? {
                                    allFlights.append(results)
                                }
                            }
                            
                            if let item = responseValue[WSResponseParams.WS_RESP_PARAM_LOGID] as? Int {
                                self.logId = item
                            }
                            
                            if let item = responseValue[WSResponseParams.WS_RESP_PARAM_TOKEN_ID] as? String {
                                self.tokenId = item
                            }
                            
                            if let item = responseDict[WSResponseParams.WS_RESP_PARAM_TRACE_ID] as? String {
                                self.traceId = item
                            }
                            
                            self.flights = allFlights
                            DispatchQueue.main.async {
                                if self.flights.count > 0 {
                                    self.flights[0] = self.flights[0].sorted{(($0.sFare.sBaseFare) < ($1.sFare.sBaseFare))}
                                    LoaderClass.shared.stopAnimation()
                                    self.delegate?.onFlightReload!()
                                }
                            }
                        }
                    }
                }
                
            }else{
                LoaderClass.shared.stopAnimation()
                self.delegate?.onFail?(msg: msg)
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
}
