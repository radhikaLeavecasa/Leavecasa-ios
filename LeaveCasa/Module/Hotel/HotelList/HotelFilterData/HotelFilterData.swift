//
//  HotelFilterData.swift
//  LeaveCasa
//
//  Created by acme on 29/09/22.
//

import Foundation

class HotelFilterData {
    
    static let share = HotelFilterData()

    private init(){}

    var refundable = String()
    var isBreakfast = String()
    var rate = [Int]()
    var price = Double()
    var price2 = Double()
    var propertyType = [String]()
    var amenities = [String]()
    var isReset = Bool()
    var propertyType1 = [String]()
    var aminityType = [HotelFilter]()
    
    func filterData(data:[String:Any]) -> [String:Any] {
        return data
    }
}
