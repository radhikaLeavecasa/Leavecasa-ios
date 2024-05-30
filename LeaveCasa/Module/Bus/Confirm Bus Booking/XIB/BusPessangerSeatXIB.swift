//
//  BusPessangerSeatXIB.swift
//  LeaveCasa
//
//  Created by acme on 18/10/22.
//

import UIKit
import IBAnimatable

class BusPessangerSeatXIB: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var btnTap: UIButton!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var lblSeatNo: UILabel!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtFldPhoneNumber: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldIDType: UITextField!
    @IBOutlet weak var txtFldIDNumber: UITextField!
    @IBOutlet weak var vwPhoneNumber: UIView!
    @IBOutlet weak var vwEmail: UIView!
    //MARK: - Variables
    let identifire = "BusPessangerSeatXIB"
    var selectedLineColor : UIColor = UIColor.darkGray
    var lineColor : UIColor = UIColor.darkGray
    let border = CALayer()
    var lineHeight : CGFloat = CGFloat(1.0)
}
