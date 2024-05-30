//
//  InsuranceDetailsTVC.swift
//  LeaveCasa
//
//  Created by acme on 02/05/24.
//

import UIKit
import SearchTextField

class InsuranceDetailsTVC: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var cnstStackVwHeight: NSLayoutConstraint!
    @IBOutlet weak var imgVwDots: UIImageView!
    @IBOutlet weak var stackVwDetails: UIStackView!
    @IBOutlet weak var imgVwDropDown: UIImageView!
    @IBOutlet weak var btnHideShow: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtFldFullNameB: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPincode: UITextField!
    @IBOutlet weak var txtFldAddress: UITextField!
    @IBOutlet weak var txtFldPassport: UITextField!
    @IBOutlet weak var txtFldMobile: UITextField!
    @IBOutlet weak var txtfldCity: SearchTextField!
    @IBOutlet weak var txtFldState: SearchTextField!
    @IBOutlet weak var txtFldCountry: SearchTextField!
    @IBOutlet weak var txtFldDestination: UITextField!
    @IBOutlet weak var txtFldGender: UITextField!
    @IBOutlet weak var txtFldLastNameIn: UITextField!
    @IBOutlet weak var txtFldFirstNameI: UITextField!
    @IBOutlet weak var txtFldDob: UITextField!
    @IBOutlet weak var txtFldTitle: UITextField!
    @IBOutlet weak var txtFldRelationInsured: UITextField!
    @IBOutlet weak var vwCheckIfSameAddress: UIView!
    @IBOutlet weak var actionSameAddress: UIButton!
    @IBOutlet weak var txtFldBenefTitle: UITextField!
    @IBOutlet weak var cnstBottomLine: NSLayoutConstraint!
    @IBOutlet weak var cnstUpperLine: NSLayoutConstraint!
    @IBOutlet weak var vwSameBeneficiaryName: UIView!
    @IBOutlet weak var btnSameName: UIButton!
    @IBOutlet weak var btnSameEmail: UIButton!
    @IBOutlet weak var btnSameMobile: UIButton!
    @IBOutlet weak var vwSameEmail: UIView!
    @IBOutlet weak var vwSameMobile: UIView!
    @IBOutlet weak var cnstWidthSameName: NSLayoutConstraint!
    //MARK: - Variables
    var selectedLineColor : UIColor = UIColor.darkGray
    var lineColor : UIColor = UIColor.darkGray
    let border = CALayer()
    var lineHeight : CGFloat = CGFloat(1.0)
    //MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
}
