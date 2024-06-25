//
//  VisaDetailsVM.swift
//  LeaveCasa
//
//  Created by acme on 25/06/24.
//

import UIKit
import ObjectMapper

class VisaDetailsVM: NSObject {
    
    var arrCountries = [String]()
    var arrCountryDetails = [VisaDetailModel]()
    var delegate:ResponseProtocol?
    
    func getVisaCountries(_ view:UIViewController) {
        
        WebService.callApi(api: .getVisaCountries, method: .get ,param: [:]) { status, msg, response in
            debugPrint(response)
            
            LoaderClass.shared.stopAnimation()
            if status == true {
                self.arrCountries.removeAll()
                
                let response = response as? [String:Any] ?? [:]
                let codes = response["data"] as? [String] ?? []
                self.arrCountries = codes
                
               
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
    
    func getCountryDetails(_ country: String, view:UIViewController) {
        
        WebService.callApi(api: .getCountryDetail(country), method: .get ,param: [:]) { status, msg, response in
            debugPrint(response)
            
            LoaderClass.shared.stopAnimation()
            if status == true {
                self.arrCountries.removeAll()
                
                let response1 = response as? [String:Any] ?? [:]
                if let visa = response1["data"] as? [[String:Any]] {
                    if let arr = Mapper<VisaDetailModel>().mapArray(JSONArray: visa) as [VisaDetailModel]? {
                        self.arrCountryDetails = arr
                    }
                }
                self.delegate?.onSuccess()
                
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
