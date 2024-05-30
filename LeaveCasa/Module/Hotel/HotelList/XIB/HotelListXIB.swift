//
//  HotelListXIB.swift
//  LeaveCasa
//
//  Created by acme on 09/09/22.
//

import UIKit
import IBAnimatable

class HotelListXIB: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var imgVwTick3: UIImageView!
    @IBOutlet weak var imgVwTick2: UIImageView!
    @IBOutlet weak var imgVwTick1: UIImageView!
    @IBOutlet weak var lblBreakfastIncluded: UILabel!
    @IBOutlet weak var lblNonRefundable: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblHotelAddress: UILabel!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var imgHotel: AnimatableImageView!
    @IBOutlet weak var lblPointThree: UILabel!
    @IBOutlet weak var rateBackView: AnimatableView!
    //MARK: - Variables
    var identifire = "HotelListXIB"
}
