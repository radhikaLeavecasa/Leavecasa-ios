//
//  FillVisaDetailsVM.swift
//  LeaveCasa
//
//  Created by acme on 27/06/24.
//

import UIKit

class FillVisaDetailsVM: NSObject {
    
    var delegate:ResponseProtocol?
    
    func applyVisaApi(param:[String:Any],paramImg:[String:UIImage],paramUrl:[String:URL], view:UIViewController){
        LoaderClass.shared.stopAnimation()
        WebService.uploadFilesWithURL(api: .visaApplication, images: paramImg, urls: paramUrl, parameters: param) { status, msg, response in
            if status == true{
                self.delegate?.onSuccess()
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
