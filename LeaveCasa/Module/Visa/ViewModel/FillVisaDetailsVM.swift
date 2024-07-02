//
//  FillVisaDetailsVM.swift
//  LeaveCasa
//
//  Created by acme on 27/06/24.
//

import UIKit

class FillVisaDetailsVM: NSObject {
    
    
    func applyVisaApi(param:[String:Any], paramImg:[String:UIImage], paramUrl:[String:URL], view:UIViewController) {
        LoaderClass.shared.stopAnimation()
        WebService.uploadFilesWithURL(api: .visaApplication, images: paramImg, urls: paramUrl, parameters: param) { status, msg, response in
            if status == true {
                    if let traceId = response["trace_id"] as? String {
                        view.pushNoInterConnection(view: view, image: "ic_success", titleMsg: "Visa Application Submitted!",  msg: "Dear Applicant,\nYour Token no.:- \(traceId)\nCongratulation!\nYour application has been successfully submitted. Track your visa status from My Bookings", completion: {
                            if let vc = ViewControllerHelper.getViewController(ofType: .TabbarVC, StoryboardName: .Main) as? TabbarVC {
                                vc.Index = UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false ? 1 : 2
                                view.setView(vc: vc, animation: false)
                            }
                        })
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
