//
//  RequestCallBackVM.swift
//  LeaveCasa
//
//  Created by acme on 03/04/24.
//

import UIKit
import Alamofire

class RequestCallBackVM: NSObject {
    func requestCallBackApi(param:[String:Any],view:UIViewController) {
        WebService.callApi(api: .requestCallBack, method: .post ,param: param, encoding: JSONEncoding.default,header: true) { status, msg, response in
            debugPrint(msg)
            debugPrint(response)
            LoaderClass.shared.stopAnimation()
            
            if status == true{
                view.pushNoInterConnection(view: view,titleMsg: "Thanks!", msg: msg) {
                    if let vc = ViewControllerHelper.getViewController(ofType: .TabbarVC, StoryboardName: .Main) as? TabbarVC {
                        vc.Index = 2
                        view.setView(vc: vc, animation: false)
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
}
