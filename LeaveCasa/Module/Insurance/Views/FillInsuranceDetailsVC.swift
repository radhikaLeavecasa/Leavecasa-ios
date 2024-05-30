//
//  FillInsuranceDetailsVC.swift
//  LeaveCasa
//
//  Created by acme on 01/05/24.
//

import UIKit
import DropDown
import Razorpay
import SearchTextField

class FillInsuranceDetailsVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var tblVwInsurance: UITableView!
    //MARK: - Variables
    typealias Razorpay = RazorpayCheckout
    var razorpay: RazorpayCheckout!
    var insuranceDetails = [InsuranceDetails]()
    let dropDown = DropDown()
    var selectedIndex = -1
    var noOfPax = Int()
    var param = [String:Any]()
    var traceId = ""
    var resultIndex = ""
    var viewModel = FillInsuranceDetailsVM()
    var insuranceAmt = Double()
    var passengerName = String()
    var passengerEmail = String()
    var passengerPhone = String()
    var objPassDetailsVM = PassangerDetailsViewModel()
    var selectedCountryCode = String()
    var hiddenCell = [Int]()
    var isFirstTime = true
    var isDomesticType = false
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        LoaderClass.shared.loadAnimation()
        viewModel.delegate = self
        viewModel.getCountryList(view: self)
        self.tblVwInsurance.tableFooterView = UIView()
        self.tblVwInsurance.ragisterNib(nibName: "InsuranceDetailsTVC")
        self.razorpay = RazorpayCheckout.initWithKey(RazorpayKeys.Live, andDelegate: self)
        let price = isDomesticType ? (59*noOfPax) : (118*noOfPax)
        lblTotalAmount.text = "₹\(insuranceAmt+Double(price))"
        
        for _ in 0..<noOfPax {
            var passanger = InsuranceDetails()
            
            passanger.country = ""
            passanger.email = ""
            passanger.mobile = ""
            passanger.firstName = ""
            passanger.lastName = ""
            passanger.title = Cookies.userInfo()?.title ?? ""
            passanger.dob = ""
            passanger.address = ""
            passanger.city = ""
            
            self.insuranceDetails.append(passanger)
        }
    }
    //MARK: - Razor Pay method
    internal func showPaymentForm(currency : String, amount: Double, name: String, description : String, contact: String, email: String ,isForWallet:Bool = false) {
        let options: [String:Any] = [
            "amount": "\(amount * 100)",
            "currency": "INR",
            "name": name,
            "prefill": [
                "contact": contact,
                "email": email
            ],
            "theme": [
                "color": "#E30166"
            ]
        ]
        DispatchQueue.main.async {
            self.razorpay.open(options)
        }
    }
    //MARK: - @IBActions
    @IBAction func actionSubmit(_ sender: UIButton) {
        if isValidatePassanger() {
            
            let price = isDomesticType ? (59*noOfPax) : (118*noOfPax)
            
            self.showPaymentForm(currency: "INR", amount: insuranceAmt+Double(price), name: passengerName, description: "", contact: passengerPhone, email: passengerEmail)
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
    @IBAction func actionInfoo(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .TaxBifurcationVC, StoryboardName: .Flight) as? TaxBifurcationVC {
            vc.otherChagerOrOT = "Total Convenience Fee:₹\(isDomesticType ? "\(59*noOfPax)" : "\(118*noOfPax)")"
            
            vc.tax = "Convenience Fee: ₹\(isDomesticType ? "\(50*noOfPax)" : "\(100*noOfPax)")\n18% GST: ₹\(isDomesticType ? "\(9*noOfPax)" : "\(18*noOfPax)")"
            vc.titleStr = "Insurance Price: ₹\(insuranceAmt.rounded())"
            LoaderClass.shared.presentPopover(self, vc, sender: sender, size: CGSize(width: 250, height: 130),arrowDirection: .any)
        }
    }
    //MARK: - Custom methods
    func isValidatePassanger() -> Bool {
        
        for (at,index) in self.insuranceDetails.enumerated(){
            if index.title.isEmptyCheck() == true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_CHOOSE) pax \(at+1) \(CommonMessage.PLEASE_FILL_TITLE)")
                return false
            } else if index.dob.isEmptyCheck() == true{
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) pax \(at+1) \(CommonMessage.PLEASE_FILL_DATE_OF_BIRTH)")
                return false
            } else if index.firstName.isEmptyCheck() == true{
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) pax \(at+1) \(CommonMessage.PLEASE_FILL_FIRST_NAME)")
                return false
            }else if index.lastName.isEmptyCheck() == true{
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) pax \(at+1) \(CommonMessage.PLEASE_FILL_FIRST_LAST)")
                return false
            } else if index.gender.isEmptyCheck() == true{
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_CHOOSE) pax \(at+1) \(CommonMessage.PLEASE_FILL_INSURED_GENDER)")
                return false
            } else if index.destination.isEmptyCheck() == true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_CHOOSE) pax \(at+1) \(CommonMessage.PLEASE_FILL_MAJOR_DESTINATION)")
                return false
            } else if index.country.isEmptyCheck() == true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_CHOOSE) pax \(at+1) \(CommonMessage.PLEASE_FILL_COUNTRY)")
                return false
            } else if index.state.isEmptyCheck() == true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_CHOOSE) pax \(at+1) \(CommonMessage.PLEASE_FILL_STATE)")
                return false
            } else if index.city.isEmptyCheck() == true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_CHOOSE) pax \(at+1) \(CommonMessage.PLEASE_FILL_CITY)")
                return false
            } else if index.mobile.isEmptyCheck() == true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(CommonMessage.PLEASE_FILL_MOBILE_NUMBER)")
                return false
            } else if index.address.isEmptyCheck() == true{
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) pax \(at+1) \(CommonMessage.PLEASE_FILL_ADDRESS)")
                return false
            } else if index.pincode.isEmptyCheck() == true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(CommonMessage.PLEASE_FILL_PINCODE)")
                return false
            } else if index.email.isEmptyCheck() == true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) pax \(at+1) \(CommonMessage.PLEASE_FILL_EMAIL)")
                return false
            }else if index.email.isValidEmail() == false {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) pax \(at+1) \(CommonMessage.PLEASE_FILL_VALID_EMAIL)")
                return false
            } else if index.beneficiaryTitle.isEmptyCheck() == true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_CHOOSE) pax \(at+1) \(CommonMessage.PLEASE_FILL_TITLE)")
                return false
            } else if index.beneficiaryFullName.isEmptyCheck() == true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) pax \(at+1) \(CommonMessage.PLEASE_FILL_BENEFICIARY_FULLNAME)")
                return false
            } else if index.insuredRelation.isEmptyCheck() == true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_CHOOSE) pax \(at+1) \(CommonMessage.PLEASE_FILL_RELATION_INSURED)")
                return false
            }
        }
        return true
    }
}

extension FillInsuranceDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noOfPax
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InsuranceDetailsTVC", for: indexPath) as! InsuranceDetailsTVC
        let indexData = self.insuranceDetails[indexPath.row]
        cell.lblTitle.text = "Pax \(indexPath.row+1)"
        
        DispatchQueue.main.async {
            LoaderClass.shared.txtFldborder(txtFld: cell.txtFldCountry)
            LoaderClass.shared.txtFldborder(txtFld: cell.txtFldState)
            LoaderClass.shared.txtFldborder(txtFld: cell.txtfldCity)
        }
        
        cell.btnSameName.isSelected = indexData.isSameFullName
        cell.btnSameEmail.isSelected = indexData.isSameEmail
        cell.btnSameMobile.isSelected = indexData.isSameMobile
        cell.actionSameAddress.isSelected = indexData.isSameAddress
        DispatchQueue.main.async {
            cell.txtFldFullNameB.isUserInteractionEnabled = !indexData.isSameFullName
            cell.txtFldMobile.isSelected = !indexData.isSameMobile
            cell.txtfldCity.isUserInteractionEnabled = !indexData.isSameAddress
            cell.txtFldAddress.isUserInteractionEnabled = !indexData.isSameAddress
            cell.txtFldState.isUserInteractionEnabled = !indexData.isSameAddress
            cell.txtFldCountry.isUserInteractionEnabled = !indexData.isSameAddress
            cell.txtFldPincode.isUserInteractionEnabled = !indexData.isSameAddress
            cell.txtFldEmail.isUserInteractionEnabled = !indexData.isSameEmail
        }
        
        cell.vwCheckIfSameAddress.isHidden = indexPath.row == 0
        cell.vwSameEmail.isHidden = indexPath.row == 0
        cell.vwSameMobile.isHidden = indexPath.row == 0
        cell.vwSameBeneficiaryName.isHidden = indexPath.row == 0
        
        cell.btnSameName.tag = indexPath.row
        cell.btnSameName.addTarget(self, action: #selector(actionSameName), for: .touchUpInside)
        cell.btnSameEmail.tag = indexPath.row
        cell.btnSameEmail.addTarget(self, action: #selector(actionSameEmail), for: .touchUpInside)
        cell.btnSameMobile.tag = indexPath.row
        cell.btnSameMobile.addTarget(self, action: #selector(actionSameMobile), for: .touchUpInside)
        
        cell.actionSameAddress.tag = indexPath.row
        cell.actionSameAddress.addTarget(self, action: #selector(actionSameAddress), for: .touchUpInside)
        
        cell.btnHideShow.tag = indexPath.row
        cell.btnHideShow.addTarget(self, action: #selector(actionBtnHideShow), for: .touchUpInside)
        cell.txtFldCountry.addTarget(self, action: #selector(self.searchCountry(_:)), for: .editingChanged)
        cell.txtFldState.addTarget(self, action: #selector(self.searchState(_:)), for: .editingChanged)
        cell.txtfldCity.addTarget(self, action: #selector(self.searchCity(_:)), for: .editingChanged)
        
        cell.txtFldTitle.delegate = self
        cell.txtFldBenefTitle.delegate = self
        cell.txtFldFirstNameI.delegate = self
        cell.txtFldLastNameIn.delegate = self
        cell.txtFldDob.delegate = self
        cell.txtFldRelationInsured.delegate = self
        cell.txtFldGender.delegate = self
        cell.txtFldDestination.delegate = self
        cell.txtFldCountry.delegate = self
        cell.txtFldState.delegate = self
        cell.txtfldCity.delegate = self
        cell.txtFldMobile.delegate = self
        cell.txtFldPassport.delegate = self
        cell.txtFldAddress.delegate = self
        cell.txtFldPincode.delegate = self
        cell.txtFldEmail.delegate = self
        cell.txtFldFullNameB.delegate = self
        
        cell.txtFldTitle.tag = indexPath.row
        cell.txtFldBenefTitle.tag = indexPath.row
        cell.txtFldFirstNameI.tag = indexPath.row
        cell.txtFldLastNameIn.tag = indexPath.row
        cell.txtFldDob.tag = indexPath.row
        cell.txtFldRelationInsured.tag = indexPath.row
        cell.txtFldGender.tag = indexPath.row
        cell.txtFldDestination.tag = indexPath.row
        cell.txtFldCountry.tag = indexPath.row
        cell.txtFldState.tag = indexPath.row
        cell.txtfldCity.tag = indexPath.row
        cell.txtFldMobile.tag = indexPath.row
        cell.txtFldPassport.tag = indexPath.row
        cell.txtFldAddress.tag = indexPath.row
        cell.txtFldPincode.tag = indexPath.row
        cell.txtFldEmail.tag = indexPath.row
        cell.txtFldFullNameB.tag = indexPath.row
        
        cell.txtFldTitle.text = indexData.title
        cell.txtFldBenefTitle.text = indexData.beneficiaryTitle
        cell.txtFldFirstNameI.text = indexData.firstName
        cell.txtFldLastNameIn.text = indexData.lastName
        cell.txtFldDob.text = indexData.dob
        cell.txtFldRelationInsured.text = indexData.insuredRelation
        cell.txtFldGender.text = indexData.gender
        cell.txtFldDestination.text = indexData.destination
        cell.txtFldCountry.text = indexData.country
        cell.txtFldState.text = indexData.state
        cell.txtfldCity.text = indexData.city
        cell.txtFldMobile.text = indexData.mobile
        cell.txtFldPassport.text = indexData.passportNumber
        cell.txtFldAddress.text = indexData.address
        cell.txtFldPincode.text = indexData.pincode
        cell.txtFldEmail.text = indexData.email
        cell.txtFldFullNameB.text = indexData.beneficiaryFullName
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        hiddenCell.contains(indexPath.row) ? 100 : UITableView.automaticDimension
    }
    @objc func actionBtnHideShow(_ sender: UIButton) {
        isFirstTime = false
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.tblVwInsurance.cellForRow(at: indexPath) as! InsuranceDetailsTVC
        if hiddenCell.contains(sender.tag) {
            let index = self.hiddenCell.firstIndex(of: sender.tag) ?? 0
            self.hiddenCell.remove(at: index)
            cell.imgVwDots.isHidden = false
            cell.stackVwDetails.isHidden = false
            cell.cnstStackVwHeight.constant = 1100
            cell.cnstBottomLine.constant = 20
            cell.cnstUpperLine.constant = 20
            cell.btnHideShow.setTitle("Hide", for: .normal)
            cell.imgVwDropDown.image = UIImage(named: "ic_dropDown")
        } else {
            hiddenCell.append(sender.tag)
            cell.imgVwDots.isHidden = true
            cell.cnstStackVwHeight.constant = 0
            cell.cnstBottomLine.constant = 0
            cell.cnstUpperLine.constant = -10
            cell.stackVwDetails.isHidden = true
            cell.btnHideShow.setTitle("Show", for: .normal)
            cell.imgVwDropDown.image = UIImage(named: "ic_dropUp")
        }
        tblVwInsurance.reloadData()
    }
    @objc func actionSameAddress(_ sender: UIButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.tblVwInsurance.cellForRow(at: indexPath) as! InsuranceDetailsTVC
        
        if self.insuranceDetails[0].city != "" && self.insuranceDetails[0].country != "" && self.insuranceDetails[0].address != "" && self.insuranceDetails[0].state != "" {
            
            sender.isSelected = !sender.isSelected
            
            if sender.isSelected {
                cell.txtfldCity.text = self.insuranceDetails[0].city
                cell.txtFldPincode.text = self.insuranceDetails[0].pincode
                cell.txtFldCountry.text = self.insuranceDetails[0].country
                cell.txtFldAddress.text = self.insuranceDetails[0].address
                cell.txtFldState.text = self.insuranceDetails[0].state
                
                self.insuranceDetails[sender.tag].countryCode = self.insuranceDetails[0].countryCode
                self.insuranceDetails[sender.tag].isSameAddress = true
                self.insuranceDetails[sender.tag].city = self.insuranceDetails[0].city
                self.insuranceDetails[sender.tag].pincode = self.insuranceDetails[0].pincode
                self.insuranceDetails[sender.tag].country = self.insuranceDetails[0].country
                self.insuranceDetails[sender.tag].address = self.insuranceDetails[0].address
                self.insuranceDetails[sender.tag].state = self.insuranceDetails[0].state
            } else {
                self.insuranceDetails[sender.tag].isSameAddress = false
            }
        } else {
            pushNoInterConnection(view: self,titleMsg: "Alert!", msg: "Please fill all the address details of Pax 1 first")
        }
        
        tblVwInsurance.reloadData()
    }
    
    @objc func actionSameEmail(_ sender: UIButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.tblVwInsurance.cellForRow(at: indexPath) as! InsuranceDetailsTVC
        
        if self.insuranceDetails[0].email != "" {
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                self.insuranceDetails[sender.tag].isSameEmail = true
                cell.txtFldEmail.text = self.insuranceDetails[0].email
                self.insuranceDetails[sender.tag].email = self.insuranceDetails[0].email
            } else {
                self.insuranceDetails[sender.tag].isSameEmail = false
            }
        } else {
            pushNoInterConnection(view: self,titleMsg: "Alert!", msg: "Please fill email of Pax 1 first")
        }
        tblVwInsurance.reloadData()
    }
    @objc func actionSameName(_ sender: UIButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.tblVwInsurance.cellForRow(at: indexPath) as! InsuranceDetailsTVC
        
        if self.insuranceDetails[0].beneficiaryFullName != "" {
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                self.insuranceDetails[sender.tag].isSameFullName = true
                cell.txtFldFullNameB.text = self.insuranceDetails[0].beneficiaryFullName
                self.insuranceDetails[sender.tag].beneficiaryFullName = self.insuranceDetails[0].beneficiaryFullName
            } else {
                self.insuranceDetails[sender.tag].isSameFullName = false
            }
        } else {
            pushNoInterConnection(view: self,titleMsg: "Alert!", msg: "Please fill beneficiary full name of Pax 1 first")
        }
        tblVwInsurance.reloadData()
    }
    
    @objc func actionSameMobile(_ sender: UIButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.tblVwInsurance.cellForRow(at: indexPath) as! InsuranceDetailsTVC
        
        if self.insuranceDetails[0].mobile != "" {
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                cell.txtFldMobile.isUserInteractionEnabled = false
                self.insuranceDetails[sender.tag].isSameMobile = true
                cell.txtFldMobile.text = self.insuranceDetails[0].mobile
                self.insuranceDetails[sender.tag].mobile = self.insuranceDetails[0].mobile
            } else {
                cell.txtFldMobile.isUserInteractionEnabled = true
                self.insuranceDetails[sender.tag].isSameMobile = false
            }
        } else {
            pushNoInterConnection(view: self,titleMsg: "Alert!", msg: "Please fill mobile of Pax 1 first")
        }
        tblVwInsurance.reloadData()
    }
    
    @objc func searchCountry(_ sender: SearchTextField) {
        let string = sender.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20") ?? ""
        
        if string.isEmpty == true{
            return
        }
        
        let arr = viewModel.arrCountries?.filter { $0.name?.lowercased().contains(string.lowercased()) ?? false }
        var arr1 = [String]()
        
        arr?.forEach({ val in
            arr1.append(val.name ?? "")
        })
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.tblVwInsurance.cellForRow(at: indexPath) as! InsuranceDetailsTVC
        
        cell.txtFldCountry.theme = SearchTextFieldTheme.lightTheme()
        cell.txtFldCountry.theme.font = UIFont.systemFont(ofSize: 12)
        cell.txtFldCountry.theme.bgColor = UIColor.white
        cell.txtFldCountry.theme.fontColor = UIColor.theamColor()
        cell.txtFldCountry.theme.cellHeight = 40
        cell.txtFldCountry.filterStrings(arr1)
        cell.txtFldCountry.itemSelectionHandler = { filteredResults, itemPosition in
            DispatchQueue.main.async {
                cell.txtFldCountry.text = arr?[itemPosition].name
                self.selectedCountryCode = arr?[itemPosition].code ?? ""
                self.insuranceDetails[sender.tag].countryCode = arr?[itemPosition].codeAlpha ?? ""
                self.insuranceDetails[sender.tag].country = arr?[itemPosition].name ?? ""
                self.objPassDetailsVM.searchStateApi(arr?[itemPosition].codeAlpha ?? "", view: self)
                cell.txtFldCountry.resignFirstResponder()
            }
        }
    }
    
    @objc func searchState(_ sender: SearchTextField) {
        let string = sender.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20") ?? ""
        
        if string.isEmpty == true{
            return
        }
        
        let arr = objPassDetailsVM.arrState.filter { $0.name?.lowercased().contains(string.lowercased()) ?? false }
        var arr1 = [String]()
        
        arr.forEach({ val in
            arr1.append(val.name ?? "")
        })
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.tblVwInsurance.cellForRow(at: indexPath) as! InsuranceDetailsTVC
        
        cell.txtFldState.theme = SearchTextFieldTheme.lightTheme()
        cell.txtFldState.theme.font = UIFont.systemFont(ofSize: 12)
        cell.txtFldState.theme.bgColor = UIColor.white
        cell.txtFldState.theme.fontColor = UIColor.theamColor()
        cell.txtFldState.theme.cellHeight = 40
        cell.txtFldState.filterStrings(arr1)
        cell.txtFldState.itemSelectionHandler = { filteredResults, itemPosition in
            DispatchQueue.main.async {
                cell.txtFldState.text = arr[itemPosition].name
                self.insuranceDetails[sender.tag].state = arr[itemPosition].name ?? ""
                self.objPassDetailsVM.searchCityApi("\(self.selectedCountryCode)-\(arr[itemPosition].code ?? "")", view: self)
                cell.txtFldState.resignFirstResponder()
            }
        }
    }
    
    @objc func searchCity(_ sender: SearchTextField) {
        let string = sender.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20") ?? ""
        
        if string.isEmpty == true{
            return
        }
        
        let arr = objPassDetailsVM.arrCity.filter { $0.lowercased().contains(string.lowercased()) }
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.tblVwInsurance.cellForRow(at: indexPath) as! InsuranceDetailsTVC

        cell.txtfldCity.theme = SearchTextFieldTheme.lightTheme()
        cell.txtfldCity.theme.font = UIFont.systemFont(ofSize: 12)
        cell.txtfldCity.theme.bgColor = UIColor.white
        cell.txtfldCity.theme.fontColor = UIColor.theamColor()
        cell.txtfldCity.theme.cellHeight = 40
        cell.txtfldCity.filterStrings(arr)
        cell.txtfldCity.itemSelectionHandler = { filteredResults, itemPosition in
            DispatchQueue.main.async {
                self.insuranceDetails[sender.tag].city = arr[itemPosition]
                cell.txtfldCity.text = arr[itemPosition]
                cell.txtfldCity.resignFirstResponder()
            }
        }
    }
}

extension FillInsuranceDetailsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let indexPath = IndexPath(row: textField.tag, section: 0)
        let cell = self.tblVwInsurance.cellForRow(at: indexPath) as! InsuranceDetailsTVC
        if textField == cell.txtFldMobile {
            let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            if newText.count > 15 {
                return false
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexPath = IndexPath(row: textField.tag, section: 0)
        let cell = self.tblVwInsurance.cellForRow(at: indexPath) as! InsuranceDetailsTVC
        cell.border.borderColor = UIColor.darkGray.cgColor
        cell.border.frame = CGRect(x: 0, y: textField.frame.size.height - cell.lineHeight, width:  textField.frame.size.width, height: textField.frame.size.height)
        cell.border.borderWidth = cell.lineHeight
        textField.layer.addSublayer(cell.border)
        textField.layer.masksToBounds = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let indexPath = IndexPath(row: textField.tag, section: 0)
        
        let cell = self.tblVwInsurance.cellForRow(at: indexPath) as! InsuranceDetailsTVC

        if textField == cell.txtFldTitle || textField == cell.txtFldBenefTitle {
            self.showShortDropDown(textFeild: textField, data: GetData.share.getUserTitle())
            return false
        } else if textField == cell.txtFldGender {
            self.showShortDropDown(textFeild: textField, data: GetData.share.getGender())
            return false
        } else if textField == cell.txtFldRelationInsured {
            self.showShortDropDown(textFeild: textField, data: GetData.share.InsuranceRealtion())
            return false
        } else if textField == cell.txtFldDestination {
            self.showShortDropDown(textFeild: textField, data: GetData.share.MajorDestiantion())
            return false
        } else if textField == cell.txtFldDob {
            view.endEditing(true)
            textField.resignFirstResponder()
            self.selectedIndex = textField.tag
            self.openDateCalendar()
            return false
        } else if textField == cell.txtFldState {
            if cell.txtFldCountry.text == "" {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "Please fill country first")
                return false
            }
                return true
        } else if textField == cell.txtfldCity {
            if cell.txtFldState.text == "" {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "Please fill state first")
                return false
            }
                return true
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let indexPath = IndexPath(row: textField.tag, section: 0)
        let cell = self.tblVwInsurance.cellForRow(at: indexPath) as! InsuranceDetailsTVC

        cell.border.borderColor = UIColor.customPink().cgColor
        
        cell.border.frame = CGRect(x: 0, y: textField.frame.size.height - cell.lineHeight, width:  textField.frame.size.width, height: textField.frame.size.height)
        cell.border.borderWidth = cell.lineHeight
        textField.layer.addSublayer(cell.border)
        textField.layer.masksToBounds = true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        let indexPath = IndexPath(row: textField.tag, section: 0)
        let cell = self.tblVwInsurance.cellForRow(at: indexPath) as! InsuranceDetailsTVC

        self.insuranceDetails[textField.tag].title = cell.txtFldTitle.text ?? ""
        self.insuranceDetails[textField.tag].dob = cell.txtFldDob.text ?? ""
        self.insuranceDetails[textField.tag].firstName = cell.txtFldFirstNameI.text ?? ""
        self.insuranceDetails[textField.tag].lastName = cell.txtFldLastNameIn.text ?? ""
        self.insuranceDetails[textField.tag].gender = cell.txtFldGender.text ?? ""
        self.insuranceDetails[textField.tag].destination = cell.txtFldDestination.text ?? ""
        self.insuranceDetails[textField.tag].country = cell.txtFldCountry.text ?? ""
        self.insuranceDetails[textField.tag].state = cell.txtFldState.text ?? ""
        self.insuranceDetails[textField.tag].city = cell.txtfldCity.text ?? ""
        self.insuranceDetails[textField.tag].mobile = cell.txtFldMobile.text ?? ""
        self.insuranceDetails[textField.tag].address = cell.txtFldAddress.text ?? ""
        self.insuranceDetails[textField.tag].passportNumber = cell.txtFldPassport.text ?? ""
        self.insuranceDetails[textField.tag].pincode = cell.txtFldPincode.text ?? ""
        self.insuranceDetails[textField.tag].email = cell.txtFldEmail.text ?? ""
        self.insuranceDetails[textField.tag].beneficiaryFullName = cell.txtFldFullNameB.text ?? ""
        self.insuranceDetails[textField.tag].beneficiaryTitle = cell.txtFldBenefTitle.text ?? ""
        self.insuranceDetails[textField.tag].insuredRelation = cell.txtFldRelationInsured.text ?? ""
        
        self.tblVwInsurance.reloadData()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func showShortDropDown(textFeild:UITextField,data:[String]){
        DispatchQueue.main.async {
            textFeild.resignFirstResponder()
            
            self.dropDown.anchorView = textFeild.plainView
            self.dropDown.bottomOffset = CGPoint(x: 0, y:(self.dropDown.anchorView?.plainView.bounds.height)!)
            
            self.dropDown.dataSource = data
            
            let indexPath = IndexPath(row: textFeild.tag, section: 0)
            let cell = self.tblVwInsurance.cellForRow(at: indexPath) as! InsuranceDetailsTVC
            
            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
                if textFeild == cell.txtFldTitle {
                    cell.txtFldTitle.text = item
                    cell.txtFldGender.text = GetData.share.getGenderData(string: item)
                    self.insuranceDetails[textFeild.tag].title = item
                    self.insuranceDetails[textFeild.tag].gender = GetData.share.getGenderData(string: item)
                } else if textFeild == cell.txtFldBenefTitle {
                    cell.txtFldBenefTitle.text = item
                    self.insuranceDetails[textFeild.tag].beneficiaryTitle = item
                } else if textFeild == cell.txtFldDestination {
                    cell.txtFldDestination.text = item
                    self.insuranceDetails[textFeild.tag].destination = item
                } else if textFeild == cell.txtFldRelationInsured {
                    cell.txtFldRelationInsured.text = item
                    self.insuranceDetails[textFeild.tag].insuredRelation = item
                }
            }
            self.dropDown.show()
        }
    }
    
    func openDateCalendar() {
        if let calendar = UIStoryboard.init(name: ViewControllerType.WWCalendarTimeSelector.rawValue, bundle: nil).instantiateInitialViewController() as? WWCalendarTimeSelector {
            view.endEditing(true)
            calendar.delegate = self
            calendar.optionCurrentDate = Date()
            calendar.optionStyles.showDateMonth(true)
            calendar.optionStyles.showMonth(false)
            calendar.optionStyles.showYear(true)
            calendar.optionStyles.showTime(false)
            calendar.optionButtonShowCancel = true
            self.present(calendar, animated: true, completion: nil)
        }
    }
}

extension FillInsuranceDetailsVC: WWCalendarTimeSelectorProtocol {
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        self.insuranceDetails[self.selectedIndex].dob = self.convertDateWithDateFormater("MMM dd, yyyy",date)
        self.tblVwInsurance.reloadData()
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        if date > Date() {
            return false
        } else {
            return true
        }
    }
}

extension FillInsuranceDetailsVC : RazorpayPaymentCompletionProtocol {
    
    func onPaymentError(_ code: Int32, description str: String) {
        debugPrint("error: ", code, str)
        pushNoInterConnection(view: self,titleMsg: "Alert", msg: str)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        debugPrint("success: ", payment_id)
        
        var Passengers = [[String:Any]]()
        for (_,index) in self.insuranceDetails.enumerated() {
            let indexPassender = ["Title": index.title,
                                  WSResponseParams.WS_RESP_PARAM_FIRSTNAME: index.firstName,
                                  WSResponseParams.WS_RESP_PARAM_LASTNAME: index.lastName,
                                  WSRequestParams.WS_REQS_PARAM_DOB: index.dob,
                                  WSRequestParams.WS_REQS_PARAM_GENDER.capitalized: index.gender == "Male" ? 1 : index.gender == "Female" ? 2 : 3,
                                  WSRequestParams.WS_REQS_PARAM_SEX.capitalized: index.gender == "Male" ? 1 : index.gender == "Female" ? 2 : 3,
                                  WSRequestParams.WS_REQS_PARAM_BENE_TITLE: index.beneficiaryTitle,
                                  WSResponseParams.WS_RESP_PARAM_BENE_NAME: "\(index.beneficiaryTitle) \(index.beneficiaryFullName.components(separatedBy: " ").count > 1 ? index.beneficiaryFullName.components(separatedBy: " ")[0] : index.beneficiaryFullName) \(index.beneficiaryFullName.components(separatedBy: " ").count > 1 ? index.beneficiaryFullName.components(separatedBy: " ")[1] : index.beneficiaryFullName)",
                                  WSResponseParams.WS_RESP_PARAM_RELATION: "Self",
                                  WSResponseParams.WS_RESP_PARAM_RELATION_BENE: index.insuredRelation,
                                  WSRequestParams.WS_REQS_PARAM_PASSPORT_NO: index.passportNumber,
                                  WSRequestParams.WS_REQS_PARAM_PHONE_NUMBER2: index.mobile,
                                  WSResponseParams.WS_RESP_PARAM_EMAIL_ID: index.email,
                                  WSResponseParams.WS_RESP_PARAM_ADDRESS_LINE1: index.address,
                                  WSResponseParams.WS_RESP_PARAM_ADDRESS_LINE2: index.address,
                                  WSResponseParams.WS_RESP_PARAM_CITYCODE_CAP: index.city,
                                  WSResponseParams.WS_RESP_PARAM_COUNTRYCODE_CAP: index.countryCode,
                                  WSResponseParams.WS_RESP_PARAM_MAJOR_DESTINATION: index.destination,
                                  WSResponseParams.WS_RESP_PARAM_PIN_CODE: index.pincode,
                                  WSResponseParams.WS_RESP_PARAM_PASS_COUNTRY: index.country] as [String : Any]
            Passengers.append(indexPassender)
        }
        
        
        self.param = [WSRequestParams.WS_REQS_PARAM_GENERATE_INSURANCE: "true",
                      WSRequestParams.WS_REQS_PARAM_PASSENGERS: Passengers,
                      WSResponseParams.WS_RESP_PARAM_TRACE_ID:self.traceId,
                      WSResponseParams.WS_RESP_PARAM_RESULTS_INDEX: self.resultIndex,
                      WSResponseParams.WS_RESP_PARAM_USER_ID: UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false ? "\(Cookies.userInfo()?.id ?? 0)" : ""]
        LoaderClass.shared.loadAnimation()
        viewModel.insuranceBookApi(param: self.param, view: self)
    }
}


extension FillInsuranceDetailsVC: RazorpayPaymentCompletionProtocolWithData {
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        debugPrint("error: ", code)
        pushNoInterConnection(view: self,titleMsg: "Alert", msg: str)
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        debugPrint("success: ", payment_id)
    }
}
extension FillInsuranceDetailsVC: ResponseProtocol {
    func onSuccess() {
        LoaderClass.shared.stopAnimation()
        if viewModel.insuranceModel?.responseStatus != 1 {
            self.pushNoInterConnection(view: self,titleMsg: "Alert!", msg: viewModel.insuranceModel?.error?.errorMessage ?? "")
        } else {
            pushNoInterConnection(view: self, image: "ic_success", titleMsg: "Insurance Status", msg: "Insurance booked successfully!"){ [self] in
                if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
                    vc.bookingId = "\(viewModel.insuranceModel?.itinerary?.bookingId ?? 0)"
                    vc.type = 4
                    self.pushView(vc: vc,title: AlertMessages.INVOICE)
                }
            }
        }
    }
}
