//
//  HomeModel.swift
//  LeaveCasa
//
//  Created by acme on 14/09/22.
//

import Foundation
import ObjectMapper

class Results: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        error <- map[WSResponseParams.WS_RESP_PARAM_ERRORS]
        hotels <- map[WSResponseParams.WS_RESP_PARAM_HOTELS]
        numberOfHotels <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_HOTELS]
        sNoOfRooms <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_ROOMS]
        sNoOfAdults <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_ADULT]
        sNoOfChildren <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_CHILDREN]
        sNoOfNights <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_NIGHT]
        searchId <- map[WSResponseParams.WS_RESP_PARAM_SEARCH_ID]
        totalRequests <- map[WSResponseParams.WS_RESP_PARAM_TOTAL_NUM_OF_REQUEST]
        checkout <- map[WSRequestParams.WS_REQS_PARAM_CHECKOUT]
        checkin <- map[WSRequestParams.WS_REQS_PARAM_CHECKIN]
        request <- map[WSRequestParams.WS_REQS_PARAM_REQUEST]
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        return Int(value!)
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    lazy var error = [Errors]()
    lazy var hotels = [Hotels]()
    lazy var numberOfHotels = Int()
    lazy var sNoOfRooms = Int()
    lazy var sNoOfAdults = Int()
    lazy var sNoOfChildren = Int()
    lazy var sNoOfNights = Int()
    lazy var searchId = String()
    lazy var totalRequests = String()
    lazy var checkout = String()
    lazy var checkin = String()
    lazy var request = [String:Any]()
}

class Hotels: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sName <- map[WSRequestParams.WS_REQS_PARAM_NAME]
        sAddress <- map[WSResponseParams.WS_RESP_PARAM_ADDRESS]
        sCityCode <- map[WSResponseParams.WS_RESP_PARAM_CITY_CODE]
        sCountry <- map[WSResponseParams.WS_RESP_PARAM_COUNTRY]
        sDescription <- map[WSResponseParams.WS_RESP_PARAM_DESCRIPTION]
        sFacilities <- map[WSResponseParams.WS_RESP_PARAM_FACILITIES]
        sHotelCode <- map[WSResponseParams.WS_RESP_PARAM_HOTEL_CODE]
        sImages <- map[WSResponseParams.WS_RESP_PARAM_IMAGES]
        iCategory <- map[WSResponseParams.WS_RESP_PARAM_CATEGORY]
        iMinRateObj <- map[WSResponseParams.WS_RESP_PARAM_MIN_RATE]
        iMinRate <- map[WSResponseParams.WS_RESP_PARAM_MIN_RATE]
        searchId <- map[WSResponseParams.WS_RESP_PARAM_SEARCH_ID]
        sNoOfNights <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_NIGHT]
        
        if let imagesUrl = sImages[WSResponseParams.WS_RESP_PARAM_URL] as? String {
            sImageUrl = imagesUrl
        }
        
    }
    
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        return Int(value!)
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    
    lazy var sName = String()
    lazy var sAddress = String()
    lazy var sCityCode = String()
    lazy var sCountry = String()
    lazy var sDescription = String()
    lazy var sFacilities = String()
    lazy var sHotelCode = String()
    lazy var sImages = [String: AnyObject]()
    lazy var sImageUrl = String()
    lazy var iMinRateObj = [String: AnyObject]()
    lazy var iMinRate = HotelRate()
    lazy var iCategory = Double()
    lazy var searchId = String()
    lazy var sNoOfNights = Int()
}


class HotelDetail: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sName <- map[WSRequestParams.WS_REQS_PARAM_NAME]
        sAddress <- map[WSResponseParams.WS_RESP_PARAM_ADDRESS]
        sCityCode <- map[WSResponseParams.WS_RESP_PARAM_CITY_CODE]
        sCountry <- map[WSResponseParams.WS_RESP_PARAM_COUNTRY]
        sDescription <- map[WSResponseParams.WS_RESP_PARAM_DESCRIPTION]
        sFacilities <- map[WSResponseParams.WS_RESP_PARAM_FACILITIES]
        sHotelCode <- map[WSResponseParams.WS_RESP_PARAM_HOTEL_CODE]
        iCategory <- map[WSResponseParams.WS_RESP_PARAM_CATEGORY]
        sImages <- map[WSResponseParams.WS_RESP_PARAM_IMAGES]
        sRate <- map[WSResponseParams.WS_RESP_PARAM_RATE]
        
        if let imagesUrl = sImages[WSResponseParams.WS_RESP_PARAM_URL] as? String {
            sImageUrl = imagesUrl
        }
        var ratesArray = [[String: AnyObject]]()
        ratesArray <- map[WSResponseParams.WS_RESP_PARAM_RATES]
        
        if let results = Mapper<HotelRate>().mapArray(JSONArray: ratesArray) as [HotelRate]? {
            rates = results
        }
        
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        return Int(value!)
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    
    lazy var sName = String()
    lazy var sAddress = String()
    lazy var sCityCode = String()
    lazy var sCountry = String()
    lazy var sDescription = String()
    lazy var sFacilities = String()
    lazy var sHotelCode = String()
    lazy var sRate = HotelRate()
    lazy var rates = [HotelRate]()
    lazy var iCategory = Double()
    lazy var sImages = [String: AnyObject]()
    lazy var sImageUrl = String()
}


class HotelRate: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sMealplan <- map["mealplan"]
        aAllotment <- map[WSResponseParams.WS_RESP_PARAM_ALLOTMENT]
        sAvailabiltyStatus <- map[WSResponseParams.WS_RESP_PARAM_AVAILABLITY_STATUS]
        sGroupCode <- map[WSResponseParams.WS_RESP_PARAM_GROUP_CODE]
        sRateKey <- map[WSResponseParams.WS_RESP_PARAM_RATE_KEY]
        sRateType <- map[WSResponseParams.WS_RESP_PARAM_RATE_TYPE]
        sNonRefundable <- map[WSResponseParams.WS_RESP_PARAM_NON_REFUNDABLE]
        sRoomCode <- map[WSResponseParams.WS_RESP_PARAM_ROOM_CODE]
        sPrice <- map[WSResponseParams.WS_RESP_PARAM_PRICE]
        sRateComments <- map["rate_comments"]
        sSupportsCancellation <- map[WSResponseParams.WS_RESP_PARAM_SUPPORTS_CANCELLATION]
        
        var roomsArray = [[String: AnyObject]]()
        roomsArray <- map[WSRequestParams.WS_REQS_PARAM_ROOMS]
        
        if let results = Mapper<HotelRoom>().mapArray(JSONArray: roomsArray) as [HotelRoom]? {
            sRooms = results
            print("This is room\(results)")
        }
        
        sBoardingDetails <- map[WSResponseParams.WS_RESP_PARAM_BOARDING_DETAIL]
        sCancellationPolicy <- map[WSResponseParams.WS_RESP_PARAM_CANCELLATION_POLICY]
        sPaymentTypes <- map[WSResponseParams.WS_RESP_PARAM_PAYMENT_TYPE]
        sOtherInclusions <- map[WSResponseParams.WS_RESP_PARAM_OTHER_INCLUSIONS]
        sPriceDetails <- map[WSResponseParams.WS_RESP_PARAM_PRICE_DETAILS]
        
        if let net = sPriceDetails[WSResponseParams.WS_RESP_PARAM_NET] as? [[String: AnyObject]] {
            if net.count > 0{
                let amount = net[0]
                self.sBasePrice = amount[WSResponseParams.WS_RESP_PARAM_AMOUNT] as? Double ?? 0.0
                let serviceFee = net[1]
                self.sServiceFee = serviceFee[WSResponseParams.WS_RESP_PARAM_AMOUNT] as? Double ?? 0.0
            }
            for i in net {
                if let name = i[WSRequestParams.WS_REQS_PARAM_NAME] as? String, let amount = i[WSResponseParams.WS_RESP_PARAM_AMOUNT] as? Double, name.lowercased().contains("total") {
                    sNetPrice = amount
                    print("net price \(amount)")
                }
            }
        }
        if let gst = sPriceDetails[WSResponseParams.WS_RESP_PARAM_GST] as? [[String: AnyObject]] {
            for i in gst {
                if let name = i[WSRequestParams.WS_REQS_PARAM_NAME] as? String, let amount = i[WSResponseParams.WS_RESP_PARAM_AMOUNT] as? Double, name.lowercased().contains("total") {
                    sGSTPrice = amount
                    print("gst price \(amount)")
                }
            }
        }
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        return Int(value!)
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    
    lazy var aAllotment = String()
    lazy var sAvailabiltyStatus = String()
    lazy var sBoardingDetails = [String]()
    lazy var sGroupCode = String()
    lazy var sNonRefundable = Bool()
    lazy var sPrice = Double()
    lazy var sMealplan = String()
    lazy var sPriceDetails = [String:AnyObject]()
    lazy var sRateComments = HotelRate()
    lazy var sNetPrice = Double()
    lazy var sGSTPrice = Double()
    lazy var sPaymentTypes = [String]()
    lazy var sOtherInclusions = [String]()
    lazy var sRateKey = String()
    lazy var sRateType = String()
    lazy var sRooms = [HotelRoom]()
    lazy var sRoomCode = String()
    lazy var sSupportsCancellation = Bool()
    lazy var sCancellationPolicy = [String: AnyObject]()
    lazy var sBasePrice = Double()
    lazy var sServiceFee = Double()
    
}

class CancellationPolicy: Mappable, CustomStringConvertible {
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        
        details <- map["details"]
        currency <- map["currency"]
        flatFee <- map["flat_fee"]
    }
    lazy var details = [CancellationPolicy]()
    lazy var currency = String()
    lazy var flatFee = String()
}
class HotelRoom: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sChildrenAges <- map[WSRequestParams.WS_REQS_PARAM_CHILDREN_AGES]
        sNoOfRooms <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_ROOMS]
        sNoOfAdults <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_ADULT]
        sNoOfChildren <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_CHILDREN]
        sDescription <- map[WSResponseParams.WS_RESP_PARAM_DESCRIPTION]
        sRoomType <- map[WSResponseParams.WS_RESP_PARAM_ROOM_TYPE]
        sRoomRef  <- map[WSResponseParams.WS_RESP_PARAM_ROOM_REF]
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        return Int(value!)
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    
    lazy var sChildrenAges = [String]()
    lazy var sNoOfRooms = Int()
    lazy var sNoOfAdults = Int()
    lazy var sNoOfChildren = Int()
    lazy var sDescription = String()
    lazy var sRoomType = String()
    lazy var sRoomRef = String()
    
}

class Markup: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        status <- map[WSResponseParams.WS_RESP_PARAM_STATUS]
        airline <- map[WSResponseParams.WS_RESP_PARAM_AIRLINESMALL]
        amount <- map[WSResponseParams.WS_RESP_PARAM_AMOUNT]
        amountBy <- map[WSResponseParams.WS_RESP_PARAM_AMOUNT_BY]
        starRating <- map[WSResponseParams.WS_RESP_PARAM_STAR_RATTING]
        amountOrPercent <- map[WSResponseParams.WS_RESP_PARAM_AMOUNT_OR_PERCENT]
        
        
        if amount.isZero && !amountOrPercent.isZero {
            amount = amountOrPercent
        }
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        return Int(value!)
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    
    lazy var amount = Double()
    lazy var amountBy = String()
    lazy var airline = String()
    lazy var status = Bool()
    lazy var starRating = Double()
    lazy var amountOrPercent = Double()
    
}


class Errors: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        code <- map[WSResponseParams.WS_RESP_PARAM_CODE]
        messages <- map[WSResponseParams.WS_RESP_PARAM_MESSAGES]
        
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        return Int(value!)
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    
    lazy var code = String()
    lazy var messages = [String]()
}
