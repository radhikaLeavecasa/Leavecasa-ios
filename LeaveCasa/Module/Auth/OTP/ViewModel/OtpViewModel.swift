//
//  OtpViewModel.swift
//  LeaveCasa
//
//  Created by acme on 14/09/22.
//

import Foundation
import IBAnimatable

class OtpViewModel{
    
    func otpVerify(param:[String:Any],view:UIViewController, api: Api){
        
        WebService.callApi(api: api, param: param) { Status, msg, responseData in
            LoaderClass.shared.stopAnimation()
            if Status == true{
                let response = responseData as? [String:Any] ?? [:]
                let userData = response[CommonParam.DATA] as? [String:Any] ?? [:]
                Cookies.userInfoSave(dict:userData)
                GetData.share.saveUserToken(token: response[CommonParam.USER_TOKEN] as? String ?? "")
                let vc = ViewControllerHelper.getViewController(ofType: .TabbarVC, StoryboardName: .Main) as! TabbarVC
                vc.showAlert = true
                view.setView(vc: vc)
            } else {
                if msg == CommonError.INTERNET {
                    view.pushNoInterConnection(view: view)
                }else{
                    LoaderClass.shared.stopAnimation()
                    view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
    
    func resendOtp(param:[String:Any],view:UIViewController){
        WebService.callApi(api: .sendOtp, param: param){ status, msg,response in
            LoaderClass.shared.stopAnimation()
            if status == true{
                view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg)
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
