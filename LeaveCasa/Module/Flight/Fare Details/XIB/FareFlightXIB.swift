//
//  FareFlightXIB.swift
//  LeaveCasa
//
//  Created by acme on 21/11/22.
//

import UIKit
import IBAnimatable

class FareFlightXIB: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblAircraftType: UILabel!
    @IBOutlet weak var lblTitleCode: UILabel!
    @IBOutlet weak var lblDestinationTerminal: UILabel!
    @IBOutlet weak var lblSourceTerminal: UILabel!
    @IBOutlet weak var lblDestinationCity: UILabel!
    @IBOutlet weak var lblSourceCity: UILabel!
    @IBOutlet weak var imgMultipleFlights: UIImageView!
    @IBOutlet weak var viewPink: UIView!
    @IBOutlet weak var lblFromFlightTime: UILabel!
    @IBOutlet weak var lblFlightFromCode: UILabel!
    @IBOutlet weak var imgFlight: UIImageView!
    @IBOutlet weak var lblFlightName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCabbinBaggage: UILabel!
    @IBOutlet weak var lblCheckinBaggage: UILabel!
    @IBOutlet weak var lblToflightTime: UILabel!
    @IBOutlet weak var lblStops: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var lblToFlightCode: UILabel!
    @IBOutlet weak var lblLayoverTime: UILabel!
    @IBOutlet weak var btnFlight: UIButton!
    //MARK: - Variables
    let identifire = "FareFlightXIB"
}
