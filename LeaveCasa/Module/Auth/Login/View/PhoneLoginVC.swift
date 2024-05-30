//
//  PhoneLoginVC.swift
//  LeaveCasa
//
//  Created by acme on 13/09/22.
//

import UIKit
import IBAnimatable
import SKCountryPicker

class PhoneLoginVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet var btnLoginEmail: [AnimatableButton]!
    @IBOutlet weak var imgVwCountry: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var btnVarify: AnimatableButton!
    @IBOutlet weak var vwAnimatableOne: AnimatableView!
    @IBOutlet weak var vwAnimatableTwo: AnimatableView!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    //MARK: - Variables
    var viewModel = PhoneLoginViewModel()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        actionPhoneEmail(btnLoginEmail[1])
        UserDefaults.standard.set(true, forKey: "isFirstTimeLaunch")
        UserDefaults.standard.synchronize()
        self.txtPhoneNumber.placeholder = Strings.phone_number
        self.setupLabelTap()
        let country = CountryManager.shared.currentCountry
        self.lblCountryCode.text = country?.dialingCode
        self.imgVwCountry.image = country?.flag
    }
    //MARK: - @IBActions
    @IBAction func actionPhoneEmail(_ sender: AnimatableButton) {
        btnLoginEmail[0].isSelected = sender.tag == 0
        for btn in btnLoginEmail {
            btn.borderWidth = 2
            btn.borderColor = btn.tag == sender.tag ? .lightBlue() : .clear
            btn.backgroundColor = btn.tag == sender.tag ? UIColor.lightBlue().withAlphaComponent(0.08) : .white
            btn.setTitleColor(btn.tag == sender.tag ? .lightBlue() : .black, for: .normal)
            btn.titleLabel?.font = btn.tag == sender.tag ? UIFont.boldFont(size: 15.0) : UIFont.regularFont(size: 15.0)
        }
        vwAnimatableOne.isHidden = sender.tag == 1
        vwAnimatableTwo.isHidden = sender.tag == 0
    }
    
    @IBAction func actionSkip(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "isGuestUser")
        UserDefaults.standard.synchronize()
        let vc = ViewControllerHelper.getViewController(ofType: .TabbarVC, StoryboardName: .Main) as! TabbarVC
        vc.showAlert = true
        self.setView(vc: vc)
    }
    @IBAction func varfyOnPress(_ sender: UIButton) {
        if self.isVarify(){
            UserDefaults.standard.set(false, forKey: "isGuestUser")
            UserDefaults.standard.synchronize()
            LoaderClass.shared.loadAnimation()
            self.viewModel.loginWithPhone(param: btnLoginEmail[0].isSelected ?  [CommonParam.MOBILE_NUMBER:self.txtPhoneNumber.text!,CommonParam.COUNTY_CODE:self.lblCountryCode.text ?? ""] : ["email":self.txtFldEmail.text ?? ""],view: self, api: btnLoginEmail[0].isSelected ? .sendOtp : .sendEmailOtp)
        }
    }
    @IBAction func actionPhoneDropDown(_ sender: UIButton) {
        CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
            self.lblCountryCode.text = country.dialingCode
            self.imgVwCountry.image = country.flag
        }
    }
    //MARK: - Custom methods
    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.lblCountryCode.isUserInteractionEnabled = true
        self.lblCountryCode.addGestureRecognizer(labelTap)
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
            self.lblCountryCode.text = country.dialingCode
            self.imgVwCountry.image = country.flag
        }
    }
}

extension PhoneLoginVC{
    
    func isVarify() -> Bool{
        if btnLoginEmail[0].isSelected {
            if self.txtPhoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.MOBILE)
                return false
            }else if self.txtPhoneNumber.text?.count ?? 0 > 15 ||  self.txtPhoneNumber.text?.count ?? 0 < 7 {
                self.view.endEditing(true)
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.VALID_MOBILE)
                return false
            }else{
                return true
            }
        } else {
            if self.txtFldEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.EMAIL_ENTER)
                return false
            } else if self.txtFldEmail.text?.isValidEmail() == false {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.VALID_EMAIL)
                return false
            }else{
                return true
            }
        }
    }
}
