//
//  InsuranceSearchVM.swift
//  LeaveCasa
//
//  Created by acme on 06/05/24.
//

import UIKit
import Alamofire
import ObjectMapper

class InsuranceSearchVM: NSObject {
    var insuranceModel: InsuranceModel?
    var delegate : ResponseProtocol?
    
    func insuranceApi(param:[String:Any],view:UIViewController) {
        WebService.callApi(api: .insuranceSearch, method: .post ,param: param,encoding: JSONEncoding.default, header: true) { status, msg, response in
            if status == true {
                if let responseValue = response as? [String: Any] {
                    if let data = responseValue["data"] as? [String: Any] {
                        if let data2 = data["Response"] as? [String: Any] {
                            if let insurance = Mapper<InsuranceModel>().map(JSON: data2) as InsuranceModel? {
                                self.insuranceModel = insurance
                                self.delegate?.onSuccess()
                            }
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
