//
//  FillInsuranceDetailsVM.swift
//  LeaveCasa
//
//  Created by acme on 08/05/24.
//

import UIKit
import Alamofire
import ObjectMapper

class FillInsuranceDetailsVM: NSObject {
    
    var delegate : ResponseProtocol?
    var arrCountries: [CountryModel]?
    var insuranceModel: InsuranceGetDetailModel?
    
    func insuranceBookApi(param:[String:Any],view:UIViewController) {
        WebService.callApi(api: .insuranceBook, method: .post ,param: param,encoding: JSONEncoding.default, header: true) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            if status == true {
                if let responseValue = response as? [String: Any] {
                    if let data = responseValue["data"] as? [String: Any] {
                        if let data2 = data["Response"] as? [String: Any] {
                            self.insuranceModel = InsuranceGetDetailModel(JSON: data2)
                            self.delegate?.onSuccess()
                        }
                    }
                }
            }else{
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    view.pushNoInterConnection(view: view,titleMsg: "Alert!", msg: msg)
                }
            }
        }
    }
    
    func getCountryList(view:UIViewController) {
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .getCountryList, method: .get, param: [:],header: true) { status, msg, response in
            
            LoaderClass.shared.stopAnimation()
            self.arrCountries?.removeAll()
            if status == true {
                if let responseValue = response as? [String: Any] {
                    if let data = responseValue["data"] as? [[String: Any]] {
                        if let list = Mapper<CountryModel>().mapArray(JSONArray: data) as [CountryModel]? {
                            self.arrCountries = list
                        }
                    }
                }
            } else {
                LoaderClass.shared.stopAnimation()
                if msg.contains("URL is not valid") {
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: AlertMessages.ENTER_VALID_LOCATION)
                } else {
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
}
