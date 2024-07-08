//
//  AllVisaListingVM.swift
//  LeaveCasa
//
//  Created by acme on 05/07/24.
//

import UIKit
import ObjectMapper

class AllVisaListingVM: NSObject {
    var arrVisa: [VisaDetailModel]?
    var termsData: String?
    var delegate: ResponseProtocol?
    
    func getNewVisaList(view:UIViewController) {
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .allNewVisaList, method: .get, param: [:],header: true) { status, msg, response in
            
            LoaderClass.shared.stopAnimation()
            self.arrVisa?.removeAll()
            if status == true {
                if let responseValue = response as? [String: Any] {
                    if let data = responseValue["data"] as? [[String: Any]] {
                        if let list = Mapper<VisaDetailModel>().mapArray(JSONArray: data) as [VisaDetailModel]? {
                            self.arrVisa = list
                            self.delegate?.onSuccess()
                        }
                    }
                    self.termsData = (responseValue["terms_and_condition"] as? String ?? "").htmlToString
                }
            } else {
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    view.pushNoInterConnection(view: view,titleMsg: "Alert!", msg: msg)
                }
            }
        }
    }
}
