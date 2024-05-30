//
//  FlightBookingTripXIB.swift
//  LeaveCasa
//
//  Created by acme on 02/02/23.
//

import UIKit
import IBAnimatable

class FlightBookingTripXIB: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var btnCancel: AnimatableButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var imgHotel: UIImageView!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    //MARK: - Variables
    let identifire = "FlightBookingTripXIB"
}
