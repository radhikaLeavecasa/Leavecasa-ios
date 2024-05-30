//
//  PassangerDetailsViewModel.swift
//  LeaveCasa
//
//  Created by acme on 26/12/22.
//

import Foundation
import Alamofire
import ObjectMapper
import SearchTextField

class PassangerDetailsViewModel{
    //MARK: - Variables
    var passangerList : PassangerList?
    var arrState = [CityState]()
    var arrCity = [String]()
    var delegate : ResponseProtocol?
    
    func flightBook(param:[String:Any], view:UIViewController, flightData:Flight, token:String, traceID:String, logID:Int, amount:Double,ssrModel:SsrFlightModel){
                  WebService.callApi(api: .flightBookNonLCC, param: param,encoding: JSONEncoding.default) { status, msg, response in
           
            debugPrint(response)
            LoaderClass.shared.stopAnimation()
            if status == true{
                let response = response as? [String:Any] ?? [:]
                if let data = response[WSResponseParams.WS_REPS_PARAM_DATA] as? [String:Any]{
                    if let response = data[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:Any]{
                        if let response = response[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:Any]{
                            if let BookingId = response[WSResponseParams.WS_RESP_PARAM_BOOKING_ID] as? Int,
                               let pnr = response[WSResponseParams.WS_RESP_PARAM_PNR] as? String{
                                
                                if pnr == "" {
                                    Alert.showSimple("Payment issue from flight. Your payment will be refunded.") {
                                        if let vc = ViewControllerHelper.getViewController(ofType: .TabbarVC, StoryboardName: .Main) as? TabbarVC {
                                            vc.Index = 2
                                            view.pushView(vc: vc)
                                        }
                                    }
                                } else {
                                    self.delegate?.onFlightReload!()
                                }
                            }
                        }
                    }
                }
            }else{
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
    
    func getPassangerList(view: UIViewController) {
        WebService.callApi(api: .passangerList, method: .get, param: [:], header: true) { status, msg, response in
            debugPrint(msg)
            debugPrint(response)
            LoaderClass.shared.stopAnimation()
            if status == true {
                let response = response as? [String:Any] ?? [:]
                if let results = Mapper<PassangerList>().map(JSON: response) as PassangerList? {
                    self.passangerList = results
                }
            }
            else {
                if msg == CommonError.INTERNET {
                    view.pushNoInterConnection(view: view)
                } else {
                    if msg == "Something went wrong, Try again" {
                        
                    } else {
                        view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
                    }
                }
            }
        }
    }
    
    func savePassangerList(param:[String:Any],view:UIViewController) {
        WebService.callApi(api: .savePassanger,method: .post ,param: param,encoding: JSONEncoding.default,header: true) { status, msg, response in
            debugPrint(msg)
            debugPrint(response)
            LoaderClass.shared.stopAnimation()
            
            if status == true{
                view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
            }else{
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
    
    func searchStateApi(_ sender: String, view:UIViewController){
       
        WebService.callApi(api: .getStates(sender),method: .get ,param: [:]) { status, msg, response in
            debugPrint(response)
            
            LoaderClass.shared.stopAnimation()
            if status == true {
                self.arrState.removeAll()
                
                let response = response as? [String:Any] ?? [:]
                let responseModel = Mapper<CityState>().map(JSON: response)
                self.arrState = responseModel?.data ?? []
                
            }else{
                LoaderClass.shared.stopAnimation()
                if msg.contains("URL is not valid") {
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: AlertMessages.ENTER_VALID_LOCATION)
                } else {
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
    
    func searchCityApi(_ sender: String, view:UIViewController) {
        
        WebService.callApi(api: .getCities(sender),method: .get ,param: [:]) { status, msg, response in
            debugPrint(response)
            
            LoaderClass.shared.stopAnimation()
            if status == true{
                self.arrCity.removeAll()
                
                let response = response as? [String:Any] ?? [:]
                let codes = response["data"] as? [[String:Any]] ?? []
                
                for i in 0..<codes.count {
                    let dict = codes[i]
                    self.arrCity.append(dict[WSResponseParams.WS_RESP_PARAM_LOCALFULLNAME] as? String ?? dict[WSResponseParams.WS_RESP_PARAM_LOCALNAME] as? String ?? "")
                }
            }else{
                LoaderClass.shared.stopAnimation()
                if msg.contains("URL is not valid") {
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: AlertMessages.ENTER_VALID_LOCATION)
                } else {
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
}
