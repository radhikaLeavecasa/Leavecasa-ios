import Foundation
import ObjectMapper

class CouponViewModel {
    
    var delegate: ResponseProtocol?
    var couponData: [CouponData]?

    func callBusCoupons(view:UIViewController) {
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .busCoupons, method: .get, param: [:], header: true) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            if status == true {
                if let data = response as? [String:Any] {
                    let responseModel = Mapper<CouponModel>().map(JSON: data)
                    if let data = Mapper<CouponData>().mapArray(JSONArray: responseModel?.couponData ?? []) as [CouponData]? {
                        self.couponData = data
                    }
                }
                self.delegate?.onSuccess()
            }
            else {
                self.delegate?.onFail?(msg: msg)
                view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg)
            }
        }
    }
    
    func callHotelCoupons(view: UIViewController) {
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .hotelCoupons, method: .get, param: [:], header: true) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            if status == true {
                if let data = response as? [String:Any] {
                    let responseModel = Mapper<CouponModel>().map(JSON: data)
                    if let data = Mapper<CouponData>().mapArray(JSONArray: responseModel?.couponData ?? []) as [CouponData]? {
                        self.couponData = data
                    }
                }
                self.delegate?.onSuccess()
            }
            else {
                self.delegate?.onFail?(msg: msg)
                view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg)
            }
        }
    }
    func flightCoupons(view: UIViewController) {
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .flightCoupon, method: .get, param: [:], header: true) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            if status == true {
                if let data = response as? [String:Any] {
                    let responseModel = Mapper<CouponModel>().map(JSON: data)
                    if let data = Mapper<CouponData>().mapArray(JSONArray: responseModel?.couponData ?? []) as [CouponData]? {
                        self.couponData = data
                    }
                }
                self.delegate?.onSuccess()
            }
            else {
                self.delegate?.onFail?(msg: msg)
                view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg)
            }
        }
    }
}
