//
//  TripViewModel.swift
//  LeaveCasa
//
//  Created by acme on 07/10/22.
//

import Foundation
import ObjectMapper

class TripViewModel{
    
    var delegate : ResponseProtocol?
    var hotels = [Hotels]()
    var tripModel : TripModel?
    
    func callBookingList(view: UIViewController) {
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .bookingList,method: .get, param: [:],header: true) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            if status == true {
                if let data = response as? [String:Any] {
                    let responseModel = Mapper<TripModel>().map(JSON: data)
                    self.tripModel = responseModel
                }
                self.delegate?.onSuccess()
            }
            else {
                self.delegate?.onFail?(msg: msg)
                view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
            }
        }
    }
    
    func callCancelHotelBooking(bookingId: String, view:UIViewController) {
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .cancelHotelBooking(bookingId), method: .get, param: [:], header: true) { status, msg, response in
            if status == true {
                view.pushNoInterConnection(view: view,image: "Hotel", titleMsg: "Cancellation Status", msg: "Booking has been cancelled successfully. Refund process has been initiated") {
                    self.callBookingList(view: view)
                }
            } else {
                LoaderClass.shared.stopAnimation()
                self.delegate?.onFail?(msg: msg)
                view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
            }
        }
    }
    
    func callCancelBusBooking(_ params: [String: Any], view:UIViewController) {
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .cancelBusBooking, method: .post, param: params, header: true) { status, msg, response in
            if status == true {
                view.pushNoInterConnection(view: view,image: "Bus", titleMsg: "Cancellation Status", msg: "Ticket has been cancelled successfully. Refund process has been initiated") {
                    self.callBookingList(view: view)
                }
            } else {
                LoaderClass.shared.stopAnimation()
                self.delegate?.onFail?(msg: msg)
                view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
            }
        }
    }
    
    func callCancelFlightBooking(_ params: [String: Any], view:UIViewController) {
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .cancelFlightBooking, method: .post, param: params, header: true) { status, msg, response in
            if status == true {
                view.pushNoInterConnection(view: view,image: "Airplane", titleMsg: "Cancellation Status", msg: "Ticket has been cancelled successfully. Refund process has been initiated") {
                    self.callBookingList(view: view)
                }
            } else {
                LoaderClass.shared.stopAnimation()
                self.delegate?.onFail?(msg: msg)
                view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
            }
        }
    }
    func callCancelFlightTicket(_ params: [String: Any], view:UIViewController) {
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .cancelFlightTicket, method: .post, param: params, header: true) { status, msg, response in
            if status == true {
                LoaderClass.shared.stopAnimation()
                view.pushNoInterConnection(view: view,image: "Airplane", titleMsg: "Cancellation Alert!", msg: msg) {
                    self.delegate?.onSuccess()
                }
            } else {
                LoaderClass.shared.stopAnimation()
                view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
            }
        }
    }
}
