//
//  HomeHeaderNewXIB.swift
//  LeaveCasa
//
//  Created by acme on 08/09/22.
//

import UIKit

class HomeHeaderNewXIB: UITableViewHeaderFooterView {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var btnFlightAndInternational: UIButton!
    @IBOutlet weak var vwAllTwo: UIButton!
    @IBOutlet weak var constViewAllOneWidth: NSLayoutConstraint!
    @IBOutlet weak var vwAllOne: UIButton!
    @IBOutlet weak var vwstack: UIStackView!
    @IBOutlet weak var vwThree: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var constLeadingStackVw: NSLayoutConstraint!
    @IBOutlet weak var lblAllAndDomestic: UILabel!
    @IBOutlet weak var btnAllAndDomestic: UIButton!
    @IBOutlet weak var lblFlightAndInternational: UILabel!
    @IBOutlet weak var lblBus: UILabel!
    @IBOutlet weak var actionBus: UIButton!
    @IBOutlet weak var actionHotels: UIButton!
    @IBOutlet weak var vwFour: UIView!
    @IBOutlet weak var lblHotels: UILabel!
    //MARK: - Variables
    var identifire = "HomeHeaderNewXIB"
}
