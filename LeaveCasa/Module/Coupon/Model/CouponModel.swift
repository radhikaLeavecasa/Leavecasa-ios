import Foundation
import ObjectMapper

struct CouponModel: Mappable {
    var status: Int?
    var couponData: [[String: Any]]?
    var promotions: Promotions?
    var packages: Promotions?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        status <- map["status"]
        couponData <- map["coupon_data"]
        promotions <- map["promotions"]
        packages <- map["packages"]
        
    }
}

struct CouponData: Mappable {
    var code: String?
    var createdAt: String?
    var deletedAt: String?
    var couponDescription: String?
    var discountAmount: Double?
    var expiresAt: String?
    var couponId: Int?
    var isFixed: Int?
    var maxUses: Int?
    var maxUsesUser: Int?
    var couponName: String?
    var imgUrl : String?
    var startsAt: String?
    var couponType: Int?
    var updatedAt: String?
    var uses: Int?
    var category: String?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        code <- map["code"]
        category <- map["category"]
        createdAt <- map["created_at"]
        deletedAt <- map["deleted_at"]
        couponDescription <- map["description"]
        discountAmount <- map["discount_amount"]
        expiresAt <- map["expires_at"]
        couponId <- map["id"]
        isFixed <- map["is_fixed"]
        imgUrl <- map["image_url"]
        maxUses <- map["max_uses"]
        maxUsesUser <- map["max_uses_user"]
        couponName <- map["name"]
        startsAt <- map["starts_at"]
        couponType <- map["type"]
        updatedAt <- map["updated_at"]
        uses <- map["uses"]
    }
}

struct Promotions: Mappable {
    var domestic: CityDetailModel?
    var international: CityDetailModel?
    
    var domestic1: CityDetailModel?
    var international1: CityDetailModel?
    var mainUrl: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        domestic <- map["domestic"]
        international <- map["international"]
        domestic1 <- map["domestic"]
        international1 <- map["international"]
        mainUrl <- map["main_url"]
    }
}

struct CityDetailModel: Mappable {
    var cityName: String?
    var descrip: String?
    var cityImage: String?
    var code: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        cityName <- map["city_name"]
        descrip <- map["description"]
        cityImage <- map["image"]
    }
}

struct PackagesDetailModel: Mappable {
    var destination: String?
    var inclusion: String?
    var imageUrl: String?
    var imageUrlArr: [String]?
    var packageName: String?
    var termsCondition: String?
    var actualPrice: String?
    var concernPerson: String?
    var country: String?
    var createdAt: String?
    var dmcName: String?
    var id: String?
    var leavecasaPrice: String?
    var packageType: String?
    var services: String?
    var status: String?
    var updatedAt: String?
    var validDate: String?
    var description: String?
    var flight: String?
    var keyHighlights: String?
    var mainReason: String?
    var packageCategory: String?
    var packageDuration: String?
    var packageExclusion: String?
    var packageValidity: String?
    var priceRange: String?
    var travellerCount: String?
    var dayWiseInclusion: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        dayWiseInclusion <- map["day_wise_inclusion"]
        imageUrlArr <- map["image_url"]
        travellerCount <- map["traveller_count"]
        priceRange <- map["price_range"]
        packageValidity <- map["package_validity"]
        packageExclusion <- map["package_exclusion"]
        packageDuration <- map["package_duration"]
        packageCategory <- map["package_category"]
        mainReason <- map["main_reason"]
        keyHighlights <- map["key_highlights"]
        flight <- map["description"]
        description <- map["description"]
        packageName <- map["package_name"]
        destination <- map["destination"]
        inclusion <- map["inclusion"]
        imageUrl <- map["image_url"]
        termsCondition <- map["TermsCondition"]
        actualPrice <- map["actual_price"]
        concernPerson <- map["concern_person"]
        country <- map["country"]
        createdAt <- map["created_at"]
        dmcName <- map["dmc_name"]
        id <- map["id"]
        leavecasaPrice <- map["leavecasa_price"]
        packageType <- map["package_type"]
        services <- map["services"]
        status <- map["status"]
        updatedAt <- map["updated_at"]
        validDate <- map["valid_date"]
        
    }
}
struct CitySearchModel: Mappable {
    var city: String?
    var code: String?
    var country: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        city <- map["city"]
        country <- map["country"]
    }
}


//struct ImgArray : Mappable {
//    var status : Int?
//    var data : [PassangerData]?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        status <- map["status"]
//        data <- map["data"]
//    }
//
//}
