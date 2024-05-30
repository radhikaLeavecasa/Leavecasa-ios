//
//  ConfirmBusBookingVC.swift
//  LeaveCasa
//
//  Created by acme on 18/10/22.
//

import UIKit
import IBAnimatable
import DropDown

protocol ConfirmBusBookingVCDelegate {
    func applyCoupon(discount: Double, couponCode: String, couponId: Int)
}

var confirmBusBookingVCDelegate: ConfirmBusBookingVCDelegate?

class ConfirmBusBookingVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblPromoCodeOffers: UILabel!
    @IBOutlet weak var vwCompanyName: UIView!
    @IBOutlet weak var lblSeatsCount: UILabel!
    @IBOutlet weak var btnGST: UIButton!
    @IBOutlet weak var lblTermsAndCondition: UILabel!
    @IBOutlet weak var btnNextHeight: NSLayoutConstraint!
    @IBOutlet weak var btnNext: AnimatableButton!
    @IBOutlet weak var lblNumberSeat: UILabel!
    @IBOutlet weak var txtFldGST: UITextField!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var txtFldGstPhone: UITextField!
    @IBOutlet weak var txtFldGstEmail: UITextField!
    @IBOutlet weak var txtFldCompanyAddress: UITextField!
    @IBOutlet weak var txtFldGstCompanyName: UITextField!
    @IBOutlet weak var vwCompanyAddress: UIView!
    @IBOutlet weak var constVwBottomHeight: NSLayoutConstraint!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var btnContinue: AnimatableButton!
    @IBOutlet weak var lblSeatNumber: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var vwCompanyEmail: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var gstView: UIView!
    @IBOutlet weak var vwCompanyPhone: UIView!
    @IBOutlet weak var lblCouponName: UILabel!
    @IBOutlet weak var vwCouponApplied: AnimatableView!
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var txtfldPhoneNo: UITextField!
//    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var lblTravellerName: UILabel!
    //MARK: - Variables
    var indexCount = 1
    var discount = Double()
    var couponCode = ""
    var couponId = 0
    lazy var souceName = ""
    lazy var destinationName = ""
    lazy var date = ""
    lazy var time = ""
    lazy var price = Double()
    lazy var totalSeats = Int()
    lazy var busSeat = [BusSeat]()
  //  lazy var passangerDetails = [["isSmallView":false,CommonParam.NAME:"",CommonParam.AGE:"","isMale":true,CommonParam.TITLE:"Mr"] as [String : Any]]
    lazy var seatNumber = [String]()
    var passangerDetails = [BusPassangerDetails]()
    lazy var sBpId = String()
    lazy var bus = Bus()
    lazy var isTerms = false
    let dropDown = DropDown()
    
    var viewModel = BusConfirmViewModel()
    lazy var logID = String()
    var travellerName = String()
    //Textfield Underline
    var selectedLineColor : UIColor = UIColor.darkGray
    var lineColor : UIColor = UIColor.darkGray
    let border = CALayer()
    var lineHeight : CGFloat = CGFloat(1.0)
    lazy var objBusSearchVM = BusSearchViewModel()
    var searchedParams = [String: Any]()
    var checkInDate = Date()

    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        vwBottom.isHidden = false
        constVwBottomHeight.constant = 70
        lblTravellerName.text = travellerName
        lblPromoCodeOffers.text = UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true ? "Login to access amazing offers" : "Promo-code/Bank offers"
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        DispatchQueue.main.async {
            
            LoaderClass.shared.txtFldborder(txtFld: self.txtFldGST)
            LoaderClass.shared.txtFldborder(txtFld: self.txtFldGstEmail)
            LoaderClass.shared.txtFldborder(txtFld: self.txtFldGstPhone)
            LoaderClass.shared.txtFldborder(txtFld: self.txtFldCompanyAddress)
            LoaderClass.shared.txtFldborder(txtFld: self.txtFldGstCompanyName)
        }
        let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldFont(size: 14)]
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightBlue(), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,  NSAttributedString.Key.font: UIFont.boldFont(size: 14)] as [NSAttributedString.Key : Any]

        let partOne = NSMutableAttributedString(string: "Accept all the ", attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: "Booking Policies", attributes: yourOtherAttributes)

        partOne.append(partTwo)
        lblTermsAndCondition.attributedText = partOne
        confirmBusBookingVCDelegate = self
     //   constVwBottomHeight.constant = 0
        
        
        for _ in 0..<totalSeats {
            var passengerDet = BusPassangerDetails()
            //  lazy var passangerDetails = [["isSmallView":false,CommonParam.NAME:"",CommonParam.AGE:"","isMale":true,CommonParam.TITLE:"Mr"] as [String : Any]]
           
                passengerDet.mobile = ""
                passengerDet.email = ""
                passengerDet.name = ""
                passengerDet.age = ""
                passengerDet.isMale = true
                passengerDet.title = ""
                passengerDet.idNumber = ""
                passengerDet.idType = ""
            
            self.passangerDetails.append(passengerDet)
        }
        self.seltupTableView()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.tableView.layer.removeAllAnimations()
        self.tableViewHeight.constant = self.tableView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    //MARK: - @IBActions
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
    @IBAction func actionCancellationPolicy(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
            self.pushView(vc: vc,title: "Terms and Conditions")
        }
//        if let vc = ViewControllerHelper.getViewController(ofType: .BusCancellationPolicyVC, StoryboardName: .Bus) as? BusCancellationPolicyVC {
//            vc.bus = bus
//            vc.modalPresentationStyle = .overFullScreen
//            self.present(vc, animated: true)
//        }
    }
    @IBAction func actionChooseAnotherFare(_ sender: Any) {
        LoaderClass.shared.isFareScreen = true
        self.objBusSearchVM.searchBus(param: searchedParams, view: self, souceName: souceName, destinationName: destinationName, checkinDate: checkInDate, date: searchedParams[WSRequestParams.WS_REQS_PARAM_JOURNEY_DATE] as! String)
    }
    
    @IBAction func actionDeleteCoupon(_ sender: Any) {
        vwCouponApplied.isHidden = true
        self.discount = 0
        self.lblPrice.text = "₹\(String(format: "%.1f", self.price - self.discount))"
        self.lblTotalPrice.text = "₹\(String(format: "%.1f", self.price - self.discount))"
    }
    
    @IBAction func offerOnPress(_ sender: UIButton) {
        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true {
            let vc = ViewControllerHelper.getViewController(ofType: .GuestLoginVC, StoryboardName: .Main) as! GuestLoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if let vc = ViewControllerHelper.getViewController(ofType: .CouponVC, StoryboardName: .Hotels) as? CouponVC {
                vc.isFromBus = true
                self.present(vc, animated: true)
            }
        }
    }
    
    @IBAction func termsOnPress(_ sender: UIButton) {
        if sender.isSelected == false{
            sender.isSelected = true
            self.isTerms = true
        }else{
            self.isTerms = false
            sender.isSelected = false
        }
    }
    
    @IBAction func gstOnPress(_ sender: UIButton) {
        if sender.isSelected == false{
            sender.isSelected = true
            self.gstView.isHidden = false
            self.vwCompanyName.isHidden = false
            self.vwCompanyAddress.isHidden = false
            self.vwCompanyEmail.isHidden = false
            self.vwCompanyPhone.isHidden = false
        }else{
            sender.isSelected = false
            self.vwCompanyName.isHidden = true
            self.vwCompanyAddress.isHidden = true
            self.gstView.isHidden = true
            self.vwCompanyEmail.isHidden = true
            self.vwCompanyPhone.isHidden = true
        }
    }
    
    @objc func handleTapOnLabel(gesture: UITapGestureRecognizer) {
        guard let text = self.lblTermsAndCondition.attributedText?.string else {
            return
        }
        
        if let range = text.range(of: NSLocalizedString(AlertMessages.CANCELLATION_POLICY, comment: "Cancellation")),
                 gesture.didTapAttributedTextInLabel(label: self.lblTermsAndCondition, inRange: NSRange(range, in: text)) {
            if let vc = ViewControllerHelper.getViewController(ofType: .BusCancellationPolicyVC, StoryboardName: .Bus) as? BusCancellationPolicyVC {
                vc.bus = bus
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }
    }
    
    @IBAction func continueOnPress(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.passangerDetails.count > 0 {
            if isValidatePassanger() {
                //            if checkAllDetails() == false {
                //                pushNoInterConnection(view: self,titleMsg: "Alert", msg: AlertMessages.FILL_ALL_DETAILS)
                //            } else if self.passangerDetails.count != self.busSeat.count {
                //                pushNoInterConnection(view: self,titleMsg: "Alert", msg: AlertMessages.FILL_ALL_DETAILS)
                //            } else if self.passangerDetails.count != self.busSeat.count {
                //                pushNoInterConnection(view: self,titleMsg: "Alert", msg: AlertMessages.FILL_ALL_DETAILS)
                //            } else if txtfldPhoneNo.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                //                pushNoInterConnection(view: self,titleMsg: "Alert", msg: AlertMessages.CONTACT_INFORMATION)
                //            } else if txtFldEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                //                pushNoInterConnection(view: self,titleMsg: "Alert", msg: AlertMessages.CONTACT_INFORMATION)
                //            } else if txtFldEmail.text?.isValidEmail() == false {
                //                pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.VALID_EMAIL)
                if self.btnGST.isSelected && self.txtFldGST.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.GST)
                } else if self.btnGST.isSelected && txtFldGST.text?.count ?? 0 < 15 {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.VALID_GST)
                } else if self.btnGST.isSelected && txtFldGstCompanyName.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.COMPANY_NAME)
                } else if self.btnGST.isSelected && txtFldCompanyAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.COMPANY_ADDRESS)
                } else if self.btnGST.isSelected && txtFldGstEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.COMPANY_EMAIL)
                } else if self.btnGST.isSelected && txtFldGstEmail.text?.isValidEmail() == false  {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.VALID_COMPANY_EMAIL)
                } else if self.btnGST.isSelected && txtFldGstPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.COMPANY_PHONE)
                } else if self.isTerms == false {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: AlertMessages.ACCEPT_POLICY)
                } else {
                    self.viewModel.callBusSeatBlock(guestDetails: self.passangerDetails, sBpId: self.sBpId, bus: self.bus, seats: self.busSeat, view: self, logID: self.logID, couponCode: self.couponCode, couponId: self.couponId,gstEmail: txtFldGstEmail.text ?? "", gstNumber: txtFldGST.text ?? "",gstCompanyName: txtFldGstCompanyName.text ?? "",gstContactNo: txtFldGstPhone.text ?? "", gstAddress: txtFldCompanyAddress.text ?? "",gstIsSelcted: btnGST.isSelected, price: (String(format: "%.1f", self.price - self.discount)), mobileNo: self.passangerDetails[0].mobile, email: self.passangerDetails[0].email, couponAmt: self.discount)
                }
            }
        }
    }
    
    @IBAction func nextOnPress(_ sender: UIButton) {
        self.indexCount += 1
        if self.indexCount == (self.busSeat.count){
            self.btnNext.isHidden = true
            self.btnNextHeight.constant = 0
        }
            // self.passangerDetails.append(["isSmallView":false,CommonParam.NAME:"",CommonParam.AGE:"","isMale":true,CommonParam.TITLE:GetData.share.getUserTitle().first ?? ""])
        self.tableView.reloadData()
    }
    
    //MARK: - Custom methods
    func seltupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.ragisterNib(nibName: BusPessangerSeatXIB().identifire)
        self.tableView.ragisterNib(nibName: BusSeatPessangerXIB().identifire)
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        self.lblDate.text = self.date
        self.lblTime.text = self.time
        self.lblLocation.text = "\(self.souceName) - \(self.destinationName)"
        self.lblPrice.text = "₹\(String(format: "%.1f", self.price - self.discount))"
        self.lblTotalPrice.text = "₹\(String(format: "%.1f", self.price - self.discount))"
        self.lblNumberSeat.text = "For \(self.totalSeats) \(self.totalSeats == 1 ? "Seat" : "Seats")".uppercased()
        self.lblSeatsCount.text = "\(self.totalSeats) \(self.totalSeats == 1 ? "Seat" : "Seats")".uppercased()
        let name = self.busSeat.map{$0.sName}
        self.seatNumber = name
        self.lblSeatNumber.text = name.joined(separator: ", ")
        
        self.lblTermsAndCondition.isUserInteractionEnabled = true
        self.lblTermsAndCondition.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(gesture: ))))
    }
    
    func checkAllDetails() -> Bool{
        var isFilled = true
        for index in self.passangerDetails{
            if index.name == "" || index.age == "" {
                isFilled = false
                break
            }
        }
        return isFilled
    }
    
    @objc func maleOnPress(sender:UIButton){
        let tag = sender.tag
        self.passangerDetails[tag].isMale = true
        self.tableView.reloadData()
    }
    
    @objc func femaleOnPress(sender:UIButton){
        let tag = sender.tag
        self.passangerDetails[tag].isMale = false
        self.tableView.reloadData()
    }
//    @objc func nextAction(sender:UIButton){
//        view.endEditing(true)
//        let tag = sender.tag
//        if self.passangerDetails[tag].name == "" || self.passangerDetails[tag].age == "" || passangerDetails[tag].title == "" {
//            pushNoInterConnection(view: self,titleMsg: "Alert", msg: "Please fill name and age")
//        } else {
//          //  vwBottom.isHidden = self.indexCount != (self.busSeat.count)
//         //   constVwBottomHeight.constant = self.indexCount != (self.busSeat.count) ? 0 : 70
//          //  self.indexCount += 1
////            if self.passangerDetails[tag]["isSmallView"] as? Bool ?? false == true{
////                self.passangerDetails[tag]["isSmallView"] = false
////            }else{
////                self.passangerDetails[tag]["isSmallView"] = true
////            }
//            if self.passangerDetails.count != self.totalSeats {
//                self.passangerDetails.append(["isSmallView":false,CommonParam.NAME:"",CommonParam.AGE:"","isMale":true,CommonParam.TITLE:GetData.share.getUserTitle().first ?? ""])
//            }
//            self.tableView.reloadData()
//        }
//    }
}

// MARK: - CUSTOM DELEGATE
extension ConfirmBusBookingVC: ConfirmBusBookingVCDelegate {
    func applyCoupon(discount: Double, couponCode: String, couponId: Int) {
        self.discount = discount
        self.couponCode = couponCode
        self.couponId = couponId
        let vc = ViewControllerHelper.getViewController(ofType: .CouponAppliedVC, StoryboardName: .Bus) as! CouponAppliedVC
        vc.couponPrize = "\(Int(discount))"
        self.lblCouponName.text = couponCode
        self.vwCouponApplied.isHidden = false
        self.present(vc, animated: true)
        self.seltupTableView()
    }
}

// MARK: - UITABLEVIEW METHODS
extension ConfirmBusBookingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalSeats
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let seatNo = self.seatNumber[indexPath.row]
        
        let indexData = self.passangerDetails[indexPath.row]
        //        if indexData["isSmallView"] as? Bool ?? false == true {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: BusSeatPessangerXIB().identifire, for: indexPath) as! BusSeatPessangerXIB
        //            cell.lblName.text = "\(indexData[CommonParam.TITLE] as? String ?? "") \(indexData[CommonParam.NAME] as? String ?? "")"
        //            cell.lblage.text = indexData[CommonParam.AGE] as? String ?? ""
        //            cell.lblSeatNo.text = seatNo
        //
        //            return cell
        //        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: BusPessangerSeatXIB().identifire, for: indexPath) as! BusPessangerSeatXIB
        
        
//        if indexData.isMale == true {
//            cell.manView.borderColor = .lightBlue()
//            cell.femaleView.borderColor = .grayColor()
//            cell.imgMan.image = UIImage.init(named: "ic_man_blue")
//            cell.imgFemale.image = UIImage.init(named: "ic_girl_gray")
//        }else{
//            cell.femaleView.borderColor = .customPink()
//            cell.manView.borderColor = .grayColor()
//            cell.imgMan.image = UIImage.init(named: "ic_man_gray")
//            cell.imgFemale.image = UIImage.init(named: "ic_girl_red")
//        }
        
        cell.lblSeatNo.text = "Seat \(seatNo)"
        
        cell.txtName.delegate = self
        cell.txtAge.delegate = self
        cell.txtTitle.delegate = self
        cell.txtFldEmail.delegate = self
        cell.txtFldIDType.delegate = self
        cell.txtFldIDNumber.delegate = self
        cell.txtFldPhoneNumber.delegate = self
        
        
        cell.txtName.text = indexData.name
        cell.txtAge.text = indexData.age
        cell.txtTitle.text = indexData.title
        cell.txtFldEmail.text = indexData.email
        cell.txtFldIDType.text = indexData.idType
        cell.txtFldIDNumber.text = indexData.idNumber
        cell.txtFldPhoneNumber.text = indexData.mobile
        
        cell.txtAge.tag = indexPath.row
        cell.txtName.tag = indexPath.row
        cell.txtTitle.tag = indexPath.row
//        cell.btnMale.tag = indexPath.row
//        cell.btnFemale.tag = indexPath.row
        cell.txtFldEmail.tag = indexPath.row
        cell.txtFldIDType.tag = indexPath.row
        cell.txtFldIDNumber.tag = indexPath.row
        cell.txtFldPhoneNumber.tag = indexPath.row
        
        cell.vwEmail.isHidden = indexPath.row != 0
        cell.vwPhoneNumber.isHidden = indexPath.row != 0
        //            cell.btnext.tag = indexPath.row
        //            cell.btnext.isHidden = self.indexCount-1 != indexPath.row
        // cell.btnTap.tag = indexPath.row
        //  cell.btnTap.addTarget(self, action: #selector(self.actionTap(sender:)), for: .touchUpInside)
//        cell.btnMale.addTarget(self, action: #selector(self.maleOnPress(sender:)), for: .touchUpInside)
//        cell.btnFemale.addTarget(self, action: #selector(self.femaleOnPress(sender:)), for: .touchUpInside)
        // cell.btnext.addTarget(self, action: #selector(self.nextAction(sender:)), for: .touchUpInside)
        
        
        LoaderClass.shared.txtFldborder(txtFld: cell.txtTitle)
        LoaderClass.shared.txtFldborder(txtFld: cell.txtName)
        LoaderClass.shared.txtFldborder(txtFld: cell.txtAge)
        LoaderClass.shared.txtFldborder(txtFld: cell.txtFldEmail)
        LoaderClass.shared.txtFldborder(txtFld: cell.txtFldIDNumber)
        LoaderClass.shared.txtFldborder(txtFld: cell.txtFldPhoneNumber)
        LoaderClass.shared.txtFldborder(txtFld: cell.txtFldIDType)
        return cell
        //  }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let indexData = self.passangerDetails[indexPath.row]
//        if indexData["isSmallView"] as? Bool ?? false == true {
//            let tag = indexPath.row
//            if self.passangerDetails[tag]["isSmallView"] as? Bool ?? false == true{
//                self.passangerDetails[tag]["isSmallView"] = false
//            }else{
//                self.passangerDetails[tag]["isSmallView"] = true
//            }
//            self.tableView.reloadData()
//        }
//    }
//    @objc func actionTap(sender:UIButton){
//        let tag = sender.tag
//        if self.passangerDetails[tag]["isSmallView"] as? Bool ?? false == true{
//            self.passangerDetails[tag]["isSmallView"] = false
//        }else{
//            self.passangerDetails[tag]["isSmallView"] = true
//        }
//        self.tableView.reloadData()
//    }
}

extension ConfirmBusBookingVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let indexpath = IndexPath(row: textField.tag, section: 0)
        let cell = self.tableView.cellForRow(at: indexpath) as! BusPessangerSeatXIB
        if textField == cell.txtTitle {
            self.showShortDropDown(view: textField, dataSource: GetData.share.getUserTitle(), isTitleStr: "title")
            return false
        } else if textField == cell.txtFldIDType {
            self.showShortDropDown(view: textField, dataSource: GetData.share.getIdType(), isTitleStr: "type")
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtFldGstEmail || textField == txtFldGstPhone || textField == txtFldGST || textField == txtFldCompanyAddress || textField == txtFldGstCompanyName {
            border.borderColor = UIColor.customPink().cgColor
            border.frame = CGRect(x: 0, y: textField.frame.size.height - lineHeight, width:  textField.frame.size.width, height: textField.frame.size.height)
            border.borderWidth = lineHeight
            textField.layer.addSublayer(border)
            textField.layer.masksToBounds = true
        } else {
            let indexpath = IndexPath(row: textField.tag, section: 0)
            let cell = self.tableView.cellForRow(at: indexpath) as! BusPessangerSeatXIB
            
            cell.border.borderColor = UIColor.customPink().cgColor
            
            cell.border.frame = CGRect(x: 0, y: textField.frame.size.height - cell.lineHeight, width:  textField.frame.size.width, height: textField.frame.size.height)
            cell.border.borderWidth = cell.lineHeight
            textField.layer.addSublayer(cell.border)
            textField.layer.masksToBounds = true
            
//            if textField == cell.txtTitle {
//                self.showShortDropDown(view: textField, dataSource: GetData.share.getUserTitle(), isTitleStr: "title")
//            } else if textField == cell.txtFldIDType {
//                self.showShortDropDown(view: textField, dataSource: GetData.share.getIdType(), isTitleStr: "type")
//            }
             if textField == cell.txtFldIDNumber {
                if cell.txtFldIDType.text == "None" || cell.txtFldIDType.text == "" {
                    view.endEditing(true)
                    LoaderClass.shared.showSnackBar(message: "Please first select Id type")
                }
            }
//            else if textField == cell.txtName || textField == cell.txtAge {
//                cell.vwUnderline.backgroundColor = textField == cell.txtName ? .customPink() : .darkGray
//                cell.vwUnderline2.backgroundColor = textField == cell.txtName ? .darkGray : .customPink()
//            }
        }
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == txtFldGstEmail || textField == txtFldGstPhone || textField == txtFldGST || textField == txtFldCompanyAddress || textField == txtFldGstCompanyName || textField == txtFldEmail || textField == txtfldPhoneNo {
//        } else {
//            let indexpath = IndexPath(row: textField.tag, section: 0)
//            let cell = self.tableView.cellForRow(at: indexpath) as! BusPessangerSeatXIB
//            debugPrint(cell.txtAge.tag)
//            if textField ==  cell.txtAge{                self.passangerDetails[textField.tag].age = textField.text ?? ""
//            }else if textField == cell.txtTitle{
//                self.passangerDetails[textField.tag].title = textField.text ?? ""
//                self.passangerDetails[textField.tag].isMale = textField.text == "Mr" || textField.text == "Mstr" ? true : false
//            }else if textField == cell.txtName {
//                self.passangerDetails[textField.tag].name = textField.text ?? ""
//            }else if textField == cell.txtFldPhoneNumber {
//                self.passangerDetails[textField.tag].mobile = textField.text ?? ""
//            }else if textField == cell.txtFldEmail {
//                self.passangerDetails[textField.tag].email = textField.text ?? ""
//            }else if textField == cell.txtFldIDType {
//                self.passangerDetails[textField.tag].idType = textField.text ?? ""
//            }else if textField == cell.txtFldIDNumber {
//                self.passangerDetails[textField.tag].idNumber = textField.text ?? ""
//            }
//            self.tableView.reloadData()
//        }
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let indexpath = IndexPath(row: textField.tag, section: 0)
        let cell = self.tableView.cellForRow(at: indexpath) as! BusPessangerSeatXIB
        if textField == txtFldGST || textField == txtFldGstPhone || textField == cell.txtFldPhoneNumber {
            let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            if newText.count > 15 {
                return false
            } else {
                return true
            }
            
        } else {
            if textField == txtFldGstEmail || textField == txtFldGstPhone || textField == txtFldGST || textField == txtFldCompanyAddress || textField == txtFldGstCompanyName{
            } else {
                let indexpath = IndexPath(row: textField.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexpath) as! BusPessangerSeatXIB
                debugPrint(cell.txtAge.tag)
                if textField ==  cell.txtAge {
                    // Get the resulting string after the replace operation
                    let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
                    
                    // Check if the resulting string is empty or not
                    if updatedString.isEmpty {
                        return true
                    }
                    
                    // Check if the resulting string is a valid number
                    guard let age = Int(updatedString) else {
                        return false
                    }
                    return age <= 120
                } else if textField == cell.txtFldPhoneNumber {
                    let newText = (cell.txtFldPhoneNumber.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
                    if newText.count > 15 {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    //MARK: Setup Search Textfeild
    func showShortDropDown(view: UITextField, dataSource: [String], isTitleStr: String) {
        
        let tag = view.tag // Capture the tag value
        debugPrint(tag)
        DispatchQueue.main.async {
            
            view.resignFirstResponder()
            self.dropDown.anchorView = view.plainView
            self.dropDown.bottomOffset = CGPoint(x: 0, y:(self.dropDown.anchorView?.plainView.bounds.height)!)
            self.dropDown.dataSource = dataSource
            // Action triggered on selection
            let indexPath = IndexPath(row: tag, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! BusPessangerSeatXIB
            
            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                debugPrint("Selected item: \(item) at index: \(index)")
              
                if view == cell.txtTitle {
                    self.passangerDetails[tag].title = item
                    self.passangerDetails[tag].isMale = item == "Mr" || item == "Mstr" ? true : false

                } else if view == cell.txtFldIDType {
                    self.passangerDetails[tag].idType = item
                    self.passangerDetails[tag].idNumber = ""
                }
                self.tableView.reloadData()
            }
        }
        dropDown.show()
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == txtFldGstEmail || textField == txtFldGstPhone || textField == txtFldGST || textField == txtFldCompanyAddress || textField == txtFldGstCompanyName {
            border.borderColor = UIColor.darkGray.cgColor
            border.frame = CGRect(x: 0, y: textField.frame.size.height - lineHeight, width:  textField.frame.size.width, height: textField.frame.size.height)
            border.borderWidth = lineHeight
            textField.layer.addSublayer(border)
            textField.layer.masksToBounds = true
        } else {
            let cell = self.tableView.cellForRow(at: IndexPath(row: textField.tag, section: 0)) as! BusPessangerSeatXIB
            cell.border.borderColor = UIColor.darkGray.cgColor
            
            cell.border.frame = CGRect(x: 0, y: textField.frame.size.height - cell.lineHeight, width:  textField.frame.size.width, height: textField.frame.size.height)
            cell.border.borderWidth = cell.lineHeight
            textField.layer.addSublayer(cell.border)
            textField.layer.masksToBounds = true
            
            
            debugPrint(cell.txtAge.tag)
            if textField ==  cell.txtAge{                
                self.passangerDetails[textField.tag].age = textField.text ?? ""
            }else if textField == cell.txtTitle{
                self.passangerDetails[textField.tag].title = textField.text ?? ""
                self.passangerDetails[textField.tag].isMale = textField.text == "Mr" || textField.text == "Mstr" ? true : false
            }else if textField == cell.txtName {
                self.passangerDetails[textField.tag].name = textField.text ?? ""
            }else if textField == cell.txtFldPhoneNumber {
                self.passangerDetails[textField.tag].mobile = textField.text ?? ""
            }else if textField == cell.txtFldEmail {
                self.passangerDetails[textField.tag].email = textField.text ?? ""
            }else if textField == cell.txtFldIDType {
                self.passangerDetails[textField.tag].idType = textField.text ?? ""
            }else if textField == cell.txtFldIDNumber {
                self.passangerDetails[textField.tag].idNumber = textField.text ?? ""
                
                if cell.txtFldIDType.text == "Aadhaar Card" && textField.text?.isValidAadhaar() == false {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(textField.tag+1) valid Aadhaar Card")
                } else if cell.txtFldIDType.text == "Driving licence" && textField.text?.isValidDrivingLicenseNumber() == false {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(textField.tag+1) valid Driving licence")
                } else if cell.txtFldIDType.text == "Voter Card" && textField.text?.isValidVoterCardNumber() == false {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(textField.tag+1) valid Voter Card")
                }
            }
            self.tableView.reloadData()
        }
        
        
        return true
    }
    
    func isValidatePassanger() -> Bool {
        self.view.endEditing(true)
        for (at,index) in self.passangerDetails.enumerated(){
            if index.title.isEmptyCheck() == true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(CommonMessage.PLEASE_FILL_TITLE)")
                return false
            } else if index.name.isEmptyCheck() == true{
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(CommonMessage.PLEASE_FILL_NAME)")
                return false
            } else if index.age.isEmptyCheck() == true{
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) age")
                return false
            } else if index.mobile.isEmptyCheck() == true && at == 0 {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) phone number")
                return false
            } else if (index.mobile.count > 15 || index.mobile.count < 7) && at == 0 {
                self.view.endEditing(true)
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.VALID_MOBILE)
                return false
            } else if index.email.isEmptyCheck() == true && at == 0 {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) email")
                return false
            } else if index.email.isValidEmail() == false && at == 0 {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(CommonMessage.PLEASE_FILL_VALID_EMAIL)")
                return false
            } else if (index.idType.isEmptyCheck() == false && index.idType != "None") && index.idNumber.isEmptyCheck() == true {
                //if index.idType == "" && index.idNumber == ""
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) id number")
                return false
            } else if (index.idType.isEmptyCheck() == false && index.idType != "None") && index.idNumber.isEmptyCheck() == false {
                if index.idType == "Aadhaar Card" && index.idNumber.isValidAadhaar() == false {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) valid Aadhaar Card")
                    return false
                } else if index.idType == "Driving licence" && index.idNumber.isValidDrivingLicenseNumber() == false {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) valid Driving licence")
                    return false
                } else if index.idType == "Voter Card" && index.idNumber.isValidVoterCardNumber() == false {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) valid Voter Card")
                    return false
                }
            }
        }
        return true
    }
}
