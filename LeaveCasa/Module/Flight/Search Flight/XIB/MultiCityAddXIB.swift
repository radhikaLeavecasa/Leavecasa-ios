//
//  MultiCityAddXIB.swift
//  LeaveCasa
//
//  Created by acme on 02/11/22.
//

import UIKit
import IBAnimatable
import SearchTextField

class MultiCityAddXIB: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var btnClose: AnimatableButton!
    @IBOutlet weak var txtDepartureDate: SearchTextField!
    @IBOutlet weak var txtTo: SearchTextField!
    @IBOutlet weak var txtFrom: SearchTextField!
    @IBOutlet weak var lblToCityCode: UILabel!
    @IBOutlet weak var lblFromCityCode: UILabel!
    @IBOutlet weak var btnAddCity: UIButton!
    //MARK: - Variable
    let identifire = "MultiCityAddXIB"
}
