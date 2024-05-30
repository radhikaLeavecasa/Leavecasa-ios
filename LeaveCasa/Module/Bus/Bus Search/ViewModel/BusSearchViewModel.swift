//
//  BusSearchViewModel.swift
//  LeaveCasa
//
//  Created by acme on 22/09/22.
//

import Foundation
import ObjectMapper

class BusSearchViewModel{
    
    lazy var cityCode = [Int]()
    lazy var cityName = [String]()
    lazy var sourceresult = [[String:Any]]()
    var delegate : ResponseProtocol?
    var couponsData: [CouponData]?
    lazy var destinationCode = [String]()
    lazy var destinationName = [String]()
    lazy var destinationresult = [[String:Any]]()
    lazy var buses = [Bus]()
    lazy var markups = Markup()
    
    func fatchFromCity(city:String, title: String = "Source", txtfldFrom: String = "", txtCode: Int = 0, view:UIViewController) {
        let string = city.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20")
        
        WebService.callApi(api: .busSourceSearch(string), method: .get,param: [:]) { status, msg, responseData in
            if status == true{
                self.cityName.removeAll()
                self.cityCode.removeAll()
                self.sourceresult.removeAll()
                let response = responseData as? [String:Any] ?? [:]
                if let sources = response[WSResponseParams.WS_RESP_PARAM_SOURCES] as? [[String:Any]]{
                    self.sourceresult = sources
                    for dict in sources {
                        self.cityName.append(dict[WSResponseParams.WS_RESP_PARAM_CITY_NAME] as? String ?? "")
                        self.cityCode.append(dict[WSResponseParams.WS_RESP_PARAM_CITY_CODE] as? Int ?? 0)
                    }
                }
                if title == "Source" {
                    self.cityName = Array(Set(self.cityName))
                    self.cityCode = Array(Set(self.cityCode))
                } else {
                    self.cityName = Array(Set(self.cityName)).filter({$0 != txtfldFrom})
                    self.cityCode = Array(Set(self.cityCode)).filter({$0 != txtCode})
                }
                self.delegate?.onSuccess()
                
            } else {
                view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg)
                self.delegate?.onFail?(msg: msg)
            }
        }
    }
    
    func fetchDestinationCityList(cityCode:Int, view: UIViewController) {
        
        WebService.callApi(api: .busDestinationSearch(cityCode), method: .get,param: [:]) { status, msg, responseData in
            
            print(responseData)
            
            if status == true{
                
                self.destinationName.removeAll()
                self.destinationresult.removeAll()
                self.destinationCode.removeAll()
                let response = responseData as? [String:Any] ?? [:]
                let results = response[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [String:Any] ?? [:]
                if let results = results[WSResponseParams.WS_RESP_PARAM_CITES] as? [[String: Any]] {
                    self.destinationresult = results
                    for i in 0..<results.count {
                        let dict = results[i]
                        self.destinationName.append(dict[WSRequestParams.WS_REQS_PARAM_NAME] as? String ?? "")
                        self.destinationCode.append(dict[WSResponseParams.WS_RESP_PARAM_ID] as? String ?? "")
                    }
                }
            }else{
                view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg)
                self.delegate?.onFail?(msg: msg)
            }
        }
    }
    
    func searchBus(param:[String:Any],view:UIViewController,souceName:String,destinationName:String,checkinDate:Date,date:String){
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .busSearch, param: param) { status, msg, responseData in
            print(responseData)
            if status == true{
                self.buses.removeAll()
                let response = responseData as? [String:Any] ?? [:]
                print(response)
                
                let logID = response[WSResponseParams.WS_RESP_PARAM_LOGID]  as? Int ?? 0
                
                if let response = response[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [String: Any] {
                    
                    if let availableTrips = response[WSResponseParams.WS_RESP_PARAM_AVAILABLE_TRIPS] as? [[String: Any]] {
                        if let busArr = Mapper<Bus>().mapArray(JSONArray: availableTrips) as [Bus]? {
                            self.buses = busArr
                        }
                    }else if let availableTrips = response[WSResponseParams.WS_RESP_PARAM_AVAILABLE_TRIPS] as? [String: Any] {
                        if let busArr = Mapper<Bus>().mapArray(JSONArray: [availableTrips]) as [Bus]? {
                            self.buses = busArr
                        }
                    }
                    
                    if let markups = response[WSResponseParams.WS_RESP_PARAM_MARKUP] as? [String: Any] , let markup = Mapper<Markup>().map(JSON: markups) as Markup? {
                        self.markups = markup
                    }
                    
                    if let vc = ViewControllerHelper.getViewController(ofType: .BusListVC, StoryboardName: .Bus) as? BusListVC {
                        vc.buses = self.buses.sorted{Double($0.fareDetailsArray.first?[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? Double($0.fareDetails[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? 0.0 < Double($1.fareDetailsArray.first?[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? Double($1.fareDetails[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? 0.0}

                        vc.couponsData = self.couponsData
                        vc.markups = self.markups
                        vc.searchedParams = param
                        vc.souceName = souceName
                        vc.logID = logID
                        vc.destinationName = destinationName
                        vc.viewModel.markups = self.markups
                        vc.checkInDate = checkinDate
                        vc.selectedDateSting = date
                        vc.sourceCityCode = param[WSRequestParams.WS_REQS_PARAM_BUS_FROM] as? Int ?? 0
                        vc.destinationCityCode = param[WSRequestParams.WS_REQS_PARAM_BUS_TO] as? Int ?? 0
                        view.pushView(vc: vc)
                        
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

