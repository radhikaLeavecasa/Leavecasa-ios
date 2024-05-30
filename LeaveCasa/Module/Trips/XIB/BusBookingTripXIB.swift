//
//  BusBookingTripXIB.swift
//  LeaveCasa
//
//  Created by acme on 02/02/23.
//

import UIKit
import IBAnimatable

class BusBookingTripXIB: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var cnstCancelHeight: NSLayoutConstraint!
    @IBOutlet weak var lblBoarding: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBus: UIImageView!
    @IBOutlet weak var btnCancel: AnimatableButton!
    //MARK: - Variables
    let identifire = "BusBookingTripXIB"
}
