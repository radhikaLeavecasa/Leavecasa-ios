//
//  SearchViewModel.swift
//  LeaveCasa
//
//  Created by acme on 02/11/22.
//

import Foundation
import SearchTextField
import ObjectMapper
import Alamofire

class SearchFlightViewModel{
    
    lazy var cityCode = [String]()
    lazy var cityName = [String]()
    lazy var markups = [Markup]()
    var delegate : ResponseProtocol?
    
    func searchFlightApi(_ sender: UITextField,view:UIViewController){
        
        let string = sender.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20") ?? ""
        
        if string.isEmpty == true{
            return
        }
        WebService.callApi(api: .airportCityCode(string),method: .get ,param: [:]) { status, msg, response in
            debugPrint(response)
            
            LoaderClass.shared.stopAnimation()
            if status == true{
                self.cityName.removeAll()
                self.cityCode.removeAll()
                
                let response = response as? [String:Any] ?? [:]
                let codes = response["codes"] as? [[String:Any]] ?? []
                
                for i in 0..<codes.count {
                    let dict = codes[i]
                    self.cityName.append(dict[WSResponseParams.WS_RESP_PARAM_CITY_NAME] as? String ?? "")
                    self.cityCode.append(dict[WSResponseParams.WS_RESP_PARAM_CITY_CODE] as? String ?? "")
                }
                
                self.delegate?.onSuccess()
            }else{
                LoaderClass.shared.stopAnimation()
                if msg.contains("URL is not valid") {
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: "Enter valid location")
                } else {
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)

                }
            }
        }
    }
    
    func searchFlight(param:[String:Any], selectedTab:Int, array:[FlightStruct], sharedParam:[String:Any], view: UIViewController, couponData: [CouponData], isFareScreen: Bool = false) {
        LoaderClass.shared.loadAnimation()
        if isFareScreen {
            LoaderClass.shared.isFareScreen = true
        }
        
        WebService.callApi(api: .flightSearch, param: param,encoding: JSONEncoding.default) { status, msg, response in
            
            if status == true{
                if let responseValue = response as? [String: Any] {
                    debugPrint(responseValue)
                    if let markups = responseValue[WSResponseParams.WS_RESP_PARAM_MARKUPS] as? [[String: Any]] , let markup = Mapper<Markup>().mapArray(JSONArray: markups) as [Markup]? {
                        self.markups.append(contentsOf: markup)
                    }
                    let responseValue = responseValue[WSResponseParams.WS_RESP_PARAM_RESPONSE] as? [String:AnyObject] ?? [:]
                    
                    var tokenId = ""
                    var traceId = ""
                    var logId = 0
                    
                    if let item = responseValue["logid"] as? Int {
                        logId = item
                    }
                    if let item = responseValue[WSResponseParams.WS_RESP_PARAM_TOKEN_ID] as? String {
                        tokenId = item
                    }
                    
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
                            
//                            if let item = responseValue[WSResponseParams.WS_RESP_PARAM_LOGID] as? Int {
//                                logId = item
//                            }
//                            if let item = responseValue[WSResponseParams.WS_RESP_PARAM_TOKEN_ID] as? String {
//                                tokenId = item
//                            }
                            if let item = responseDict[WSResponseParams.WS_RESP_PARAM_TRACE_ID] as? String {
                                traceId = item
                            }
                            
                        }
                        LoaderClass.shared.stopAnimation()
                       // view.webView.removeFromSuperview()
                        if selectedTab == 1 && allFlights.count == 1 {
                            if let vc = ViewControllerHelper.getViewController(ofType: .FlightReturnTripVC, StoryboardName: .Flight) as? FlightReturnTripVC {
                                vc.tokenId = tokenId
                                vc.markups = self.markups
                                vc.traceId = traceId
                                vc.logId = logId
                                vc.flights = allFlights
                                vc.startDate = array[0].fromDate
                                vc.calenderParam = sharedParam
                                vc.couponData = couponData
                                vc.searchedFlight = array
                                vc.numberOfChildren = Int(param["ChildCount"] as! String) ?? 0
                                vc.numberOfAdults = Int(param["AdultCount"] as! String) ?? 0
                                vc.numberOfInfants = Int(param["InfantCount"] as! String) ?? 0
                                vc.selectedTab = selectedTab
                                vc.markups = self.markups
                                view.pushView(vc: vc)
                            }
                        } else if (selectedTab == 0 && allFlights.count == 1) {
                            if let vc = ViewControllerHelper.getViewController(ofType: .FlightListVC, StoryboardName: .Flight) as? FlightListVC {
                                vc.tokenId = tokenId
                                vc.traceId = traceId
                                vc.logId = logId
                                vc.flights = allFlights
                                vc.markups = self.markups
                                vc.calenderParam = sharedParam
                                vc.searchParams = param
                                vc.couponData = couponData
                                vc.searchedFlight = array
                                vc.numberOfChildren = Int(param["ChildCount"] as! String) ?? 0
                                vc.numberOfAdults = Int(param["AdultCount"] as! String) ?? 0
                                vc.numberOfInfants = Int(param["InfantCount"] as! String) ?? 0
                                vc.selectedTab = selectedTab
                                view.pushView(vc: vc)
                            }
                        } else if (selectedTab == 1 && allFlights.count == 2) {
                            if let vc = ViewControllerHelper.getViewController(ofType: .FlightDomasticListVC, StoryboardName: .Flight) as? FlightDomasticListVC {
                                vc.tokenId = tokenId
                                vc.traceId = traceId
                                vc.logId = logId
                                vc.flights = allFlights
                                vc.endDate = array[0].toDate
                                vc.startDate = array[0].fromDate
                                vc.calenderParam = sharedParam
                                vc.searchParams = param
                                vc.searchedFlight = array
                                vc.couponData = couponData
                                vc.numberOfChildren = Int(param["ChildCount"] as! String) ?? 0
                                vc.numberOfAdults = Int(param["AdultCount"] as! String) ?? 0
                                vc.numberOfInfants = Int(param["InfantCount"] as! String) ?? 0
                                vc.selectedTab = selectedTab
                                vc.markups = self.markups
                                vc.isOneWayFlightOrInternational = allFlights.count == 1 ? true : false
                                view.pushView(vc: vc)
                            }
                        } else if selectedTab == 2 && allFlights.count == 1 {
                            if let vc = ViewControllerHelper.getViewController(ofType: .FlightMultiCityVC, StoryboardName: .Flight) as? FlightMultiCityVC {
                                vc.tokenId = tokenId
                                vc.traceId = traceId
                                vc.logId = logId
                                vc.flights = allFlights
                                vc.startDate = array[0].fromDate
                                vc.calenderParam = sharedParam
                                vc.searchParams = param
                                vc.searchedFlight = array
                                vc.couponData = couponData
                                vc.numberOfChildren = Int(param["ChildCount"] as! String) ?? 0
                                vc.numberOfAdults = Int(param["AdultCount"] as! String) ?? 0
                                vc.numberOfInfants = Int(param["InfantCount"] as! String) ?? 0
                                vc.selectedTab = selectedTab
                                vc.markups = self.markups
                                vc.sourceData = array.map{$0.sourceCode}
                                vc.sourceData.append(array.last?.destinationCode ?? "")
                                view.pushView(vc: vc)
                            }
                        }
                    }
                }else{
                    LoaderClass.shared.stopAnimation()
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
                }
            }else{
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    LoaderClass.shared.stopAnimation()
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
}
