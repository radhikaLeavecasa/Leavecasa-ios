//
//  PassangerDetailXIB.swift
//  LeaveCasa
//
//  Created by acme on 20/12/22.
//

import UIKit
import SearchTextField
import IBAnimatable

class PassangerDetailXIB: UITableViewCell, UITextFieldDelegate {
    //MARK: - @IBOutlets
    @IBOutlet weak var cnstSaveCustomer: NSLayoutConstraint!
    @IBOutlet weak var vwNationality: UIView!
    @IBOutlet weak var vwSaveMyCustomerList: AnimatableView!
    @IBOutlet weak var txtFldFFNumber: UITextField!
    @IBOutlet weak var txtFldFFAirline: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var btnSaveUser: UIButton!
    @IBOutlet weak var btnExistingUser: UIButton!
    @IBOutlet weak var btnAddOn: UIButton!
    @IBOutlet weak var btnBaggage: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var ihaveGstView: UIView!
    @IBOutlet weak var gstMainView: UIView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCountry: SearchTextField!
    @IBOutlet weak var txtState: SearchTextField!
    @IBOutlet weak var txtCity: SearchTextField!
    @IBOutlet weak var gstEmailView: UIView!
    @IBOutlet weak var txtGstEmail: UITextField!
    @IBOutlet weak var btnGST: UIButton!
    @IBOutlet weak var gstNumberView: UIView!
    @IBOutlet weak var txtGstNumber: UITextField!
    @IBOutlet weak var gstCompanyVIew: UIView!
    @IBOutlet weak var txtGstCompanyName: UITextField!
    @IBOutlet weak var companyAddressView: UIView!
    @IBOutlet weak var txtCompanyAddress: UITextField!
    @IBOutlet weak var lblAdultIndexCount: UILabel!
    @IBOutlet weak var lblPassangerIndex: UILabel!
    @IBOutlet weak var txtPassportExpDate: UITextField!
    @IBOutlet weak var txtPassportIsuueDate: UITextField!
    @IBOutlet weak var txtPassportNumber: UITextField!
    @IBOutlet weak var stateStack: UIStackView!
    @IBOutlet weak var countryStack: UIStackView!
    @IBOutlet weak var addressStack: UIStackView!
    @IBOutlet weak var mobileStack: UIStackView!
    @IBOutlet weak var emailStack: UIStackView!
    @IBOutlet weak var vwCompanyPhone: UIView!
    @IBOutlet weak var passportNumberStack: UIStackView!
    @IBOutlet weak var passportDateStack: UIStackView!
    @IBOutlet weak var txtFldGstPhone: UITextField!
    @IBOutlet weak var seatPreferenceStack: UIStackView!
    @IBOutlet weak var txtSeatPreference: UITextField!
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
