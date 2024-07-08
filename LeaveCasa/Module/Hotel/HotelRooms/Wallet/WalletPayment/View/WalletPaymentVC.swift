//
//  WalletPaymentVC.swift
//  LeaveCasa
//
//  Created by acme on 30/09/22.
//

import UIKit
import IBAnimatable
import Razorpay

enum ScreenFrom {
    case bus
    case flight
    case hotel
}

class WalletPaymentVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var cnstLoginBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var cnstWalletBalanceVw: NSLayoutConstraint!
    @IBOutlet weak var btnCheckWallet: UIButton!
    @IBOutlet weak var lblAmountPaid: UILabel!
    @IBOutlet weak var btnLoginNow: UIButton!
    @IBOutlet weak var lblWalletBalance: UILabel!
    @IBOutlet weak var btnPay: AnimatableButton!
  //  @IBOutlet weak var vwWallet: UIView!
    @IBOutlet weak var cnstTrailingLoginNow: NSLayoutConstraint!
  //  @IBOutlet weak var lblWalletBalanceTotal: UILabel!
    //MARK: - Variables
    typealias Razorpay = RazorpayCheckout
    var razorpay: RazorpayCheckout!
    var viewModel = WalletPaymentViewModel()
    var objSelectFareVM = SelectFareViewModel()
    var payblePayment = ""
    var isWallet = false
    var amount = Double()
    
    var hotelDetail : HotelDetail?
    var hotleRate : HotelRate?
    var searchId = ""
    var hotelEmail = String()
    var hotelPhone = String()
    
    var logId = 0
    var token = ""
    var tracID = ""
    var pnr = ""
    var couponCode = ""
    var couponId = 0
    var bookingID = ""
    var checkIn = ""
    var checkOut = ""
    var guestDetails = [[String:Any]]()
    
    var params = [String:AnyObject]()
    var screenFrom = ScreenFrom.hotel
    var param = [String:Any]()
    var busRecepientMail = String()
    var busRecepientPhone = String()
    var viewModelWallet = WalletViewModel()
    var ssrModel : SsrFlightModel?
    var dataFlight = Flight()
    var returnResultIndex:String?
    var passengerEmail = String()
    var passengerPhone = String()
    var passengerName = String()
    var publishedFare = Double()
    var objPassangerDetailsViewModel = PassangerDetailsViewModel()
    var paymentID = String()
    
    var mealAmt = Double()
    var seatAmt = Double()
    var bagaggeAmt = Double()
    var couponAmt = Double()
    var baseAmt = Double()
    
    //MARK: - Custom methods
    internal func showPaymentForm(currency : String, amount: Double, name: String, description : String, contact: String, email: String ,isForWallet:Bool = false){
        let options: [String:Any] = [
            "amount": "\(amount * 100)", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": "INR",//We support more that 92 international currencies.
            //                    "description": description,
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
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.objSelectFareVM.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.viewModelWallet.delegate = self
        self.razorpay = RazorpayCheckout.initWithKey(RazorpayKeys.Test, andDelegate: self)
        self.viewModel.delegate = self
        if payblePayment == "" {
            payblePayment = "\(amount)"
        }
        self.setupView()
        lblWalletBalance.text = UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true ? "Login to access Wallet" : "If payment exceeds wallet balance, rest of the amount will need to paid through regular payment method."
    }
    
    //MARK: - Custom methods
    func setupView(){
        self.lblAmountPaid.text = self.payblePayment.contains("₹") ? "\(self.payblePayment)" : "₹\(self.payblePayment)"
    }
    //MARK: - @IBActions
    @IBAction func actionLoginNow(_ sender: Any) {
        let vc = ViewControllerHelper.getViewController(ofType: .GuestLoginVC, StoryboardName: .Main) as! GuestLoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func walletCheckOnPress(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isWallet = !self.isWallet
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
    
    @IBAction func payOnPress(_ sender: UIButton) {
        if self.screenFrom == .flight {
            if GetData.share.isOnwordBook() == true {
                self.objSelectFareVM.getFareSSR(traceId: self.tracID, tokenId: self.token, logId: "\(self.logId)", resultIndex: returnResultIndex ?? "" , view: self)
            } else {
                self.objSelectFareVM.getFareSSR(traceId: self.tracID, tokenId: self.token, logId: "\(self.logId)", resultIndex: dataFlight.sResultIndex, view: self)
            }
        } else {
            afterSSR()
        }
    }
}

extension WalletPaymentVC:ResponseProtocol {
    func onSuccessDebitWallet() {
        if self.screenFrom == .bus {
            self.params[WSRequestParams.WS_REQS_PARAM_CUSTOMER_ID] = (UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false ? Cookies.userInfo()?.id : 0) as AnyObject
            self.params[WSResponseParams.WS_RESP_PARAM_LOGID] = self.logId as AnyObject
            self.params["recipient_email"] = self.busRecepientMail as AnyObject
            self.params["recipient_phone"] = self.busRecepientPhone as AnyObject
            self.viewModel.callBusBookingApi(param: params,view: self)
        } else if self.screenFrom == .flight {
            if self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
                LoaderClass.shared.loadAnimation()
                self.param[WSRequestParams.WS_REQS_PARAM_PAYMENTID] = "debited by wallet"
                self.param[WSRequestParams.WS_REQS_PARAM_CUSTOMER_ID] = UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false ? Cookies.userInfo()?.id ?? 0 : 0
                self.param[WSRequestParams.WS_REQS_PARAM_RECIPIENT_EMAIL] = passengerEmail
                self.param[WSRequestParams.WS_REQS_PARAM_RECIPIENT_PHONE] = passengerPhone
                
                DispatchQueue.main.async {
                    self.viewModel.callLccFlightTicketBook(param: self.param, view: self)
                }
            } else {
                let param = [WSRequestParams.WS_REQS_PARAM_RECIPIENT_EMAIL: passengerEmail,
                             WSRequestParams.WS_REQS_PARAM_RECIPIENT_PHONE: passengerPhone,
                             WSResponseParams.WS_RESP_PARAM_TOKEN:self.token,
                             WSResponseParams.WS_RESP_PARAM_TRACE_ID:self.tracID,
                             WSResponseParams.WS_RESP_PARAM_LOGID:self.logId,
                             WSResponseParams.WS_RESP_PARAM_BOOKING_ID:self.bookingID,
                             WSResponseParams.WS_RESP_PARAM_PNR:self.pnr,
                             WSRequestParams.WS_REQS_PARAM_CUSTOMER_ID:UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false ? Cookies.userInfo()?.id ?? 0 : 0,
                             WSRequestParams.WS_REQS_PARAM_PAYMENTID:"debited by wallet"] as [String : Any]
                self.viewModel.callNonLccFlightTicketBook(param: param, view: self)
            }
        }
    }
    
    func onSuccess() {
//        if self.viewModel.isFetchBalance {
//            if !self.isWallet {
//                self.lblWalletBalanceTotal.text = "₹\(String(format: "%.1f", self.viewModel.available_balance))"
//            }
//        } else {
            LoaderClass.shared.loadAnimation()
            if self.objSelectFareVM.ssrModel?.fare_rule?.response?.responseStatus == 1 {
                //Base fare == 0 : Implement the check
                if self.objSelectFareVM.ssrModel?.fare_quote?.response?.isPriceChanged == true {
                    
                    
                    //Show Alert
                    if self.objSelectFareVM.ssrModel?.fare_quote?.response?.fareQuoteResult?.fare?.publishedFare != self.publishedFare {
                        LoaderClass.shared.stopAnimation()
                        Alert.showAlertWithOkCancel(message: "The price is changed for selected flight from \(self.objSelectFareVM.ssrModel?.fare_quote?.response?.fareQuoteResult?.fare?.publishedFare ?? 0.0) to \(self.publishedFare). Would you like to continue ?", actionOk: "Continue", actionCancel: "Change Fare") {
                            //Call everything after SSR
                            self.afterSSR()
                        } completionCancel: {
                            self.pushNoInterConnection(view: self,titleMsg: "To be implemented!", msg: "Alert")
                        }
                    }
                } else {
                    //Call everything after SSR
                    self.afterSSR()
                }
            } else {
                pushNoInterConnection(view: self,titleMsg: self.objSelectFareVM.ssrModel?.fare_quote?.response?.error?.errorMessage ?? "", msg: "Alert")
                
            }
      //  }
    }
    
    func onFlightReload() {
        let param = [WSRequestParams.WS_REQS_PARAM_RECIPIENT_EMAIL: passengerEmail,
                     WSRequestParams.WS_REQS_PARAM_RECIPIENT_PHONE: passengerPhone,
                     WSResponseParams.WS_RESP_PARAM_TOKEN:self.token,
                     WSResponseParams.WS_RESP_PARAM_TRACE_ID:self.tracID,
                     WSResponseParams.WS_RESP_PARAM_LOGID:self.logId,
                     WSResponseParams.WS_RESP_PARAM_BOOKING_ID:self.bookingID,
                     WSResponseParams.WS_RESP_PARAM_PNR:self.pnr,
                     WSRequestParams.WS_REQS_PARAM_CUSTOMER_ID:UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false ? Cookies.userInfo()?.id ?? 0 : 0,
                     WSRequestParams.WS_REQS_PARAM_PAYMENTID:self.paymentID] as [String : Any]
        self.viewModel.callNonLccFlightTicketBook(param: param, view: self)
    }
    
    func afterSSR(){
        LoaderClass.shared.stopAnimation()
//        if self.isWallet == true && self.viewModel.available_balance > Double(self.amount){
//            let param = [WSRequestParams.WS_REQS_PARAM_DEBIT_AMOUNT: Int(self.amount),CommonParam.TYPE:"debited by wallet",WSResponseParams.WS_RESP_PARAM_LOGID:self.logId] as [String : Any]
//            //self.viewModel.callDebitWalletAmount(param: param, view: self,isDebit:true)
//
//        }else if self.isWallet == true && self.viewModel.available_balance < Double(self.amount){
//            self.isWallet = true
        //            self.showPaymentForm(currency: "INR", amount: (Double(self.amount) - self.viewModel.available_balance), name: passengerName, description: "", contact: passengerPhone, email: passengerEmail)
        //        }else{
        self.showPaymentForm(currency: "INR", amount: self.amount, name: passengerName, description: "", contact: passengerPhone, email: passengerEmail)
       // self.onSuccessDebitWallet()
        
        //        }
    }
}

extension WalletPaymentVC : RazorpayPaymentCompletionProtocol {
    
    func onPaymentError(_ code: Int32, description str: String) {
        debugPrint("error: ", code, str)
        pushNoInterConnection(view: self,titleMsg: "Alert", msg: str)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        debugPrint("success: ", payment_id)
        self.paymentID = payment_id
       
        if self.screenFrom == .bus {
            self.params[WSRequestParams.WS_REQS_PARAM_CUSTOMER_ID] = (UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false ? Cookies.userInfo()?.id : 0) as AnyObject
            self.params[WSResponseParams.WS_RESP_PARAM_LOGID] = self.logId as AnyObject
            self.params["recipient_email"] = self.busRecepientMail as AnyObject
            self.params["recipient_phone"] = self.busRecepientPhone as AnyObject
            self.viewModel.callBusBookingApi(param: params,view: self)
        }
        else if self.screenFrom == .flight {
           let userArray = [
                "email": passengerEmail,
                "phone": passengerPhone,
                "name": passengerName]
            let paymentArray = [
                "baggage_amount": "\(bagaggeAmt)",
                "base_fare":"\(baseAmt)",
                "coupon_amount": "\(couponAmt)",
                "coupon_id": "\(couponId)",
                "markup": "0",
                "markup_cgst_9": "0",
                "markup_igst_18": "0",
                "markup_sgst_9": "0",
                "meal_amount": "\(mealAmt)",
                "seat_amount": "\(seatAmt)",
                "service_charge": "236",
                "service_charge_cgst_9": "18",
                "service_charge_igst_18": "36",
                "service_charge_sgst_9": "18",
                "total_amount": "\(payblePayment)"]
            
            
                LoaderClass.shared.loadAnimation()
                self.param[WSRequestParams.WS_REQS_PARAM_RECIPIENT_EMAIL] = passengerEmail
                self.param[WSRequestParams.WS_REQS_PARAM_RECIPIENT_PHONE] = passengerPhone
                self.param[WSRequestParams.WS_REQS_PARAM_PAYMENTID] = payment_id
                self.param[WSRequestParams.WS_REQS_PARAM_CUSTOMER_ID] = UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false ? Cookies.userInfo()?.id ?? 0 : 0
                self.param[WSRequestParams.WS_REQS_PARAM_PAYMENT_ARRAY] = paymentArray
                self.param[WSRequestParams.WS_REQS_PARAM_USER_ARRAY] = userArray
            if self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
                self.viewModel.callLccFlightTicketBook(param: self.param, view: self)
            } else if self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == false {
                objPassangerDetailsViewModel.flightBook(param: self.param, view: self, flightData: dataFlight , token: self.token, traceID: self.tracID, logID: logId, amount: self.amount, ssrModel: self.ssrModel!)
            }
        } else {
            self.viewModel.callHotelBookingApi(hotelDetail: hotelDetail ?? HotelDetail(), guestDetails: guestDetails, room_Ref: hotleRate?.sRooms.first?.sRoomRef ?? "", selectedRoomRate: 0, checkIn: checkIn, checkOut: checkOut, logId: "\(logId)", searchId: searchId, couponId: couponId, couponCode: couponCode, view: self, email: hotelEmail, phoneNumber: hotelPhone)
        }
    }
}

extension WalletPaymentVC: RazorpayPaymentCompletionProtocolWithData {
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        debugPrint("error: ", code)
        pushNoInterConnection(view: self,titleMsg: "Alert", msg: str)
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        debugPrint("success: ", payment_id)
    }
}
