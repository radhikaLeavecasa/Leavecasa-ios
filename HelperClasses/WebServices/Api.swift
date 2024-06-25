//
//  Api.swift
//  Josh
//
//  Created by Esfera-Macmini on 12/04/22.
//

import Foundation

struct RazorpayKeys {
    static let Test = "rzp_test_Qrm4UPEWl3YvrG"
    static let Live = "rzp_live_ySXcuStrpX1gVF"
} 

let baseUrl = "https://demo.leavecasa.com/api" //"https://leavecasa.com/api"

extension Api {
    func baseURl() -> String {
        return baseUrl + self.rawValued()
    }
}

enum Api: Equatable {
    
    case sendOtp
    case sendEmailOtp
    case verifyOtp
    case emailVerifyOtp
    case checkHotelAvailablity
    case notification
    case getStates(String)
    case getCities(String)
    case homeCoupon
    case updateNotification
    case updateProfile
    case profilePic
    case updateDeviceToken

    // MARK: HOTEL
    case hotelCoupons
    case citySearch(String)
    case hotelSearch
    case hotelDetail
    case hotelImages(String)
    case getPropertyType
    case hotelFinalBooking
    case recommended

    // MARK: FLIGHT
    case airportCityCode(String)
    case flightSearch
    case calenderFare
    case flightFareDetails
    case flightTicketLCC
    case flightBookNonLCC
    case flightTicketNonLCC
    case passangerList
    case savePassanger
    case flightCoupon
    case flightFarerule
    case cancelFlightTicket
    // MARK: BUS
    case busCoupons
    case busSourceSearch(String)
    case busDestinationSearch(Int)
    case busSearch
    case busSeatLayout
    case busTicketBlock
    case busTicketFinal
    
    // MARK: WALLET
    case checkWalletBalance
    case walletTransection
    case creditWalletBalance
    case debitWalletBalance
    
    //MARK: TRIP
    case bookingList
    case cancelHotelBooking(String)
    case cancelBusBooking
    case cancelFlightBooking
    case guestUserBookingDetail(String,String)
    case logout
    
    //MARK: PACKAGE
    case requestCallBack
    case packagesAllList
    case searchByDestination
    case searchCities
    
    //MARK: HOTEL TBO NEW APIS
    case getAllHotelCitiesList
    case getHotelListNew
    
    //MARK: VISA
    case getVisaCountries
    case getCountryDetail(String)
    
    //MARK: Check New Version
    case newVersion(String)
    //MARK: Insurance
    case insuranceSearch
    case getCountryList
    case insuranceBook
    case getInsuranceDetail
    case cancelInsurance
    
    func rawValued() -> String {
        switch self {
        case let .getCountryDetail(country):
            return "/visa/getDetails/\(country)"
        case .cancelInsurance:
            return "/insurance/SendChangeRequest"
        case .getInsuranceDetail:
            return "/insurance/GetBookingDetails"
        case .getHotelListNew:
            return "/searchhotelbycityCode"
        case .getCountryList:
            return "/get-countries"
        case .insuranceBook:
            return "/insurance/book"
        case .searchCities:
            return "/allDestinations"
        case .searchByDestination:
            return "/packageSearchbydestination"
        case .requestCallBack:
            return "/savePackage"
        case .packagesAllList:
            return "/packages/all"
        case let .guestUserBookingDetail(type, bookingId):
            return "/\(type)/get-invoice/\(bookingId)"
        case .recommended :
            return "/home-details"
        case .emailVerifyOtp:
            return "/verify-email-otp"
        case .sendOtp:
            return "/send-otp"
        case .sendEmailOtp:
            return "/send-email-otp"
        case .verifyOtp:
            return "/verify-otp"
        case .hotelCoupons:
            return "/allCoupon/hotel"
        case .homeCoupon:
            return "/allCoupon/home"
        case .flightCoupon:
            return "/allCoupon/flight"
        case .hotelSearch:
            return "/search/hotel"
        case .citySearch(let search):
            return "/hotel-city-search/\(search)"
        case.hotelImages(let image):
            return "/hotel_images/\(image)"
        case .hotelDetail:
            return "/hotel_detail"
        case .busSourceSearch(let city):
            return "/bus/cities/\(city)"
        case .busDestinationSearch(let cityCode):
            return "/bus/destination/\(cityCode)"
        case .checkHotelAvailablity:
            return "/hotel/check-availablity"
        case .checkWalletBalance:
            return "/wallet-balance"
        case .hotelFinalBooking:
            return "/hotel/final-book"
        case .getPropertyType:
            return "/hotel/get-amenities-property-types"
        case .updateProfile:
            return "/update-profile"
        case .profilePic:
            return "/profile-image"
        case .walletTransection:
            return "/wallet-detail"
        case .bookingList:
            return "/customer_booking_detail"
        case .cancelHotelBooking(let bookingId):
            return "/hotel-booking-cancellation/\(bookingId)"
        case .cancelBusBooking:
            return "/bus/ticket/cancel"
        case .cancelFlightBooking:
            return "/flight/booking/cancel"
        case .cancelFlightTicket:
            return "/flight/ticket/cancelRequest"
        case .busCoupons:
            return "/allCoupon/bus"
        case .busSearch:
            return "/bus/search"
        case .busSeatLayout:
            return "/bus/seat/layout"
        case .busTicketBlock:
            return "/bus/ticket/block"
        case .busTicketFinal:
            return "/bus/ticket/final"
        case .airportCityCode(let code):
            return "/airport/codes/\(code)"
        case .flightSearch:
            return "/flights/search"
        case .calenderFare:
            return "/flights/calendar-fare"
        case .flightFareDetails:
            return "/flight/fare_rule_quote_ssr"
        case .flightFarerule:
            return "/flight/fare_rule"
        case .flightBookNonLCC:
            return "/flight/non-lcc-book"
        case .flightTicketNonLCC:
            return "/flight/non-lcc-ticket"
        case .flightTicketLCC:
            return "/flight/lcc-ticket"
        case .creditWalletBalance:
            return "/credit-wallet"
        case .debitWalletBalance:
            return "/debit-wallet"
        case .passangerList:
            return "/passenger-list"
        case .savePassanger:
            return "/create-passenger"
        case .notification:
            return "/notification-list"
        case .updateNotification:
            return "/update-notification-setting"
        case .updateDeviceToken:
            return "/update-device-token"
        case .newVersion(let id):
            return "https://itunes.apple.com/lookup?bundleId=\(id)"
        case .getCities(let place):
            return "/get-cities/\(place)"
        case .getStates(let place):
            return "/get-states/\(place)"
        case .logout:
            return "/logout"
        case .insuranceSearch:
            return "/insurance/search"
        case .getAllHotelCitiesList:
            return "/getallcities"
        case .getVisaCountries:
            return "/visa/getCountries"
        }
    }
}

func isSuccess(json : [String : Any]) -> Bool{
    if let isSucess = json["status"] as? Int {
        if isSucess == 200 {
            return true
        }
    }
    if let isSucess = json["status"] as? String {
        if isSucess == "200" {
            return true
        }
    }
    if let isSucess = json["success"] as? String {
        if isSucess == "200" {
            return true
        }
    }
    if let isSucess = json["status"] as? String {
        if isSucess == "success" {
            return true
        }
    }
    if let isSucess = json["success"] as? Int {
        if isSucess == 200 {
            return true
        }
    }
    
    if let isSucess = json["code"] as? Int {
        if isSucess == 200 {
            return true
        }
    }
    
    if let isSucess = json["success"] as? Bool {
        if isSucess == true {
            return true
        }
    }
    
    if let isSucess = json["status"] as? Bool {
        if isSucess == true {
            return true
        }
    }
    return false
}

func isInActivate(json : [String : Any]) -> Bool{
    if let isSucess = json["code"] as? Int {
        if isSucess == 401 {
            return true
        }
    }
    return false
}

func isAlreadyLogin(json : [String : Any]) -> Bool{
    if let isSucess = json["code"] as? Int {
        if isSucess == 403 {
            return true
        }
    }
    return false
}

func isAlreadyAdded(json : [String : Any]) -> Bool{
    if let isSucess = json["status"] as? Int {
        if isSucess == 405 {
            return true
        }
    }
    return false
}

func isDocumentVerificationFalse(json : [String : Any]) -> Bool{
    if let isSucess = json["status"] as? Int {
        if isSucess == 402 {
            return true
        }
    }
    return false
}

func isMobileVarifiedFalse(json : [String : Any]) -> Bool{
    if let isSucess = json["status"] as? Int {
        if isSucess == 402 {
            return true
        }
    }
    return false
}

func message(json : [String : Any]) -> String{
    if let message = json["message"] as? String {
        return message
    }
    if let message = json["message"] as? [String:Any] {
        if let msg = message.values.first as? [String] {
            return msg[0]
        }
    }
    if let error = json["error"] as? String {
        return error
    }
    
    return " "
}

func isBodyCount(json : [[String : Any]]) -> Int{
    return json.count
}
