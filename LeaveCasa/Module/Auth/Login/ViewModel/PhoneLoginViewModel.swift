//
//  PhoneLoginViewModel.swift
//  LeaveCasa
//
//  Created by acme on 13/09/22.
//

import Foundation
import UIKit

class PhoneLoginViewModel{
    
    func loginWithPhone(param:[String:Any],view:UIViewController, api: Api){
        WebService.callApi(api: api, param: param){ status, msg,response in
            LoaderClass.shared.stopAnimation()
            if status == true {
                view.pushNoInterConnection(view: view, titleMsg: "", msg: "OTP sent successfully!")
                if let data = response as? [String:Any] {
                    if let vc = ViewControllerHelper.getViewController(ofType: .OtpVC, StoryboardName: .Main) as? OtpVC {
                        vc.otpVerify = data["otp"] as? Int ?? 0
                        vc.phoneNumber = param[CommonParam.MOBILE_NUMBER] as? String ?? ""
                        vc.countryCode = param[CommonParam.COUNTY_CODE] as? String ?? ""
                        vc.email = param["email"] as? String ?? ""
                        view.pushView(vc: vc)
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
