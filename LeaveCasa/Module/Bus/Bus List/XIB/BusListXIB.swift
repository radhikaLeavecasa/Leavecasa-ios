//
//  BusListXIB.swift
//  LeaveCasa
//
//  Created by acme on 26/09/22.
//

import UIKit
import IBAnimatable

class BusListXIB: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var imgPrimo: UIImageView!
    @IBOutlet weak var rateBackVIew: AnimatableView!
    @IBOutlet weak var lblSeats: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblBusName: UILabel!
    @IBOutlet weak var lblBusCondition: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
}
