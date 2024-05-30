//
//  HotelConfirmBookingVC.swift
//  LeaveCasa
//
//  Created by acme on 19/09/22.
//

import UIKit
import IBAnimatable
import DropDown

protocol HotelConfirmBookingVCDelegate {
    func applyCoupon(discount: Double, couponCode: String, couponId: Int)
}

var hotelConfirmBookingVCDelegate: HotelConfirmBookingVCDelegate?

class HotelConfirmBookingVC: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var lblGST: UILabel!
    @IBOutlet weak var lblConvenienceFee: UILabel!
    @IBOutlet weak var cnstHeightSomeElse: NSLayoutConstraint!
    @IBOutlet weak var txtFldGstPhone: UITextField!
    @IBOutlet weak var txtFldGstEmail: UITextField!
    @IBOutlet weak var lblServiceFee: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblPriceAfterDiscount: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblRoomAndNight: UILabel!
    @IBOutlet weak var lblBasePrice: UILabel!
    @IBOutlet weak var lblNoOfNight: UILabel!
    @IBOutlet weak var lblGuestAndRoom: UILabel!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblPromoCode: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTotalGuest: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblRoomName: UILabel!
    @IBOutlet weak var lblCheckOutDate: UILabel!
    @IBOutlet weak var lblCheckInDate: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblHotelAddress: UILabel!
    @IBOutlet weak var imgHotel: UIImageView!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var btnPay: AnimatableButton!
    @IBOutlet weak var lblTotalAmountPaid: UILabel!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtGst: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnSomeOneElse: UIButton!
    @IBOutlet weak var txtContactNumber: UITextField!
    @IBOutlet weak var companyAddressView: UIView!
    @IBOutlet weak var companyNameView: UIView!
    @IBOutlet weak var lblCouponName: UILabel!
    @IBOutlet weak var vwCouponApplied: AnimatableView!
    @IBOutlet weak var btnMySelf: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnCheckGST: UIButton!
    @IBOutlet weak var gstTextView: UIView!
    @IBOutlet weak var txtCompanyAddress: UITextField!
    @IBOutlet weak var vwCompanyEmail: UIView!
    @IBOutlet weak var vwCompanyPhone: UIView!
    @IBOutlet weak var tblVwRooms: UITableView!
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var cnstTblRoomsHeight: NSLayoutConstraint!
    @IBOutlet weak var cnstHeightMySelf: NSLayoutConstraint!
    //MARK: - Variables
    var hotelDetail: HotelDetail?
    var markups = [Markup]()
    var hotels: Hotels?
    var hotleRate : HotelRate?
    var totalGuest = ""
    var totalRooms = ""
    var checkInDate = ""
    var checkOutDate = ""
    var noOfNight = ""
    var markupTax = Double()
    var totalAmount = Double()
    var discount = Double()
    var couponCode = ""
    var couponId = 0
    var searchId = ""
    var logId = 0
    var checkIn = ""
    var checkOut = ""
    var guestDetails = [[String:Any]]()
    var titleDropDown = DropDown()
    var no_of_nights = 0
    var flatFee = Int()
    var taxes = Double()
    var finalRooms = [[String: AnyObject]]()
    var selectedLineColor : UIColor = UIColor.darkGray
    var lineColor : UIColor = UIColor.darkGray
    let border = CALayer()
    var lineHeight : CGFloat = CGFloat(1.0)
    
    var conviencefee = Int()
    var gst = Int()
    
    var paymentArray = [String:Any]()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        guestDetails = [[String: AnyObject]](repeating: [:], count: finalRooms.count)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        myselfOnPress(btnMySelf)
        hotelConfirmBookingVCDelegate = self
        //self.txtTitle.delegate = self
        self.setupData()
        self.setupTableView()
        btnMySelf.isHidden = UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true
        btnSomeOneElse.isHidden = UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true
        cnstHeightSomeElse.constant = UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true ? 0 : 40
        cnstHeightMySelf.constant = UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true ? 0 : 40
        LoaderClass.shared.txtFldborder(txtFld: txtName)
        LoaderClass.shared.txtFldborder(txtFld: txtEmail)
        LoaderClass.shared.txtFldborder(txtFld: txtContactNumber)
        LoaderClass.shared.txtFldborder(txtFld: txtTitle)
        LoaderClass.shared.txtFldborder(txtFld: txtGst)
        LoaderClass.shared.txtFldborder(txtFld: txtCompanyName)
        LoaderClass.shared.txtFldborder(txtFld: txtFldGstPhone)
        LoaderClass.shared.txtFldborder(txtFld: txtCompanyAddress)
        LoaderClass.shared.txtFldborder(txtFld: txtFldGstEmail)
        lblPromoCode.text = UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true ? "Login to access amazing offers" : "Promo-code/Bank offers"
        lblGST.text = "₹\(gst)"
        lblConvenienceFee.text = "₹\(conviencefee)"
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Strings.CONTENT_SIZE {
            if let newvalue = change?[.newKey] {
                _  = newvalue as! CGSize
                DispatchQueue.main.async {
                    self.tableviewHeight.constant = CGFloat((self.hotleRate?.sBoardingDetails.count ?? 0)*20)
                    self.cnstTblRoomsHeight.constant = CGFloat((self.finalRooms.count-1)*175)
                }
            }
        }
    }
    //MARK: - Custom methods
    func setupData() {
        self.lblNoOfNight.text = "\(self.no_of_nights) \(self.no_of_nights > 1 ? "Nights" : "Night")"
        
        let hotel: Hotels?
        hotel = self.hotels
        lblRoomName.text = hotels?.iMinRate.sRooms[0].sRoomType.capitalized
        lblRoomAndNight.text = "\(totalRooms) \(totalRooms == "1" ? "Room" : "Rooms") * \(self.no_of_nights) \(no_of_nights > 1 ? "Nights" : "Night") \nBase Price"
        if let address = hotel?.sAddress {
            self.lblHotelAddress.text = address
        }
        if let name = hotel?.sName {
            self.lblHotelName.text = name
        }
        
        self.imgHotel.sd_setImage(with: URL(string: self.hotelDetail?.sImageUrl ?? ""), placeholderImage: .placeHolder())
        
        self.lblCheckInDate.text = self.checkInDate
        self.lblCheckOutDate.text = self.checkOutDate
        
        self.lblGuestAndRoom.text = "\(self.totalGuest) Guests/\(self.totalRooms) Room"
        self.lblTotalGuest.text = "\(self.totalGuest) Adults"
        
        var tax1 = Int()
        if let price = self.hotleRate?.sPrice as? Double {
            for i in 0..<markups.count {
                let markup: Markup?
                markup = markups[i]
                
                if markup?.starRating == hotel?.iCategory {
                    
                    if markup?.amountBy == Strings.PERCENT {
                        print("base price \(price)")
                        tax1 = Int(((price * (markup?.amount ?? 0) / 100) * 18) / 100)
                        //print("tax amount \(tax)")
                        // price += (price * (markup?.amount ?? 0) / 100) + tax
                        tax1 = Int(((price * (markup?.amount ?? 0) / 100) + Double(tax1)).rounded())
                        
                    } else {
                        print("base price \(price)")
                        tax1 = Int(((markup?.amount ?? 0)  * 18) / 100)
                        // price += (markup?.amount ?? 0) + tax
                        tax1 = Int(((markup?.amount ?? 0) + Double(tax1)).rounded())
                    }
                }
            }
            
            self.lblPrice.text = "₹\(String(format: "%.1f", Double(Int((price) - self.discount) + self.gst + self.conviencefee + tax1)))"
            
        }
        
        if let rating = hotel?.iCategory {
            self.lblRate.text = "\(rating)/5"
        }
        
        self.setupPriceDetails(priceDetails: self.hotleRate!)
    }
    
    func setupPriceDetails(priceDetails: HotelRate) {
        
        if priceDetails.sCancellationPolicy.count > 0 {
            if let details = hotleRate?.sCancellationPolicy[WSResponseParams.WS_RESP_PARAM_DETAILS] as? [[String: AnyObject]], details.count > 0 {
                
                _ = hotleRate?.sCancellationPolicy[WSResponseParams.WS_RESP_PARAM_UNDER_CANCELLATION] as? Bool
                
                for detail in details {
                    flatFee = detail[WSResponseParams.WS_RESP_PARAM_PRICE] as? Int ?? 0
                    self.lblBasePrice.text = "₹\(Double(flatFee))"
                }
            }
        }
      //  let tax = priceDetails.sServiceFee + priceDetails.sGSTPrice
        self.lblBasePrice.text = "₹\(String(format: "%.0f", (priceDetails.sPrice)-(priceDetails.sServiceFee + priceDetails.sGSTPrice).rounded()))"
        self.lblTax.text = "₹"
        self.lblDiscount.text = "₹\(String(format: "%.0f", discount))"
        
        self.lblServiceFee.text = "₹\(String(format: "%.0f", taxes))"
        self.lblPriceAfterDiscount.text = "₹\(round(priceDetails.sBasePrice))"
        
        self.lblTotalAmountPaid.text = "₹\(String(format: "%.0f", Double(Int(((priceDetails.sPrice)-(priceDetails.sServiceFee + priceDetails.sGSTPrice).rounded()) - self.discount + taxes) + self.gst + self.conviencefee).rounded()))"
        self.totalAmount = Double(Int(((priceDetails.sPrice)-(priceDetails.sServiceFee + priceDetails.sGSTPrice).rounded()) - self.discount  + taxes) + self.gst + self.conviencefee)
    }
        
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tblVwRooms.ragisterNib(nibName: "HotelGuestInfo")
        self.tableView.ragisterNib(nibName: HotelfacilityXIB().identifire)
        self.tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
        
        if self.hotleRate?.sNonRefundable ?? false == true{
            if self.hotleRate?.sBoardingDetails.contains(Strings.Non_Refundable) == true || self.hotleRate?.sBoardingDetails.contains(Strings.REFUNDABLE) == true{
            }else{
                self.hotleRate?.sBoardingDetails.append(Strings.Non_Refundable)
            }
            self.tableView.reloadData()
            self.tblVwRooms.reloadData()
        }
        
    }
    
    //MARK: - @IBActions
    @IBAction func actionCancellationPolicy(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .HotelCancellationPolicyVC, StoryboardName: .Hotels) as? HotelCancellationPolicyVC {
            var cancellationText = String()
            //            let hotleRate = self.hotelDetail?.rates[sender.tag]
            //            var cancellationText = String()
            // Cancellation Policy
            if hotleRate?.sNonRefundable != nil {
                if hotleRate?.sNonRefundable == true {
                    cancellationText = "Non-refundable. If you choose to change or cancel this booking you will not be refunded any of the payment."
                } else if hotleRate?.sNonRefundable == false {
                    guard let cancelByDate = hotleRate?.sCancellationPolicy[WSResponseParams.WS_RESP_PARAM_CANCEL_BY_DATE] as? String else { return }
                    
                    cancellationText = "\u{2022} Full refund if you cancel this booking by \(getCancellationDate(date: cancelByDate)).\n\n \u{2022} First night cost (including taxes and fees) will be charged if you cancel this booking later than \((getCancellationDate(date: cancelByDate))).\n\n \u{2022} You might be charged upto the full cost of stay (including taxes & fees) if you do not check-in to the hotel.\n\n"
                }
                
                if hotleRate?.sCancellationPolicy != nil {
                    if let details = hotleRate?.sCancellationPolicy[WSResponseParams.WS_RESP_PARAM_DETAILS] as? [[String: AnyObject]], details.count > 0 {
                        
                        let underCancellation = hotleRate?.sCancellationPolicy[WSResponseParams.WS_RESP_PARAM_UNDER_CANCELLATION] as? Bool
                        var cancellationText = ""
                        
                        if underCancellation == true {
                            cancellationText += "\u{2022} This booking is under cancellation and you have to pay charges\n\n"
                        }
                        
                        for detail in details {
                            let percent = detail[WSResponseParams.WS_RESP_PARAM_PERCENT] as? Int
                            let flatFee = detail[WSResponseParams.WS_RESP_PARAM_FLAT_FEE] as? Int
                            let currency = detail[WSResponseParams.WS_RESP_PARAM_CURRENCY_LOWERCASED] as? String
                            let fromDate = detail[WSResponseParams.WS_RESP_PARAM_FROM] as? String
                            let nights = detail[WSResponseParams.WS_RESP_PARAM_NIGHTS] as? Int
                            
                            if fromDate != nil && nights != nil {
                                cancellationText += "\u{2022} Cancellation charges are as per \(nights ?? 0) night from \(getCancellationDate(date: fromDate ?? "")).\n\n"
                            }
                            else if fromDate != nil && percent != nil {
                                cancellationText += "\u{2022} Cancellation charges are \(percent ?? 0) percent from \(getCancellationDate(date: fromDate ?? "")).\n\n"
                            }
                            else if flatFee != nil && currency != nil && fromDate != nil {
                                cancellationText += "\u{2022} If you cancel this booking by \(getCancellationDate(date: fromDate ?? "")) cancellation charges will be \(currency ?? "") \(flatFee ?? 0).\n\n"
                            }
                            else if flatFee != nil && currency != nil {
                                cancellationText += "\u{2022} Cancellation charges will be \(currency ?? "") \(flatFee ?? 0). \n\n"
                            }
                            else if currency != nil && percent != nil {
                                if percent == 100 {
                                    cancellationText += "\u{2022} Full refund if you cancel this booking by \(getCancellationDate(date: fromDate ?? "")).\n\n"
                                }
                                else {
                                    cancellationText += "\u{2022} Cancellation charges will be \(percent ?? 0) percent \(currency ?? "").\n\n"
                                }
                            }
                            
                        }
                    }
                }
            }
            vc.cancellationPolicy = cancellationText
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
    }
    @IBAction func offerOnPress(_ sender: UIButton) {
        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true {
            let vc = ViewControllerHelper.getViewController(ofType: .GuestLoginVC, StoryboardName: .Main) as! GuestLoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if let vc = ViewControllerHelper.getViewController(ofType: .CouponVC, StoryboardName: .Hotels) as? CouponVC {
                vc.isFromHotel = true
                self.present(vc, animated: true)
            }
        }
    }
    
    @IBAction func actionRemoveCoupon(_ sender: UIButton) {
        vwCouponApplied.isHidden = true
        self.discount = 0
        self.setupPriceDetails(priceDetails: self.hotleRate ?? HotelRate())
        
    }
    @IBAction func readAllViewOnPress(_ sender: UIButton) {
        
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
    
    @IBAction func someoneElseOnPress(_ sender: UIButton) {
        if sender.isSelected == false{
            sender.isSelected = true
            self.btnMySelf.isSelected = false
        }
        self.someoneElse()
    }
    
    @IBAction func haveGSTOnPress(_ sender: UIButton) {
        if sender.isSelected == false{
            sender.isSelected = true
            self.gstTextView.isHidden = false
            self.companyNameView.isHidden = false
            self.companyAddressView.isHidden = false
            self.vwCompanyPhone.isHidden = false
            self.vwCompanyEmail.isHidden = false
        }else{
            sender.isSelected = false
            self.companyNameView.isHidden = true
            self.companyAddressView.isHidden = true
            self.gstTextView.isHidden = true
            self.vwCompanyPhone.isHidden = true
            self.vwCompanyEmail.isHidden = true
        }
    }
    
    @IBAction func myselfOnPress(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.btnSomeOneElse.isSelected = false
        }
        self.mySelf()
    }
    
    @IBAction func payOnPress(_ sender: UIButton) {
        if self.isValid(){
           // self.guestDetails.removeAll()
            let firstName = self.txtName.text?.components(separatedBy: " ").count ?? 0 > 0 ? self.txtName.text?.components(separatedBy: " ")[0] : self.txtName.text ?? ""
            let lastName = self.txtName.text?.components(separatedBy: " ").count ?? 0 > 1 ? self.txtName.text?.components(separatedBy: " ")[1] : self.txtName.text ?? ""
            
            self.guestDetails[0][CommonParam.TITLE] = "\(self.txtTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")."
            self.guestDetails[0][CommonParam.TYPE] = "AD"
            self.guestDetails[0][CommonParam.NAME] = firstName
            self.guestDetails[0][WSRequestParams.WS_REQS_PARAM_SURNAME] = lastName
            
            if btnCheckGST.isSelected {
                self.guestDetails[0][WSRequestParams.WS_REQS_PARAM_GST_COMPANY_NAME] = txtCompanyName.text!
                self.guestDetails[0][WSRequestParams.WS_REQS_PARAM_GST_NUMBER] = txtGst.text!
                self.guestDetails[0][WSRequestParams.WS_REQS_PARAM_GST_COMPANY_EMAIL.capitalized] = txtFldGstEmail.text!
                self.guestDetails[0][WSRequestParams.WS_REQS_PARAM_GST_COMPANY_ADDRESS] = txtCompanyAddress.text!
                self.guestDetails[0][WSRequestParams.WS_REQS_PARAM_GST_COMPANY_CONTACT_NO] = txtContactNumber.text!
            }
            
            paymentArray = [
                "base_fare":"\(hotleRate?.sBasePrice.rounded() ?? 0.0)",
                "coupon_amount": "\(discount)",
                "coupon_id":"\(couponId)",
                "markup": "0",
                "markup_cgst_9" : "0",
                "markup_igst_18" : "0",
                "markup_sgst_9": "0",
                "service_charge": "\(self.conviencefee)",
                "service_charge_cgst_9": "\(gst/2)",
                "service_charge_igst_18": "\(gst)",
                "service_charge_sgst_9": "\(gst/2)",
                "total_amount": "\(self.totalAmount)"
            ]
            
            if let vc = ViewControllerHelper.getViewController(ofType: .WalletPaymentVC, StoryboardName: .Main) as? WalletPaymentVC {
                vc.payblePayment = self.lblTotalAmountPaid.text ?? ""
                vc.screenFrom = .hotel
                vc.viewModel.busPaymentArray = paymentArray
                vc.amount = self.totalAmount
                vc.logId = self.logId
                vc.searchId = self.searchId
                vc.checkIn = self.checkIn
                vc.checkOut = self.checkOut
                vc.hotelDetail = self.hotelDetail
                vc.hotleRate = self.hotleRate
                vc.guestDetails = self.guestDetails
                vc.couponCode = couponCode
                vc.couponId = couponId
                vc.hotelEmail = txtEmail.text ?? ""
                vc.hotelPhone = txtContactNumber.text ?? ""
                self.pushView(vc: vc)
            }
        }
    }
    
    func isValid() -> Bool {
        if self.btnMySelf.isSelected == false && self.btnSomeOneElse.isSelected == false {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.BOOKING_FOR)
            return false
        } else if self.txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.FULL_NAME)
            return false
        } else if self.txtContactNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.MOBILE)
            return false
        } else if self.txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.EMAIL_ENTER)
            return false
        } else if self.txtEmail.text?.isValidEmail() == false {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.VALID_EMAIL)
            return false
        } else if self.btnCheckGST.isSelected && self.txtGst.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.GST)
            return false
        } else if self.btnCheckGST.isSelected && txtGst.text?.count ?? 0 < 15 {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.VALID_GST)
            return false
        } else if self.btnCheckGST.isSelected && txtCompanyName.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.COMPANY_NAME)
            return false
        } else if self.btnCheckGST.isSelected && txtCompanyAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.COMPANY_ADDRESS)
            return false
        } else if self.btnCheckGST.isSelected && txtFldGstEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.COMPANY_EMAIL)
            return false
        } else if self.btnCheckGST.isSelected && txtFldGstEmail.text?.isValidEmail() == false  {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.VALID_COMPANY_EMAIL)
            return false
        } else if self.btnCheckGST.isSelected && txtFldGstPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.COMPANY_PHONE)
            return false
        } else {
            return true
        }
    }
    
    //MARK: Setup My Self Data
    func mySelf() {
        self.txtName.text = Cookies.userInfo()?.name
        self.txtEmail.text = Cookies.userInfo()?.email
        self.txtContactNumber.text = Cookies.userInfo()?.mobile
        
        self.guestDetails[0][CommonParam.TITLE] = txtTitle.text ?? ""
        self.guestDetails[0][CommonParam.TYPE] = "AD"
        self.guestDetails[0][CommonParam.NAME] =  self.txtName.text?.components(separatedBy: " ").count ?? 0 > 1 ? self.txtName.text?.components(separatedBy: " ")[0] ?? "" : self.txtName.text!
        self.guestDetails[0][WSRequestParams.WS_REQS_PARAM_SURNAME] =  self.txtName.text?.components(separatedBy: " ").count ?? 0 > 1 ? self.txtName.text?.components(separatedBy: " ")[1] ?? "" : ""
    }

    func someoneElse() {
        self.txtName.text = ""
        self.txtEmail.text = ""
        self.txtContactNumber.text = ""
    }
}

extension HotelConfirmBookingVC: HotelConfirmBookingVCDelegate {
    func applyCoupon(discount: Double, couponCode: String, couponId: Int) {
        self.discount = discount
        self.couponCode = couponCode
        self.couponId = couponId
        self.lblCouponName.text = couponCode
        self.vwCouponApplied.isHidden = false
        let vc = ViewControllerHelper.getViewController(ofType: .CouponAppliedVC, StoryboardName: .Bus) as! CouponAppliedVC
        vc.couponPrize = "\(Int(discount))"
        self.present(vc, animated: true)
        self.setupPriceDetails(priceDetails: self.hotleRate ?? HotelRate())
    }
}

extension HotelConfirmBookingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == tblVwRooms ? finalRooms.count-1 : self.hotleRate?.sBoardingDetails.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVwRooms {
            let cell = tblVwRooms.dequeueReusableCell(withIdentifier: "HotelGuestInfo", for: indexPath) as! HotelGuestInfo
            cell.txtFirstName.delegate = self
            cell.txtLastName.delegate = self
            cell.txtTitle.delegate = self
            cell.txtFirstName.tag = indexPath.row
            cell.txtLastName.tag = indexPath.row
            cell.txtTitle.tag = indexPath.row
            cell.lblRoomInfo.text = "Room \(indexPath.row+2) Guest Detail"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: HotelfacilityXIB().identifire, for: indexPath) as! HotelfacilityXIB
            cell.lblTitle.text = self.hotleRate?.sBoardingDetails[indexPath.row]
            
            if self.hotleRate?.sBoardingDetails[indexPath.row] == Strings.Non_Refundable{
                cell.lblTitle.textColor = .cutomRedColor()
                cell.dotView.backgroundColor = .cutomRedColor()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == tblVwRooms ? 175 : 20
    }
}

extension HotelConfirmBookingVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if finalRooms.count-1 > 0 {
            let indexpath = IndexPath(row: textField.tag, section: 0)
            let cell = tblVwRooms.cellForRow(at: indexpath) as! HotelGuestInfo
            if textField == self.txtTitle || textField == cell.txtTitle {
                self.openDropDown(textField, nil)
                cell.vwUnderline[0].backgroundColor = .customPink()
                cell.vwUnderline[1].backgroundColor = .darkGray
                cell.vwUnderline[2].backgroundColor = .darkGray
            } else if textField == cell.txtFirstName {
                cell.vwUnderline[0].backgroundColor = .darkGray
                cell.vwUnderline[2].backgroundColor = .customPink()
                cell.vwUnderline[1].backgroundColor = .darkGray
            } else if textField == cell.txtLastName {
                cell.vwUnderline[0].backgroundColor = .darkGray
                cell.vwUnderline[1].backgroundColor = .customPink()
                cell.vwUnderline[2].backgroundColor = .darkGray
            } else {
                border.borderColor = UIColor.customPink().cgColor
                border.frame = CGRect(x: 0, y: textField.frame.size.height - lineHeight, width:  textField.frame.size.width, height: textField.frame.size.height)
                border.borderWidth = lineHeight
                textField.layer.addSublayer(border)
                textField.layer.masksToBounds = true
            }
        } else {
            if textField == self.txtTitle {
                self.openDropDown(textField, nil)
            }
            border.borderColor = UIColor.customPink().cgColor
            border.frame = CGRect(x: 0, y: textField.frame.size.height - lineHeight, width:  textField.frame.size.width, height: textField.frame.size.height)
            border.borderWidth = lineHeight
            textField.layer.addSublayer(border)
            textField.layer.masksToBounds = true
        }
    }
    
    func openDropDown(_ textfield: UITextField, _ cellIndex : Int?) {
        textfield.resignFirstResponder()
        self.titleDropDown.textColor = UIColor.black
        self.titleDropDown.textFont = .boldFont(size: 14)
        self.titleDropDown.backgroundColor = UIColor.white
        self.titleDropDown.anchorView = textfield
        self.titleDropDown.dataSource = GetData.share.getUserTitle()
        self.titleDropDown.bottomOffset = CGPoint(x: 0, y:(self.titleDropDown.anchorView?.plainView.bounds.height)!)
        
        self.titleDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            textfield.text = item
            textfield.resignFirstResponder()
        }
        self.titleDropDown.show()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtGst {
            let newText = (txtGst.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            if newText.count > 15 {
                return false
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if finalRooms.count-1 > 0 {
            let indexpath = IndexPath(row: textField.tag, section: 0)
            let cell = tblVwRooms.cellForRow(at: indexpath) as! HotelGuestInfo
            if textField == cell.txtTitle {
                cell.vwUnderline[0].backgroundColor = .darkGray
                self.guestDetails[textField.tag+1][CommonParam.TITLE] = cell.txtTitle.text ?? ""
            } else if textField == cell.txtFirstName {
                cell.vwUnderline[2].backgroundColor = .darkGray
                self.guestDetails[textField.tag+1][CommonParam.NAME] = textField.text ?? ""
                self.guestDetails[textField.tag+1]["value"] = "AD"
            } else if textField == cell.txtLastName {
                cell.vwUnderline[1].backgroundColor = .darkGray
                self.guestDetails[textField.tag+1][WSRequestParams.WS_REQS_PARAM_SURNAME] = textField.text ?? ""
            }
        } else {
            let firstName = self.txtName.text?.components(separatedBy: " ").count ?? 0 > 0 ? self.txtName.text?.components(separatedBy: " ")[0] : self.txtName.text ?? ""
            let lastName = self.txtName.text?.components(separatedBy: " ").count ?? 0 > 1 ? self.txtName.text?.components(separatedBy: " ")[1] : self.txtName.text ?? ""
            
            self.guestDetails[0][CommonParam.TITLE] = "\(self.txtTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")."
            self.guestDetails[0][CommonParam.TYPE] = "AD"
            self.guestDetails[0][CommonParam.NAME] = firstName
            self.guestDetails[0][WSRequestParams.WS_REQS_PARAM_SURNAME] = lastName
            
            border.borderColor = UIColor.darkGray.cgColor
            border.frame = CGRect(x: 0, y: textField.frame.size.height - lineHeight, width:  textField.frame.size.width, height: textField.frame.size.height)
            border.borderWidth = lineHeight
            textField.layer.addSublayer(border)
            textField.layer.masksToBounds = true
        }
        self.tableView.reloadData()
    }
}
