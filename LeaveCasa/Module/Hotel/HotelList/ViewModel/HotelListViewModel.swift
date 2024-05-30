//
//  HotelListViewModel.swift
//  LeaveCasa
//
//  Created by acme on 14/09/22.
//

import Foundation
import ObjectMapper
import Alamofire

class HotelListViewModel {
 
   // var delegate : HotelListData?
    var hotelCount = ""
    
//    var propertyType = [String]()
//    var aminityType = [HotelFilter]()
    
    func fetchHotels(cityCodeStr: String, txtCheckIn: String, txtCheckOut: String, finalRooms: [[String: AnyObject]], numberOfRooms: Int, numberOfAdults: Int, ageOfChildren: [Int], rate: Int, price: Double, amenities: [Int] = [] ,propertyType: [String] = [],view: UIViewController, refundable: String = "", breakfast: String = "") {
        
        var params: [String: Any] = [WSRequestParams.WS_REQS_PARAM_CURRENT_REQUEST: 0 ,
                                     WSRequestParams.WS_REQS_PARAM_DESTINATION_CODE: cityCodeStr,
                                     WSRequestParams.WS_REQS_PARAM_CHECKIN: txtCheckIn ,
                                     WSRequestParams.WS_REQS_PARAM_CHECKOUT: txtCheckOut ,
                                     WSRequestParams.WS_REQS_PARAM_ROOMS: finalRooms
        ]
        if amenities.count > 0 {
            params[CommonParam.AMENITIES] = amenities
        }
        if propertyType.count > 0 {
            params[CommonParam.PROPERTY_TYPE] = propertyType
        }
        
        WebService.callApi(api: .hotelSearch, param: params,encoding: JSONEncoding.default) { status, msg, responseData in
            LoaderClass.shared.stopAnimation()
            
            if status == true {
                let responseValue = responseData as? [String:Any] ?? [:]
                if let response = responseValue[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [[String: Any]] {
                    if let markup = responseValue[WSResponseParams.WS_RESP_PARAM_MARKUP] as? [[String: Any]] {
                        if let results = Mapper<Results>().mapArray(JSONArray: response) as [Results]?, let markupArr = Mapper<Markup>().mapArray(JSONArray: markup) as [Markup]? {
                            let count = results.reduce(0) {$0 + $1.numberOfHotels}
                            let newCount = (Int(self.hotelCount) ?? 0) + count
                            self.hotelCount = "\(newCount)"
                        }
                    }
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
    
    func fatchPropertyType(param:[String:Any],view:UIViewController){
        WebService.callApi(api: .getPropertyType, method: .post,param: param,encoding: JSONEncoding.default) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            HotelFilterData.share.propertyType1.removeAll()
            HotelFilterData.share.aminityType.removeAll()
            if status == true{
                print(response)
                let response = response as? [String:Any] ?? [:]
                if let property_types = response[CommonParam.PROPERTY_TYPE] as? [[String:Any]]{
                    for index in property_types{
                        let name = index[CommonParam.NAME] as? String ?? ""
                        HotelFilterData.share.propertyType1.append(name)
                    }
                }
                if let amenities = response[CommonParam.AMENITIES] as? [[String:Any]]{
                    for index in amenities{
                        let model = HotelFilter.init(response: index)
                        HotelFilterData.share.aminityType.append(model)
                    }
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
