//
//  SearchViewModel.swift
//  LeaveCasa
//
//  Created by acme on 14/09/22.
//

import Foundation
import ObjectMapper
import Alamofire

class SearchViewModel{
    
    var delegate : ResponseProtocol?
    lazy var cityCode = [String]()
    lazy var cityName = [String]()
    lazy var countryCityName = [String]()
    
    lazy var domesticCity = [String]()
    lazy var domesticCode = [String]()
    
    lazy var internationalCity = [String]()
    lazy var internationalCode = [String]()
    lazy var internationalCityCountry = [String]()
     
    var hotelCount = Int()
    var dict = [[String: Any]]()
    var dict1 = [[String: Any]]()
    var dict2 = [[String: Any]]()
    
    func fatchHotels(cityCodeStr:String,txtCheckIn:String,txtCheckOut:String,finalRooms:[[String: AnyObject]],view:UIViewController,numberOfRooms:Int,numberOfAdults:Int,ageOfChildren:[Int],cityName:String, hotelData: [HotelRoomDetail]){
        
        let params: [String: Any] = [WSRequestParams.WS_REQS_PARAM_CURRENT_REQUEST: 0 ,
                                     WSRequestParams.WS_REQS_PARAM_DESTINATION_CODE: cityCodeStr,
                                     WSRequestParams.WS_REQS_PARAM_CHECKIN: txtCheckIn ,
                                     WSRequestParams.WS_REQS_PARAM_CHECKOUT: txtCheckOut ,
                                     WSRequestParams.WS_REQS_PARAM_ROOMS: finalRooms]
        
        WebService.callApi(api: .hotelSearch, param: params,encoding: JSONEncoding.default) { status, msg, responseValue in
            LoaderClass.shared.stopAnimation()
            if status == true{
                let responseData = responseValue as? [String:Any] ?? [:]
                if let response = responseData[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [[String: Any]] {
                    if let noOfHotels = responseData["no_of_hotels"] as? Int {
                        self.hotelCount = noOfHotels
                    }
                    if let markup = responseData[WSResponseParams.WS_RESP_PARAM_MARKUP] as? [[String: Any]] {
                        if let results = Mapper<Results>().mapArray(JSONArray: response) as [Results]?, let markupArr = Mapper<Markup>().mapArray(JSONArray: markup) as [Markup]? {
                            if results[0].hotels.count > 0 {
                                if let vc = ViewControllerHelper.getViewController(ofType: .HotelListVC, StoryboardName: .Hotels) as? HotelListVC{
                                    vc.hotelData = hotelData
                                    vc.days = LoaderClass.shared.calculateDaysBetweenDates(dateString1: txtCheckIn, dateString2: txtCheckOut) ?? 0
                                    vc.results = results
                                    vc.markups = markupArr
                                    vc.hotelCount = "\(self.hotelCount)" //"\(results.reduce(0) {$0 + $1.numberOfHotels })"
                                    vc.logId = responseData[WSResponseParams.WS_RESP_PARAM_LOGID] as? Int ?? 0
                                    vc.checkInDate = txtCheckIn.convertCheckinDate()
                                    vc.checkIn = txtCheckIn
                                    vc.checkOut = txtCheckOut
                                    vc.cityCodeStr = cityCodeStr
                                    vc.finalRooms = finalRooms
                                    vc.numberOfRooms = numberOfRooms
                                    vc.numberOfAdults = numberOfAdults
                                    vc.ageOfChildren = ageOfChildren
                                    vc.totalRequest = results[0].totalRequests
                                    vc.cityName = cityName
                                    view.pushView(vc: vc)
                                }
                                self.delegate?.onSuccess()
                            } else {
                                view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: results[0].error[0].messages[0])
                            }
                        }
                    }
                } else {
                    view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: "No availability for the requested search criteria")
                }
                
            }else{
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    LoaderClass.shared.stopAnimation()
                    view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
    
    func searchHotelCity(city:String,view:UIViewController){
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .getAllHotelCitiesList,method: .get, param: [:],header: true) { status, msg, response in
            
            if status == true{
                let responseData = response as? [String:Any]
                if self.cityName.count > 0 {
                    self.cityName.removeAll()
                }
                if self.cityCode.count > 0 {
                    self.cityCode.removeAll()
                }
                if let data = responseData?[CommonParam.DATA] as? [[String:Any]]{
                    for i in 0..<data.count {
                        let dict = data[i]
                        self.dict.append(dict)
                        self.cityName.append(dict[WSResponseParams.WS_RESP_PARAM_CITY] as? String ?? "")
                        self.cityCode.append(dict[WSResponseParams.WS_RESP_PARAM_CODE] as? String ?? "")
                    }
                }
              
                LoaderClass.shared.stopAnimation()
                self.delegate?.onSuccess()
            }else{
                LoaderClass.shared.stopAnimation()
                view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg)
            }
        }
    }
    
    func searchPackageCity(view:UIViewController){
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .searchCities, method: .get, param: [:],header: true) { status, msg, response in
            
            if status == true{
                if let resp = response as? [String:Any] {
                    if LoaderClass.shared.arrSearchResultAll.count > 0 {
                        LoaderClass.shared.arrSearchResultAll.removeAll()
                    }
                    if LoaderClass.shared.arrDomesticSearches.count > 0 {
                        LoaderClass.shared.arrDomesticSearches.removeAll()
                    }
                    if LoaderClass.shared.arrInternationalSearches.count > 0 {
                        LoaderClass.shared.arrInternationalSearches.removeAll()
                    }
                    if let data = resp["data"] as? [[String:Any]] {
                        if let arr = Mapper<CitySearchModel>().mapArray(JSONArray: data) as [CitySearchModel]? {
                            LoaderClass.shared.arrSearchResultAll = arr
                        }
                    }
                    if let data = resp["domestic"] as? [[String:Any]] {
                        if let arr = Mapper<CitySearchModel>().mapArray(JSONArray: data) as [CitySearchModel]? {
                            LoaderClass.shared.arrDomesticSearches = arr
                        }
                    }
                    if let data = resp["international"] as? [[String:Any]] {
                        if let arr = Mapper<CitySearchModel>().mapArray(JSONArray: data) as [CitySearchModel]? {
                            LoaderClass.shared.arrInternationalSearches = arr
                        }
                    }
                    self.delegate?.apiReload!()
                }
            }else{
                LoaderClass.shared.stopAnimation()
                view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg)
            }
        }
    }
    func fetchHotelsByCity(cityCodeStr:String,txtCheckIn:String,txtCheckOut:String,finalRooms:[[String: AnyObject]],view:UIViewController,numberOfRooms:Int,numberOfAdults:Int,ageOfChildren:[Int],cityName:String, hotelData: [HotelRoomDetail]){
        var adultArr = [Any]()
        var childArr = [Any]()
        var childArr2 = [Any]()
        var childAges = [Any]()
        for i in finalRooms {
            adultArr.append(i["adults"]!)
            childArr.append(i["children_ages"] as Any)
        }
        for j in childArr {
            childArr2.append((j as AnyObject).count ?? 0)
            childAges.append(j)
        }
        let params: [String: Any] = [WSResponseParams.WS_RESP_PARAM_CITYCODE: cityCodeStr,
                                     WSRequestParams.WS_REQS_PARAM_CHECKIN: txtCheckIn ,
                                     WSRequestParams.WS_REQS_PARAM_CHECKOUT: txtCheckOut ,
                                     WSRequestParams.WS_REQS_PARAM_NO_OF_ROOMS: finalRooms,
                                     WSRequestParams.WS_REQS_PARAM_NO_OF_ADULTS: adultArr,
                                     WSRequestParams.WS_REQS_PARAM_NO_OF_CHILD: childArr2,
                                     WSRequestParams.WS_REQS_PARAM_NO_OF_CHILD_AGE: childAges]
        
        WebService.callApi(api: .getHotelListNew, param: params,encoding: JSONEncoding.default) { status, msg, responseValue in
            LoaderClass.shared.stopAnimation()
            if status == true{
                let responseData = responseValue as? [String:Any] ?? [:]
                if let response = responseData[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [[String: Any]] {
                    if let noOfHotels = responseData["no_of_hotels"] as? Int {
                        self.hotelCount = noOfHotels
                    }
                    if let markup = responseData[WSResponseParams.WS_RESP_PARAM_MARKUP] as? [[String: Any]] {
                        if let results = Mapper<Results>().mapArray(JSONArray: response) as [Results]?, let markupArr = Mapper<Markup>().mapArray(JSONArray: markup) as [Markup]? {
                            if results[0].hotels.count > 0 {
                                if let vc = ViewControllerHelper.getViewController(ofType: .HotelListVC, StoryboardName: .Hotels) as? HotelListVC{
                                    vc.hotelData = hotelData
                                    vc.days = LoaderClass.shared.calculateDaysBetweenDates(dateString1: txtCheckIn, dateString2: txtCheckOut) ?? 0
                                    vc.results = results
                                    vc.markups = markupArr
                                    vc.hotelCount = "\(self.hotelCount)" //"\(results.reduce(0) {$0 + $1.numberOfHotels })"
                                    vc.logId = responseData[WSResponseParams.WS_RESP_PARAM_LOGID] as? Int ?? 0
                                    vc.checkInDate = txtCheckIn.convertCheckinDate()
                                    vc.checkIn = txtCheckIn
                                    vc.checkOut = txtCheckOut
                                    vc.cityCodeStr = cityCodeStr
                                    vc.finalRooms = finalRooms
                                    vc.numberOfRooms = numberOfRooms
                                    vc.numberOfAdults = numberOfAdults
                                    vc.ageOfChildren = ageOfChildren
                                    vc.totalRequest = results[0].totalRequests
                                    vc.cityName = cityName
                                    view.pushView(vc: vc)
                                }
                                self.delegate?.onSuccess()
                            } else {
                                view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: results[0].error[0].messages[0])
                            }
                        }
                    }
                } else {
                    view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: "No availability for the requested search criteria")
                }
                
            }else{
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    LoaderClass.shared.stopAnimation()
                    view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
}
