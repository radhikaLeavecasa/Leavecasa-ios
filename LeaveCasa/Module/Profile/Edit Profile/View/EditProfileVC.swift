//
//  EditProfileVC.swift
//  LeaveCasa
//
//  Created by acme on 27/09/22.
//

import UIKit
import IBAnimatable
import DropDown
import SKCountryPicker
import SDWebImage

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    //MARK: - @IBOutlets
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var imgUser: AnimatableImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtLive: UITextField!
    @IBOutlet weak var txtNationality: UITextField!
    @IBOutlet weak var txtAnniversaryDate: UITextField!
    @IBOutlet weak var txtMaritalStatus: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    //MARK: - Variables
    var dropDown = DropDown()
    var isDOB = false
   // var imagePicker = UIImagePickerController()
    var isImageNew = false
    var viewModel = EditProfileViewModel()
    var selectedLineColor : UIColor = UIColor.darkGray
    var lineColor : UIColor = UIColor.darkGray
    let border = CALayer()
    var lineHeight : CGFloat = CGFloat(1.0)
    let dateFormatter = DateFormatter()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil

        LoaderClass.shared.txtFldborder(txtFld: txtDOB)
        LoaderClass.shared.txtFldborder(txtFld: txtGender)
        LoaderClass.shared.txtFldborder(txtFld: txtPhoneNumber)
        LoaderClass.shared.txtFldborder(txtFld: txtMaritalStatus)
        LoaderClass.shared.txtFldborder(txtFld: txtNationality)
        LoaderClass.shared.txtFldborder(txtFld: txtFullName)
        LoaderClass.shared.txtFldborder(txtFld: txtLive)
        LoaderClass.shared.txtFldborder(txtFld: txtEmail)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtPhoneNumber.delegate = self
        txtDOB.delegate = self
        txtEmail.delegate = self
        txtLive.delegate = self
        txtGender.delegate = self
        txtMaritalStatus.delegate = self
        txtNationality.delegate = self
        let country = CountryManager.shared.currentCountry
        self.txtNationality.text = country?.countryName
        self.viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupEditProfileData()
    }
    //MARK: - @IBActions
    @IBAction func backOnPress(_ sender: UIButton) {
        self.view.endEditing(true)
        self.popView()
    }
    
    @IBAction func saveOnPress(_ sender: UIButton) {
        self.view.endEditing(true)
        let name = self.txtFullName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let email = self.txtEmail.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let phone = self.txtPhoneNumber.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let gender = self.txtGender.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let dob = self.txtDOB.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let city = self.txtLive.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let nationality = self.txtNationality.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let maritalStatus = self.txtMaritalStatus.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let selectedDate = self.dateFormatter.date(from: self.txtDOB.text ?? "") ?? Date()
        let calendar = Calendar.current
        let currentDate = Date()
        
        let ageComponents = calendar.dateComponents([.year], from: selectedDate, to: currentDate)
            
        
            if name?.isEmpty ?? true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.FULL_NAME)
                return
            } else if maritalStatus?.isEmpty ?? true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.MERITIAL_STATUS)
                return
            } else if nationality?.isEmpty ?? true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.NATIONALITY)
                return
            }  else if email?.isEmpty ?? true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.EMAIL_ENTER)
                return
            } else if email?.isValidEmail() == false {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.VALID_EMAIL)
                return
            }  else if let age = ageComponents.year, age < 12 {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "Adult's age must be more than 12 years")
                return
                
            }
            
            var params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_NAME: name as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_EMAIL: email as AnyObject]
            
            if !(phone?.isEmpty ?? false) {
                params[WSRequestParams.WS_REQS_PARAM_MOBILE] = phone as AnyObject
            }
            if !(gender?.isEmpty ?? false) {
                params[WSRequestParams.WS_REQS_PARAM_GENDER] = gender as AnyObject
            }
            if !(dob?.isEmpty ?? false) {
                params[WSResponseParams.WS_RESP_PARAM_DOB] = dob as AnyObject
            }
            if !(city?.isEmpty ?? false) {
                params[WSResponseParams.WS_RESP_PARAM_CITY.lowercased()] = city as AnyObject
            }
            
            if !(nationality?.isEmpty ?? false) {
                params[CommonParam.NATIONALITY.lowercased()] = nationality as AnyObject
            }
            
            if !(nationality?.isEmpty ?? false) {
                params[CommonParam.NATIONALITY.lowercased()] = nationality as AnyObject
            }
            
            if !(maritalStatus?.isEmpty ?? false) {
                params[CommonParam.MARITAL_STATUS.lowercased()] = maritalStatus as AnyObject
            }
            
            if self.isImageNew == true{
                self.viewModel.callUploadProfile(param: params, media: self.imgUser.image ?? UIImage(),view: self)
            }else{
                self.viewModel.callEditProfile(param: params,view: self)
            }
        }
    
    @IBAction func cameraOnPress(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
            self.imgUser.image = image
            self.isImageNew = true
        }
    }
    //MARK: - Custom methods
    func setupEditProfileData(){
        
        DispatchQueue.main.async {
            self.txtFullName.text = Cookies.userInfo()?.name
            self.txtEmail.text = Cookies.userInfo()?.email
            self.txtPhoneNumber.text = Cookies.userInfo()?.mobile
            self.txtGender.text = Cookies.userInfo()?.gender.capitalized
            self.txtDOB.text = Cookies.userInfo()?.dob
            self.txtLive.text = Cookies.userInfo()?.city
            self.txtNationality.text = Cookies.userInfo()?.nationality
            self.txtMaritalStatus.text = Cookies.userInfo()?.marital_status
            self.imgUser.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imgUser.sd_setImage(with: URL(string: "\(Cookies.userInfo()?.profile_pic ?? "")"), placeholderImage: .placeHolderProfile())
        }
    }
}

extension EditProfileVC:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtFullName || textField == txtLive || textField == txtEmail {
            border.borderColor = UIColor.customPink().cgColor
            border.frame = CGRect(x: 0, y: textField.frame.size.height - lineHeight, width:  textField.frame.size.width, height: textField.frame.size.height)
            border.borderWidth = lineHeight
            textField.layer.addSublayer(border)
            textField.layer.masksToBounds = true
        } else if textField == self.txtDOB{
            self.view.endEditing(true)
            self.isDOB = true
            self.openDateCalendar()
        } else if textField == self.txtGender{
            self.showShortDropDown(view: textField, dataSource: GetData.share.getGender())
        } else if textField == self.txtNationality {
            self.view.endEditing(true)
            CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
                textField.text = country.countryName
            }
        } else if textField == self.txtMaritalStatus{
            self.showShortDropDown(view: textField, dataSource: GetData.share.getMaritialStatus())
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == txtFullName || textField == txtLive || textField == txtEmail {
            border.borderColor = UIColor.darkGray.cgColor
            border.frame = CGRect(x: 0, y: textField.frame.size.height - lineHeight, width:  textField.frame.size.width, height: textField.frame.size.height)
            border.borderWidth = lineHeight
            textField.layer.addSublayer(border)
            textField.layer.masksToBounds = true
            self.view.endEditing(true)
        }
        return true
    }
    
    //MARK: Setup Search Textfield
    func showShortDropDown(view:UITextField,dataSource:[String]){
        self.view.endEditing(true)
        dropDown.anchorView = view.plainView
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = dataSource
        // Action triggered on selection
        dropDown.selectionAction = { [] (index: Int, item: String) in
            debugPrint("Selected item: \(item) at index: \(index)")
            view.text = item
        }
        dropDown.show()
    }
    
    func openDateCalendar() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.txtFullName.resignFirstResponder()
            self.txtEmail.resignFirstResponder()
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
//            if let calendar = UIStoryboard.init(name: ViewControllerType.WWCalendarTimeSelector.rawValue, bundle: nil).instantiateInitialViewController() as? WWCalendarTimeSelector {
//                calendar.delegate = self
//                calendar.optionCurrentDate = Date()
//                calendar.optionStyles.showDateMonth(true)
//                calendar.optionStyles.showMonth(false)
//                calendar.optionStyles.showYear(true)
//                calendar.optionStyles.showTime(false)
//                calendar.optionButtonShowCancel = true
//                self.present(calendar, animated: true, completion: nil)
//            }
//        })
    }
}

// MARK: - WWCALENDARTIMESELECTOR DELEGATE
extension EditProfileVC: WWCalendarTimeSelectorProtocol {
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        if self.isDOB == true{
            self.txtDOB.text = convertDateWithDateFormater("yyyy-MM-dd", date)
        }
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        if date > Date() {
            return false
        } else {
            return true
        }
    }
}

extension EditProfileVC:ResponseProtocol{
    func onSuccess() {
        pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.PROFILE_UPDATE_SUCCESS)
        self.setupEditProfileData()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.popView()
        })
    }
}
