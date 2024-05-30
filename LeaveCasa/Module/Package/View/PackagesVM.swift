//
//  PackagesVM.swift
//  LeaveCasa
//
//  Created by acme on 04/04/24.
//

import UIKit
import Alamofire
import ObjectMapper

class PackagesVM: NSObject {
    //MARK: - Variables
    var arrPackages = [PackagesDetailModel]()
    // var delegate : ResponseProtocol?
    var destination = String()
    func searchByDestinationApi(param:[String:Any],view:UIViewController) {
        WebService.callApi(api: .searchByDestination, method: .post ,param: param, encoding: JSONEncoding.default,header: true) { status, msg, response in
            debugPrint(msg)
            debugPrint(response)
            LoaderClass.shared.stopAnimation()
            
            if status == true{
                if let data = response as? [String:Any] {
                    if let packages = data["data"] as? [[String:Any]] {
                        if let arr = Mapper<PackagesDetailModel>().mapArray(JSONArray: packages) as [PackagesDetailModel]? {
                            self.arrPackages = arr
                        }
                        if self.arrPackages.count > 0 {
                            if let vc = ViewControllerHelper.getViewController(ofType: .SearchedPackageListsVC, StoryboardName: .Main) as? SearchedPackageListsVC {
                                vc.arrPackages = self.arrPackages
                                vc.destination = self.destination
                                view.pushView(vc: vc)
                            }
                        } else {
                            view.pushNoInterConnection(view: view,titleMsg: "Oops!", msg: "No Result found for your required search. Please send your enquiry for custom Package.\nOur team will reach you out soon.") {
                                if let vc = ViewControllerHelper.getViewController(ofType: .RequestCallBackVC, StoryboardName: .Main) as? RequestCallBackVC {
                                    vc.destination = self.destination
                                    view.pushView(vc: vc)
                                }
                            }
                        }
                    }
                }
            } else {
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
}

