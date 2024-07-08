//
//  VisaTypeCVC.swift
//  LeaveCasa
//
//  Created by acme on 08/07/24.
//

import UIKit
import IBAnimatable

class VisaTypeCVC: UICollectionViewCell {
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblVisaValidity: UILabel!
    @IBOutlet weak var lblStayPeriod: UILabel!
    @IBOutlet weak var lblProcessTime: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var imgVwVisaCountry: AnimatableImageView!
}
