//
//  HotelDetailsViewModel.swift
//  LeaveCasa
//
//  Created by acme on 15/09/22.
//

import Foundation
import ObjectMapper
import Alamofire

class HotelDetailsViewModel{
    //MARK: - Variables
    var imageData = [[String:Any]]()
    var delegate : ResponseProtocol?
    var hotelDetails = HotelDetail()
    var searchID = ""
    var checkIN = ""
    var checkOut = ""
    var no_of_adults = 0
    var no_of_nights = 0
    var no_of_rooms = 0
    //MARK: - Custom methods
    func fatchImages(code:String,view:UIViewController){
        WebService.callApi(api: .hotelImages(code),method: .get, param: [:]) { status, msg, responseData in
            //            LoaderClass.shared.stopAnimation()
            if status == true{
                let response = responseData as? [String:Any] ?? [:]
                if let results = response[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [String: AnyObject] {
                    if let regular = results[WSResponseParams.WS_RESP_PARAM_REGULAR] as? [[String: AnyObject]] {
                        self.imageData = regular
                    }
                }
                self.delegate?.onSuccess()
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
    
    func fatchHotelDetails(param:[String:Any],view:UIViewController){
        WebService.callApi(api: .hotelDetail, param: param) { Status, msg, responseData in
            LoaderClass.shared.stopAnimation()
            if Status == true{
                let response = responseData as? [String:Any] ?? [:]
                if let response = response[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [String: Any] {
                    self.checkIN = response[WSRequestParams.WS_REQS_PARAM_CHECKIN] as? String ?? ""
                    self.checkOut = response[WSRequestParams.WS_REQS_PARAM_CHECKOUT] as? String ?? ""
                    self.no_of_rooms = response[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_ROOMS] as? Int ?? 0
                    self.no_of_adults = response[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_ADULT] as? Int ?? 0
                    self.no_of_nights = response[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_NIGHT] as? Int ?? 0
                    if let hotelCount = response[WSResponseParams.WS_RESP_PARAM_HOTEL] as? [String: Any] {
                        
                        if let hotels = Mapper<HotelDetail>().map(JSON: hotelCount) as HotelDetail? {
                            self.hotelDetails = hotels
                            self.searchID = response[WSResponseParams.WS_RESP_PARAM_SEARCH_ID] as? String ?? ""
                        }
                    }
                }
                self.delegate?.onSuccess()
            }else{
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    LoaderClass.shared.stopAnimation()
                    view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg) {
                        self.delegate?.onFail?(msg: msg)
                    }
                }
            }
        }
    }
    
    func checkHotelavAilablity(param:[String:Any],view:UIViewController){
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .checkHotelAvailablity, param: param,encoding: JSONEncoding.default) { Status, msg, responseData in
            if Status == true {
                let response = responseData as? [String:Any] ?? [:]
                let result = response[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [String:Any] ?? [:]
                print(result[WSResponseParams.WS_RESP_PARAM_SEARCH_ID] as? String ?? "")
                var param = param
                param[WSResponseParams.WS_RESP_PARAM_SEARCH_ID] = result[WSResponseParams.WS_RESP_PARAM_SEARCH_ID] as? String ?? ""
                LoaderClass.shared.loadAnimation()
                self.fatchHotelDetails(param: param,view:view)
            }else{
                LoaderClass.shared.stopAnimation()
                self.delegate?.onFail?(msg: msg)
            }
        }
    }
}
