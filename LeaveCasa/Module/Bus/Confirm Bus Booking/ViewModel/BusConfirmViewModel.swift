//
//  BusConfirmViewModel.swift
//  LeaveCasa
//
//  Created by acme on 19/10/22.
//

import Foundation
import UIKit
import Alamofire

class BusConfirmViewModel{
    
    var markups : Markup?
    var userArray: [String: Any]?
    var paymentArray: [String: Any]?
    
    func callBusSeatBlock(guestDetails: [BusPassangerDetails], sBpId: String, bus: Bus, seats: [BusSeat], view: UIViewController, logID: String, couponCode: String, couponId: Int, gstEmail: String, gstNumber: String, gstCompanyName: String, gstContactNo:String, gstAddress: String, gstIsSelcted: Bool, price: String, mobileNo: String, email: String,couponAmt: Double) {
        
        LoaderClass.shared.loadAnimation()
        
        var bookingItems = [[String: Any]]()
        
        for (index, item) in seats.enumerated() {
            var passenger =  [String:Any]()
            
            let mobile = UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true ? mobileNo : Cookies.userInfo()?.mobile

            passenger[WSRequestParams.WS_REQS_PARAM_MOBILE] = index == 0 ? mobile : ""
            passenger[WSRequestParams.WS_REQS_PARAM_AGE] = guestDetails[index].age as? String ?? ""
            passenger[WSRequestParams.WS_REQS_PARAM_NAME] = guestDetails[index].name as? String ?? ""
            passenger[WSRequestParams.WS_REQS_PARAM_PRIMARY] = index == 0 ? true : false
            
            let inventoryItems: [String: Any] = [
                WSResponseParams.WS_RESP_PARAM_FARE: item.sFare,
                WSResponseParams.WS_RESP_PARAM_LADIES_SEAT: item.sLadiesSeat,
                WSRequestParams.WS_REQS_PARAM_SEAT_NAME: item.sName,
                WSRequestParams.WS_REQS_PARAM_PASSENGER: passenger]
            bookingItems.append(inventoryItems)
            
            userArray = [
                "email": email,
                "phone": mobileNo,
                "name": passenger[WSRequestParams.WS_REQS_PARAM_NAME] ?? ""]
        }
        var baseFare: Double?
        for i in seats {
            baseFare = i.sFare + (baseFare ?? 0.0)
        }
        paymentArray = [
            "base_fare":"\(baseFare ?? 0.0)",
            "coupon_amount": "\(couponAmt)",
            "coupon_id":"\(couponId)",
            "markup": "0",
            "markup_cgst_9" : "0",
            "markup_igst_18" : "0",
            "markup_sgst_9": "0",
            "service_charge": "88.5",
            "service_charge_cgst_9": "6.75",
            "service_charge_igst_18": "13.5",
            "service_charge_sgst_9": "6.75",
            "total_amount": "\(price)"
        ]
        
   
        
        var params: [String: Any] = [
            WSRequestParams.WS_REQS_PARAM_RECIPIENT_EMAIL: email,
            WSRequestParams.WS_REQS_PARAM_RECIPIENT_PHONE: mobileNo,
            WSResponseParams.WS_RESP_PARAM_LOGID: logID,
            WSRequestParams.WS_REQS_PARAM_AVAILABLE_TRIP_ID: bus.sBusId,
            WSRequestParams.WS_REQS_PARAM_BOARDING_POINT_ID: sBpId,
            WSRequestParams.WS_RESP_PARAM_DESTINATION: bus.sDestinationCode,
            WSRequestParams.WS_RESP_PARAM_SOURCE: bus.sSourceCode,
            WSRequestParams.WS_REQS_PARAM_INVENTORY_ITEMS: bookingItems,
        ]
        
        if couponCode != "" && couponId != 0 {
            params[WSRequestParams.WS_REQS_PARAM_COUPON_CODE] = couponCode as AnyObject
            params[WSRequestParams.WS_REQS_PARAM_COUPON_ID] = couponId as AnyObject
        }
        if gstIsSelcted {
            params[WSRequestParams.WS_REQS_PARAM_GST_COMPANY_NAME] = gstCompanyName
            params[WSRequestParams.WS_REQS_PARAM_GST_NUMBER] = gstNumber
            params[WSRequestParams.WS_REQS_PARAM_GST_COMPANY_EMAIL.capitalized] = gstEmail
            params[WSRequestParams.WS_REQS_PARAM_GST_COMPANY_ADDRESS]  = gstAddress
            params[WSRequestParams.WS_REQS_PARAM_GST_COMPANY_CONTACT_NO]  = gstContactNo
        }
        
        debugPrint(params)
        WebService.callApi(api: .busTicketBlock, param: params,encoding: JSONEncoding.default) { status, msg, response in

            LoaderClass.shared.stopAnimation()
            if status == true{
                if let responseValue = response as? [String: Any] {
                    debugPrint(responseValue)
                    if (responseValue[WSResponseParams.WS_RESP_PARAM_STATUS] as? String == WSResponseParams.WS_REPS_PARAM_SUCCESS) {
                        if let response = responseValue[WSResponseParams.WS_RESP_PARAM_BLOCK_KEY] as? String {
                            debugPrint(response)
                            if let vc = ViewControllerHelper.getViewController(ofType: .WalletPaymentVC, StoryboardName: .Main) as? WalletPaymentVC {
                                
                                let params: [String: AnyObject] = [
                                    WSRequestParams.WS_REQS_PARAM_BLOCK_KEY: response as AnyObject,
                                ]
                                vc.viewModel.busPaymentArray = self.paymentArray ?? [:]
                                vc.viewModel.busUserArray = self.userArray ?? [:]
                                vc.busRecepientMail = email
                                vc.busRecepientPhone = mobileNo
                                vc.screenFrom = .bus
                                vc.params = params
                                vc.payblePayment = price
                                vc.amount = Double(price) ?? 0.0
                                //vc.bookingType = Strings.BUS_BOOK
                                vc.logId = Int(logID) ?? 0
                                view.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
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
