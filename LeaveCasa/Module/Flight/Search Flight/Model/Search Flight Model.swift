//
//  Search Flight Model.swift
//  LeaveCasa
//
//  Created by acme on 02/11/22.
//

import Foundation
import ObjectMapper

struct FlightStruct {
    var source = ""
    var destination = ""
    var sourceCode = ""
    var destinationCode = ""
    var from = ""
    var to = ""
    var fromDate = Date()
    var toDate = Date()
    var flightClassIndex = 0
    var flightClass = ""
    var passengers = 1
}

struct PassangerDetails{
    var title = ""
    var firstName = ""
    var lastName = ""
    var gender = ""
    var dob = ""
    var email = ""
    var countryMobileCode = ""
    var countryCode = ""
    var mobile = ""
    var address = ""
    var country = ""
    var state = ""
    var city = ""
    var isGST = Bool()
    var gstNumber = ""
    var passportNumber = ""
    var passportIssueDate = ""
    var passportExpDate = ""
    var gstCompanyName = ""
    var gstCompanyEmail = ""
    var gstAddress = ""
    var gstCompanyContactNumber = ""
    var meal = ""
    var saveUser = Bool()
    var baggage = ""
    var paxType = ""
    var baggageAndMealPrice = Double()
    var mealData = [String:Any]()
    var baggageData = [String:Any]()
    var seatData = [String:Any]()
    var lccMealData : MealDynamic? = nil
    var nonLccMealData : Meal? = nil
    var lccBaggageData : Baggage? = nil
    var nonLccBaggageData : BaggageNonLCC? = nil
    var lccSeatData : SeatDynamic? = nil
    var seatPrefrance : SeatsPreference?
    var ffAirline = ""
    var ffNumber = ""
    var nationality = ""
}

struct BusPassangerDetails{
    var title = ""
    var name = ""
    var isMale = Bool()
    var email = ""
    var mobile = ""
    var idNumber = ""
    var idType = ""
    var age = ""
}

struct HotelRoomDetail {
    var adults = 1
    var children = 0
    var childOne = 0
    var childTwo = 0
    var rooms = 1
}

class Flight: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        var segments: [AnyObject]?
        
        segments <- map[WSResponseParams.WS_RESP_PARAM_SEGMENTS]
        sFare <- map[WSResponseParams.WS_RESP_PARAM_FARE.capitalized]
        sResultIndex <- map[WSResponseParams.WS_RESP_PARAM_RESULTS_INDEX]
        sAirlineCode <- map[WSResponseParams.WS_RESP_PARAM_AIRLINE_CODE]
        sAirlineRemark <- map[WSResponseParams.WS_RESP_PARAM_AIRPORT_REMARK]
        sIsPanRequiredAtBook <- map[WSResponseParams.WS_RESP_PARAM_IS_PAN_REQ_AT_BOOK]
        sIsPanRequiredAtTicket <- map[WSResponseParams.WS_RESP_PARAM_IS_PAN_REQ_AT_TICKET]
        sIsPassportRequiredAtBook <- map[WSResponseParams.WS_RESP_PARAM_IS_PASSPORT_REQ_AT_BOOK]
        sIsPassportRequiredAtTicket <- map[WSResponseParams.WS_RESP_PARAM_IS_PASSPORT_REQ_AT_TICKET]
        sIsLCC <- map[WSResponseParams.WS_RESP_PARAM_ISLCC]
        sIsGSTMandatory <- map[WSResponseParams.WS_RESP_PARAM_IS_GST_MANDATORY]
        sGSTAllowed <- map[WSResponseParams.WS_RESP_PARAM_GST_ALLOWED]
        sFareClassification <- map[WSResponseParams.WS_RESP_PARAM_FARE_CLASSFICATIONS]
        sIsRefundable <- map[WSResponseParams.WS_RESP_PARAM_IS_REFUNDABLE]
        sIsCouponAppilcable <- map[WSResponseParams.WS_RESP_PARAM_IS_COUPON_APPILCABLE]
        sMiniFareRules <- map[WSResponseParams.WS_RESP_PARAM_MINIFARERULES]
        
        var allFlightSegments = [[FlightSegment]] ()
        
        if let segments = segments {
            var segmentsArray = [[String: AnyObject]]()
            
            for result in segments  {
                if let seg = result as? [[String: AnyObject]] {
                    segmentsArray = seg
                    
                } else if let seg = result as? [String: AnyObject] {
                    segmentsArray = [seg]
                    
                }
                
                if let results = Mapper<FlightSegment>().mapArray(JSONArray: segmentsArray) as [FlightSegment]? {
                    allFlightSegments.append(results)
                }
            }
            sSegments = allFlightSegments
            
        }
        
        if let fare = sFare as? FlightFare {
            sPrice = fare.sPublishedFare
        }
        
        
        
        var fareRules : AnyObject?
        
        fareRules <- map[WSResponseParams.WS_RESP_PARAM_FARES_RULES_CAP]
        if let fareRules = fareRules as? [[String:AnyObject]] {
            
            var rules = ""
            
            for fareRule in fareRules {
                if let fareRuleDetails = fareRule[WSResponseParams.WS_RESP_PARAM_FARES_RULE_DETAIL] as? String {
                    rules += fareRuleDetails
                }
            }
            
            sFareRules = rules
            
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
    
    lazy var sSegments = [[FlightSegment]]()
    lazy var sFare = FlightFare()
    lazy var sResultIndex = String()
    lazy var sFareClassification = [String:Any]()
    lazy var sIsRefundable = Bool()
    lazy var sIsCouponAppilcable = Bool()
    lazy var sMiniFareRules = [[MiniFareRulesModel]]()
    //    lazy var sSource = String()
    //    lazy var sDestination = String()
    //    lazy var sSourceCode = String()
    //    lazy var sDestinationCode = String()
    //    lazy var sStartTime = String()
    //    lazy var sEndTime = String()
    //    lazy var sDuration = Int()
    //    lazy var sAccDuration = Int()
    lazy var sPrice = Double()
    //    lazy var sCurrency = Int()
    //    lazy var sType = [String: AnyObject]()
    //    lazy var sStopsCount = Int()
    //    lazy var sStops = [FlightAirport]()
    //    lazy var sAirlineNo = Int()
        lazy var sAirlineName = String()
    //    lazy var sAirlineLogo = String()
    //    lazy var sAdditional = String()
    lazy var sIsPassportRequiredAtBook = Int()
    lazy var sIsPassportRequiredAtTicket = Bool()
    lazy var sIsPanRequiredAtTicket = Bool()
    lazy var sIsPanRequiredAtBook = Bool()
    lazy var sIsLCC = Bool()
    lazy var sIsGSTMandatory = Bool()
    lazy var sGSTAllowed = Bool()
    lazy var sAirlineCode = String()
    lazy var sAirlineRemark = String()
    lazy var sFareRules = String()
    
}

class FlightSegment: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        var origin = [String: AnyObject]()
        var destination = [String: AnyObject]()
        
        origin <- map[WSResponseParams.WS_RESP_PARAM_ORIGIN]
        destination <- map[WSResponseParams.WS_RESP_PARAM_DESTINATION]
        
        if let originAirport = origin[WSResponseParams.WS_RESP_PARAM_AIRPORT] as? [String: AnyObject], let airport = Mapper<FlightAirport>().map(JSON: originAirport) {
            sOriginAirport = airport
        }
        
        if let originDepartTime = origin[WSResponseParams.WS_RESP_PARAM_DEP_TIME] as? String {
            sOriginDeptTime = originDepartTime
        }
        
        if let desAirport = destination[WSResponseParams.WS_RESP_PARAM_AIRPORT] as? [String: AnyObject], let airport = Mapper<FlightAirport>().map(JSON: desAirport) {
            sDestinationAirport = airport
        }
        
        if let desArrTime = destination[WSResponseParams.WS_RESP_PARAM_ARR_TIME] as? String {
            sDestinationArrvTime = desArrTime
        }
        
        sAirline <- map[WSResponseParams.WS_RESP_PARAM_AIRLINE]
        sDuration <- map[WSResponseParams.WS_RESP_PARAM_DURATION]
        sAccDuration <- map[WSResponseParams.WS_RESP_PARAM_DURATION_ACCUM]
        sGroundTime <- map["GroundTime"]
        sNumberOfSeats <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_SEATS]
        sCabinClass <- map[WSResponseParams.WS_RESP_PARAM_CABIN_CLASS]
        
        sBaggage <- map[WSResponseParams.WS_RESP_PARAM_BAGGAGE]
        sCraft <- map["Craft"]
        sCabinBaggage <- map[WSResponseParams.WS_RESP_PARAM_CABIN_BAGGAGE]
        sNoOfSeatAvailable <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_SEATS]
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
    
    lazy var sAirline = FlightAirline()
    lazy var sOriginAirport = FlightAirport()
    lazy var sDestinationAirport = FlightAirport()
    lazy var sOriginDeptTime = String()
    lazy var sDestinationArrvTime = String()
    lazy var sDuration = Int()
    lazy var sAccDuration = Int()
    lazy var sGroundTime = Int()
    lazy var sNumberOfSeats = Int()
    lazy var sCabinClass = Int()
    lazy var sBaggage = String()
    lazy var sCraft = String()
    lazy var sCabinBaggage = String()
    lazy var sNoOfSeatAvailable = Int()
}

class FlightAirline: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sAirlineName <- map[WSResponseParams.WS_RESP_PARAM_AIRLINE_NAME]
        sAirlineCode <- map[WSResponseParams.WS_RESP_PARAM_AIRLINE_CODE]
        sAirlineRemark <- map[WSResponseParams.WS_RESP_PARAM_AIRPORT_REMARK]
        sFlightNumber <- map[WSResponseParams.WS_RESP_PARAM_FLIGHT_NO]
        sFareClass <- map[WSResponseParams.WS_RESP_PARAM_FARE_CLASS]
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
    
    lazy var sAirlineCode = String()
    lazy var sAirlineName = String()
    lazy var sFlightNumber = String()
    lazy var sAirlineRemark = String()
    lazy var sFareClass = String()
}


class FlightAirport: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sAirportName <- map[WSResponseParams.WS_RESP_PARAM_AIRPORT_NAME]
        sAirportCode <- map[WSResponseParams.WS_RESP_PARAM_AIRPORT_CODE]
        sCityCode <- map[WSResponseParams.WS_RESP_PARAM_CITYCODE_CAP]
        sCityName <- map[WSResponseParams.WS_RESP_PARAM_CITYNAME_CAP]
        sCountryName <- map[WSResponseParams.WS_RESP_PARAM_COUNTRYNAME_CAP]
        sCountryCode <- map[WSResponseParams.WS_RESP_PARAM_COUNTRYCODE_CAP]
        sTerminal <- map[WSResponseParams.WS_RESP_PARAM_TERMINAL]
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
    
    lazy var sAirportCode = String()
    lazy var sAirportName = String()
    lazy var sCityCode = String()
    lazy var sCityName = String()
    lazy var sCountryCode = String()
    lazy var sCountryName = String()
    lazy var sTerminal = String()
}
class FlightFare: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sCurrency <- map[WSResponseParams.WS_RESP_PARAM_CURRENCY]
        sBaseFare <- map[WSResponseParams.WS_RESP_PARAM_BASE_FARE]
        sTax <- map[WSResponseParams.WS_RESP_PARAM_TAX]
        sPublishedFare <- map[WSResponseParams.WS_RESP_PUBLISHED_FARE]
        sYQTax <- map[WSResponseParams.WS_RESP_PARAM_YQTAX]
        sAdditionalTxnFeePub <- map[WSResponseParams.WS_RESP_PARAM_ADDITIONAL_TXN_FEE_PUB]
        sAdditionalTxnFeeOfrd <- map[WSResponseParams.WS_RESP_PARAM_ADDITIONAL_TXN_FEE_RD]
        sServiceFee <- map[WSResponseParams.WS_RESP_PARAM_SERVICE_FEE]
        sDiscount <- map[WSResponseParams.WS_RESP_PARAM_DISCOUNT]
        sOtherCharges <- map[WSResponseParams.WS_RESP_PARAM_OTHER_CHARGES]
        sOfferedFare <- map[WSResponseParams.WS_RESP_PARAM_OFFERED_FARE]
        sTdsOnPLB <- map[WSResponseParams.WS_RESP_PARAM_TDS_ON_PLB]
        sTdsOnCommission <- map[WSResponseParams.WS_RESP_PARAM_TDS_ON_COMMISSION]
        sTdsOnIncentive <- map[WSResponseParams.WS_RESP_PARAM_TDS_ON_INCENTIVE]
        sTaxBreakup <- map[WSResponseParams.WS_RESP_PARAM_TAX_BREAKUP]
        
        sTotalSeatCharges <- map[WSResponseParams.WS_RESP_PARAM_TOTAL_SEAT_CHARGE]
        sTotalMealCharges <- map[WSResponseParams.WS_RESP_PARAM_TOTAL_MEAL_CHARGE]
        
        var anyObject : AnyObject?
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_BASE_FARE]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sBaseFare = value
        }
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_TAX]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sTax = value
        }
        anyObject <- map[WSResponseParams.WS_RESP_PUBLISHED_FARE]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sPublishedFare = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_YQTAX]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sYQTax = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_ADDITIONAL_TXN_FEE_PUB]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sAdditionalTxnFeePub = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_ADDITIONAL_TXN_FEE_RD]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sAdditionalTxnFeeOfrd = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_DISCOUNT]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sDiscount = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_OTHER_CHARGES]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sOtherCharges = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_OFFERED_FARE]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sOfferedFare = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_TDS_ON_INCENTIVE]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sTdsOnIncentive = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_TDS_ON_COMMISSION]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sTdsOnCommission = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_TDS_ON_PLB]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sTdsOnPLB = value
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
    
    lazy var sCurrency = String()
    lazy var sBaseFare = Double()
    lazy var sTax = Double()
    lazy var sPublishedFare = Double()
    lazy var sYQTax = Double()
    lazy var sAdditionalTxnFeePub = Double()
    lazy var sAdditionalTxnFeeOfrd = Double()
    lazy var sOtherCharges = Double()
    lazy var sDiscount = Double()
    lazy var sOfferedFare = Double()
    lazy var sTdsOnCommission = Double()
    lazy var sTdsOnPLB = Double()
    lazy var sTdsOnIncentive = Double()
    lazy var sServiceFee = Double()
    lazy var sTotalSeatCharges = String()
    lazy var sTotalMealCharges = String()
    lazy var sTaxBreakup = [TaxModel]()

}
class MiniFareRulesModel: Mappable,CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sDetails <- map[WSResponseParams.WS_RESP_PARAM_DETAILS_CAP]
        sFrom <- map[WSResponseParams.WS_RESP_PARAM_FROM_CAP]
        sJourneyPoints <- map[WSResponseParams.WS_RESP_PARAM_JOURNEYPOINTS]
        sTo <- map[WSResponseParams.WS_RESP_PARAM_TO]
        sType <- map[CommonParam.TYPE_CP]
        sUnit <- map[WSResponseParams.WS_RESP_PARAM_UNIT]
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
    
    lazy var sDetails = String()
    lazy var sFrom = String()
    lazy var sJourneyPoints = String()
    lazy var sTo = String()
    lazy var sType = String()
    lazy var sUnit = String()
}
class TaxModel: Mappable,CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sKey <- map["key"]
        sValue <- map["value"]
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
    
    lazy var sKey = String()
    lazy var sValue = Double()
}
