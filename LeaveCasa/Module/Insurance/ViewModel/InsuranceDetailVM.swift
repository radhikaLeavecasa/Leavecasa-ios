//
//  InsuranceDetailVM.swift
//  LeaveCasa
//
//  Created by acme on 20/05/24.
//

import UIKit
import Alamofire
import ObjectMapper

class InsuranceDetailVM: NSObject {
    var insuranceDetailModel: ItineraryModel?
    var delegate : ResponseProtocol?
 
    func cancelInsurance(param:[String:Any],view:UIViewController) {
        
        WebService.callApi(api: .cancelInsurance, method: .post ,param: param,encoding: JSONEncoding.default, header: true) { status, msg, response in
            if status == true {
                if let responseValue = response as? [String: Any] {
                    if responseValue["data"] is [String: Any] {
                        LoaderClass.shared.stopAnimation()
                        view.pushNoInterConnection(view: view, image: "ic_success", titleMsg: "Cancellation Alert!", msg: "Insurance Cancelled Successfully!") {
                            self.delegate?.onSuccess()
                        }
                    }
                }
            }else{
                LoaderClass.shared.stopAnimation()
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    view.pushNoInterConnection(view: view,titleMsg: "Alert!", msg: msg)
                }
            }
        }
    }
}
