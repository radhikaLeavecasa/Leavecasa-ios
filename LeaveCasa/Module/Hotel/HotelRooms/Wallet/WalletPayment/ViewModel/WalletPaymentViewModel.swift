//
//  WalletPaymentViewModel.swift
//  LeaveCasa
//
//  Created by acme on 30/09/22.
//

import Foundation
import Alamofire

class WalletPaymentViewModel{
    
    var delegate : ResponseProtocol?
    var available_balance = 0.0
    var isFetchBalance = false
    //Bus
    var busUserArray = [String:Any]()
    var busPaymentArray = [String:Any]()
    
    func callHotelBookingApi(hotelDetail: HotelDetail, guestDetails:[[String:Any]], room_Ref: String, selectedRoomRate: Int, checkIn: String, checkOut: String, logId: String, searchId: String, couponId: Int, couponCode: String, view: UIViewController, email: String, phoneNumber: String) {
        LoaderClass.shared.loadAnimation()
//        let firstName : AnyObject?
//        let secondName : AnyObject?
//        let email2 : AnyObject?
//        let contactNumber: AnyObject?
//        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false {
//            firstName = (Cookies.userInfo()?.name.components(separatedBy: " ").count ?? 0 > 0 ? Cookies.userInfo()?.name.components(separatedBy: " ")[0] : Cookies.userInfo()?.name ?? "") as AnyObject
//            secondName = (Cookies.userInfo()?.name.components(separatedBy: " ").count ?? 0 > 1 ? Cookies.userInfo()?.name.components(separatedBy: " ")[1] : Cookies.userInfo()?.name ?? "") as AnyObject
//            contactNumber = Cookies.userInfo()?.mobile as AnyObject
//        } else {
//            firstName = guestDetails[0]["name"] as? AnyObject
//            secondName = guestDetails[0]["surname"] as? AnyObject
//            contactNumber = phoneNumber as AnyObject
//        }
        
        let holder: [String: Any] = [
            WSRequestParams.WS_REQS_PARAM_TITLE: guestDetails[0]["title"] ?? "" as AnyObject,
            WSRequestParams.WS_REQS_PARAM_NAME: guestDetails[0]["name"] ?? "" as Any,
            WSRequestParams.WS_REQS_PARAM_SURNAME: guestDetails[0]["surname"] ?? "" as Any,
            WSRequestParams.WS_REQS_PARAM_EMAIL: email,
            WSRequestParams.WS_REQS_PARAM_PHONE_NUMBER: phoneNumber,
            WSResponseParams.WS_RESP_PARAM_CLIENT_NATIONALITY: "IN" as AnyObject, //Cookies.userInfo()?.nationality
            "pan_number" : "AXXXX0000A" as AnyObject // MARK: Static For Now
        ]
        
        let bookingItem: [[String: AnyObject]] = [[
            WSResponseParams.WS_RESP_PARAM_ROOM_CODE: hotelDetail.rates[selectedRoomRate].sRoomCode as AnyObject,
            WSRequestParams.WS_REQS_PARAM_RATE_KEY: hotelDetail.rates[selectedRoomRate].sRateKey as AnyObject,
            
            WSRequestParams.WS_REQS_PARAM_ROOMS: [[
                WSRequestParams.WS_REQS_PARAM_ROOM_REF: room_Ref as AnyObject,
                WSRequestParams.WS_REQS_PARAM_PAXES: guestDetails as AnyObject,
            ]] as AnyObject,
        ]]
        
        var params: [String: AnyObject] = [
            "coupon_code": couponCode as AnyObject,
            "coupon_id": couponId as AnyObject,
            "booking_comments": "live" as AnyObject,
            "recipient_email": email as AnyObject,
            "recipient_phone": phoneNumber as AnyObject,
            WSRequestParams.WS_REQS_PARAM_CUSTOMER_ID: (UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false ? "\(Cookies.userInfo()?.id ?? 0)" : "0") as AnyObject,
            WSResponseParams.WS_RESP_PARAM_LOGID: logId as AnyObject,
            WSRequestParams.WS_REQS_PARAM_SEARCH_ID: searchId as AnyObject,
            WSResponseParams.WS_RESP_PARAM_HOTEL_CODE: hotelDetail.sHotelCode as AnyObject,
            WSResponseParams.WS_RESP_PARAM_CITY_CODE: hotelDetail.sCityCode as AnyObject,
            WSRequestParams.WS_REQS_PARAM_GROUP_CODE: hotelDetail.rates[selectedRoomRate].sGroupCode as AnyObject,
            WSRequestParams.WS_REQS_PARAM_CHECKIN: checkIn as AnyObject,
            WSRequestParams.WS_REQS_PARAM_CHECKOUT: checkOut as AnyObject,
            WSResponseParams.WS_RESP_PARAM_PAYMENT_TYPE: (hotelDetail.rates[selectedRoomRate].sPaymentTypes.first ?? "") as AnyObject,
            WSRequestParams.WS_REQS_PARAM_HOLDER: holder as AnyObject,
            WSRequestParams.WS_REQS_PARAM_BOOKING_ITEMS: bookingItem as AnyObject
        ]
        
        if couponCode != "" && couponId != 0 {
            params[WSRequestParams.WS_REQS_PARAM_COUPON_CODE] = couponCode as AnyObject
            params[WSRequestParams.WS_REQS_PARAM_COUPON_ID] = couponId as AnyObject
        }
        let name = "\(guestDetails[0]["name"] ?? "") \(guestDetails[0]["surname"] ?? "")"
        busUserArray = [
            "email": email,
            "phone": phoneNumber,
            "name": name]
        
        params["user_array"] = busUserArray as AnyObject
        params["payment_array"] = busPaymentArray as AnyObject
        debugPrint(params)
        
        WebService.callApi(api: .hotelFinalBooking, param: params,encoding: JSONEncoding.default,header: true) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            if status == true{
                debugPrint(response)
                let vc = ViewControllerHelper.getViewController(ofType: .BookingConfirmedVC, StoryboardName: .Main) as! BookingConfirmedVC
                vc.title = "hotel"
                vc.doneCompletion = {
                    val in
                    if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
                       // vc.bookingId = "\(BookingId)"
                        vc.type = 3
                        view.pushView(vc: vc,title: "E-ticket")
                    }
                }
//                vc.doneCompletion = {
//                    val in
//                    if let vc = ViewControllerHelper.getViewController(ofType: .TabbarVC, StoryboardName: .Main) as? TabbarVC {
//                        vc.Index = UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true ? 2 : 1
//                        view.pushView(vc: vc)
//                    }
//                }
                view.present(vc, animated: true)
            }else{
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    LoaderClass.shared.stopAnimation()
                    Alert.showSimple(msg) {
                        view.popView()
                    }
                }
            }
        }
    }
    
    func callBusBookingApi(param:[String:Any],view:UIViewController){
        LoaderClass.shared.loadAnimation()
        var param2 = param
        param2["user_array"] = busUserArray
        param2["payment_array"] = busPaymentArray
        WebService.callApi(api: .busTicketFinal, param: param2, encoding: JSONEncoding.default,header: true) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            if status == true {
                debugPrint(response)
                let response = response as? [String:Any] ?? [:]
                if let tin = response["tin"] as? String {
                    let vc = ViewControllerHelper.getViewController(ofType: .BookingConfirmedVC, StoryboardName: .Main) as! BookingConfirmedVC
                    vc.title = "bus"
                    vc.doneCompletion = {
                        val in
                        if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
                            vc.bookingId = "\(tin)"
                            vc.type = 2
                            view.pushView(vc: vc,title: "E-ticket")
                        }
                    }
                    view.present(vc, animated: true)
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
    
    func callNonLccFlightTicketBook(param:[String:Any],view:UIViewController) {
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .flightTicketNonLCC, param: param,encoding: JSONEncoding.default, header: true) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            if status == true{
                debugPrint(response)
                let response = response as? [String:Any] ?? [:]
                if let data = response[WSResponseParams.WS_REPS_PARAM_DATA] as? [String:Any] {
                    if let response = data[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:Any]{
                        if let response = response[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:Any]{
                            if let BookingId = response[WSResponseParams.WS_RESP_PARAM_BOOKING_ID] as? Int {
                                if GetData.share.isReturnTrip() {
                                    if GetData.share.isOnwordBook() == true{
                                        let vc = ViewControllerHelper.getViewController(ofType: .BookingConfirmedVC, StoryboardName: .Main) as! BookingConfirmedVC
                                        vc.title = "flight"
                                        vc.doneCompletion = {
                                            val in
                                            if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
                                                vc.bookingId = "\(BookingId)"
                                                vc.type = 1
                                                view.pushView(vc: vc,title: "E-ticket")
                                            }
                                        }
                                        view.present(vc, animated: true)
                                    }else{
                                        let vc = ViewControllerHelper.getViewController(ofType: .BookingConfirmedVC, StoryboardName: .Main) as! BookingConfirmedVC
                                        vc.title = "flightReturn"
                                        vc.doneCompletion = {
                                            val in
                                            for controller in view.navigationController!.viewControllers as Array {
                                                if controller.isKind(of: SelectFareVC.self) {
                                                    UserDefaults.standard.set(true, forKey: CommonParam.Ownword)
                                                    view.navigationController!.popToViewController(controller, animated: true)
                                                    break
                                                }
                                            }
                                        }
                                        view.present(vc, animated: true)
                                    }
                                }else{
                                    let vc = ViewControllerHelper.getViewController(ofType: .BookingConfirmedVC, StoryboardName: .Main) as! BookingConfirmedVC
                                    vc.title = "flight"
                                    vc.doneCompletion = {
                                        val in
                                        if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
                                            vc.bookingId = "\(BookingId)"
                                            vc.type = 1
                                            view.pushView(vc: vc,title: "E-ticket")
                                        }
                                    }
                                    view.present(vc, animated: true)
                                }
                            }
                        }
                    }
                }
            }else{
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    LoaderClass.shared.stopAnimation()
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: "\(msg) Your amount will be refunded if ticket was not booked. Please contact support team for any other query.") {
                        if let vc = ViewControllerHelper.getViewController(ofType: .TabbarVC, StoryboardName: .Main) as? TabbarVC {
                            vc.Index = 2
                            view.pushView(vc: vc)
                        }
                    }
                }
            }
        }
    }
    
    func callLccFlightTicketBook(param:[String:Any],view:UIViewController){
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .flightTicketLCC, param: param, encoding: JSONEncoding.default,header: true) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            if status == true{
                
                let response = response as? [String:Any] ?? [:]
                if let data = response[WSResponseParams.WS_REPS_PARAM_DATA] as? [String:Any] {
                    if let response = data[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:Any]{
                        if let response = response[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:Any]{
                            if let BookingId = response[WSResponseParams.WS_RESP_PARAM_BOOKING_ID] as? Int {
                                
                                if GetData.share.isReturnTrip() {
                                    if GetData.share.isOnwordBook() == true{
                                        let vc = ViewControllerHelper.getViewController(ofType: .BookingConfirmedVC, StoryboardName: .Main) as! BookingConfirmedVC
                                        vc.title = "flight"
                                        vc.doneCompletion = {
                                            val in
                                            if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
                                                vc.bookingId = "\(BookingId)"
                                                vc.type = 1
                                                view.pushView(vc: vc,title: "E-ticket")
                                            }
                                        }
                                        view.present(vc, animated: true)
                                    }else{
                                        let vc = ViewControllerHelper.getViewController(ofType: .BookingConfirmedVC, StoryboardName: .Main) as! BookingConfirmedVC
                                        vc.title = "flightReturn"
                                        LoaderClass.shared.passengerReturn = param
                                        if let passengers = LoaderClass.shared.passengerReturn["Passengers"] as? [PassangerDetails] {
                                          
                                        }
                                        vc.doneCompletion = {
                                            val in
                                            for controller in view.navigationController!.viewControllers as Array {
                                                if controller.isKind(of: SelectFareVC.self) {
                                                    UserDefaults.standard.set(true, forKey: CommonParam.Ownword)
                                                    view.navigationController!.popToViewController(controller, animated: true)
                                                    break
                                                }
                                            }
                                        }
                                        view.present(vc, animated: true)
                                    }
                                }else{
                                    let vc = ViewControllerHelper.getViewController(ofType: .BookingConfirmedVC, StoryboardName: .Main) as! BookingConfirmedVC
                                    vc.title = "flight"
                                    LoaderClass.shared.passengerReturn = [:]
                                    vc.doneCompletion = {
                                        val in
                                        if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
                                            vc.bookingId = "\(BookingId)"
                                            vc.type = 1
                                            view.pushView(vc: vc,title: "E-ticket")
                                        }
                                    }
                                    view.present(vc, animated: true)
                                }
                            }
                        }
                    }
                }
            }else{
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    LoaderClass.shared.stopAnimation()
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: "\(msg) Your amount will be refunded if ticket was not booked. Please contact support team for any other query.") {
                        if let vc = ViewControllerHelper.getViewController(ofType: .TabbarVC, StoryboardName: .Main) as? TabbarVC {
                            vc.Index = 2
                            view.pushView(vc: vc)
                        }
                    }
                }
            }
        }
    }
}
