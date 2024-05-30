//
//  BaggageTVC.swift
//  LeaveCasa
//
//  Created by acme on 22/02/24.
//

import UIKit
import IBAnimatable

class BaggageTVC: UITableViewCell {

    @IBOutlet weak var imgVwMealBaggage: UIImageView!
    @IBOutlet weak var vwOuter: AnimatableView!
    @IBOutlet var btnInc: UIButton!
    @IBOutlet var btnDec: UIButton!
    @IBOutlet weak var lblQuatity: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPriceWeight: UILabel!
    
}
