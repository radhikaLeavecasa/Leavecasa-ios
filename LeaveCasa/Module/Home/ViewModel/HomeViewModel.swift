//
//  HomeViewModel.swift
//  LeaveCasa
//
//  Created by acme on 14/09/22.
//

import ObjectMapper
import UIKit

class HomeViewModel {
    //MARK: - Variables
    var modelData = [Results]()
    var markups = [Markup]()
    var logId = 0
    var delegate : ResponseProtocol?
    var couponData: [CouponData]?
    var arrDomestic: [CityDetailModel]?
    var arrInternational: [CityDetailModel]?
    
    var arrPackageDomestic: [PackagesDetailModel]?
    var arrPackageInternational: [PackagesDetailModel]?
    var mainUrl: String?
    
    func callHomeCoupons(view: UIViewController) {
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .homeCoupon, method: .get, param: [:], header: true) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            if status == true {
                if let data = response as? [String:Any] {
                    let responseModel = data["coupon_data"] as? [[String:Any]]
                    if let data = Mapper<CouponData>().mapArray(JSONArray: responseModel ?? []) as [CouponData]? {
                        self.couponData = data
                    }
                    self.delegate?.onSuccess()
                    if let data = data["promotions"] as? [String:Any] {
                        if let domesticArr = data["domestic"] as? [[String:Any]] {
                            if let arr = Mapper<CityDetailModel>().mapArray(JSONArray: domesticArr) as [CityDetailModel]? {
                                self.arrDomestic = arr
                            }
                        }
                        if let arr = data["international"] as? [[String:Any]] {
                            if let arr = Mapper<CityDetailModel>().mapArray(JSONArray: arr) as [CityDetailModel]? {
                                self.arrInternational = arr
                            }
                        }
                        self.delegate?.onSuccess()
                    }
                    
                    if let packages = data["packages"] as? [String:Any] {
                        if let packagesImgUrl = packages["main_url"] as? String {
                            self.mainUrl = packagesImgUrl
                        }
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
    
    func getHomeData(city:String, type:String, lat:String, long:String, view:UIViewController){
        let param = [WSResponseParams.WS_RESP_PARAM_CITY.lowercased():city,CommonParam.TYPE:type,CommonParam.LAT:lat,CommonParam.LONG:long]

        WebService.callApi(api: .recommended, param: param, header: true){ status,msg,responseData in
            LoaderClass.shared.stopAnimation()
            print(responseData)
            if status == true{
                let response = responseData as? [String:Any] ?? [:]
                if let hotelData = response[WSResponseParams.WS_RESP_PARAM_HOTEL] as? [String:Any]{
                    
                    if let hotel = hotelData[WSResponseParams.WS_RESP_PARAM_HOTEL] as? [[String:Any]]{
                        if let markup = hotelData[WSResponseParams.WS_RESP_PARAM_MARKUP] as? [[String: Any]] {
                            if let results = Mapper<Results>().mapArray(JSONArray: hotel) as [Results]?, let markupArr = Mapper<Markup>().mapArray(JSONArray: markup) as [Markup]? {
                                self.modelData = results
                                self.markups = markupArr
                                self.logId = hotelData[WSResponseParams.WS_RESP_PARAM_LOGID] as? Int ?? 0
                            }
                        }
                        
                        if let markup = hotelData[WSResponseParams.WS_RESP_PARAM_MARKUP] as? [[String: Any]] {
                            if  let markupArr = Mapper<Markup>().mapArray(JSONArray: markup) as [Markup]? {
                                self.markups = markupArr
                                self.logId = hotelData[WSResponseParams.WS_RESP_PARAM_LOGID] as? Int ?? 0
                            }
                        }
                    }
                }
                self.delegate?.onSuccess()
            }else{
                if msg == CommonError.INTERNET{
                    let vc = ViewControllerHelper.getViewController(ofType: .NoInternetVC, StoryboardName: .Main) as? NoInternetVC
//                    vc?.noInternetDelegate = { val in
                        self.delegate?.apiReload!()
//                    }
                    view.present(vc!,animated: true)
                }else{
                    LoaderClass.shared.stopAnimation()
                    view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
    
    func updateDeviceToken() {
        let param = [CommonParam.DEVICE_TOKEN: Cookies.getDeviceToken(),
                     CommonParam.DEVICE_TYPE: "0",
                     CommonParam.DEVICE_ID: "\(UIDevice.current.identifierForVendor?.uuidString ?? "")"]
        WebService.callApi(api: .updateDeviceToken, param: param, header:
                            true) { status,msg,responseData in
            print(status)
        }
    }
}

