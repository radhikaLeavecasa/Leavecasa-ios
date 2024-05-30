//
//  DiscoverTopPlacesVM.swift
//  LeaveCasa
//
//  Created by acme on 03/04/24.
//

import UIKit
import ObjectMapper

class DiscoverTopPlacesVM: NSObject {
    
    var delegate : ResponseProtocol?
    var arrPackageDomestic: [PackagesDetailModel]?
    var arrPackageInternational: [PackagesDetailModel]?
    
    func callPackagesApi(view: UIViewController) {
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .packagesAllList, method: .get, param: [:], header: true) { status, msg, response in
            if LoaderClass.shared.arrSearchResultAll.count != 0 {
                LoaderClass.shared.stopAnimation()
            }
            if status == true {
                if let data = response as? [String:Any] {
                    if let packages = data["data"] as? [String:Any] {
                        if let packagesDomesticArr = packages["domestic"] as? [[String:Any]] {
                            if let arr = Mapper<PackagesDetailModel>().mapArray(JSONArray: packagesDomesticArr) as [PackagesDetailModel]? {
                                self.arrPackageDomestic = arr
                            }
                        }
                        if let packagesInternationalArr = packages["international"] as? [[String:Any]] {
                            if let arr = Mapper<PackagesDetailModel>().mapArray(JSONArray: packagesInternationalArr) as [PackagesDetailModel]? {
                                self.arrPackageInternational = arr
                            }
                        }
                        self.delegate?.onSuccess()
                    }
                }
            } else {
                self.delegate?.onFail?(msg: msg)
                view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg)
            }
        }
    }
}
