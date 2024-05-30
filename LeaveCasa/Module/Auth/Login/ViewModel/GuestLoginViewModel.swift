//
//  GuestLoginViewModel.swift
//  LeaveCasa
//
//  Created by acme on 05/01/24.
//

import UIKit
import ObjectMapper

class GuestLoginViewModel: NSObject {
    
    var delegate : ResponseProtocol?
    var hotelDetail: TripHotel?
    var busDetail: TripBus?
    var flightDetail: TripFlightBooking?
    var insurance: InsuranceBookingResponse?
    
    func guestBookingDetail(type: String, bookingId: String, view: UIViewController) {
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .guestUserBookingDetail(type, bookingId),method: .get, param: [:]) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            if status == true {
                let response = response as? [String:Any] ?? [:]
                if type == "Bus" {
                    if let data = response[WSResponseParams.WS_REPS_PARAM_DATA] as? TripBus {
                        self.busDetail = data
                    }
                } else if type == "Hotel" {
                    if let data = response[WSResponseParams.WS_REPS_PARAM_DATA] as? TripHotel {
                        self.hotelDetail = data
                    }
                } else if type == "Flight" {
                    if let data = response[WSResponseParams.WS_REPS_PARAM_DATA] as? [String:Any],
                        let bookingDetail = data["flight"] as? [String:Any] {
                        self.flightDetail = TripFlightBooking(JSON: bookingDetail)
                    }
                } else {
                    if let data = response[WSResponseParams.WS_REPS_PARAM_DATA] as? [String:Any],
                        let bookingDetail = data["insurance"] as? [String:Any] {
                        self.insurance = InsuranceBookingResponse(JSON: bookingDetail)
                    }
                }
                self.delegate?.onSuccess()
            } else {
                view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg)
            }
        }
    }
}
