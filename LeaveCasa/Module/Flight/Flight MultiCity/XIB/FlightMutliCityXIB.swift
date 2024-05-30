//
//  FlightMutliCityXIB.swift
//  LeaveCasa
//
//  Created by acme on 01/11/22.
//

import UIKit
import IBAnimatable

class FlightMutliCityXIB: UICollectionViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblFromAndTo: UILabel!
    @IBOutlet weak var backView: AnimatableView!
    
    var identifire = "FlightMutliCityXIB"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
