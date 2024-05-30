//
//  PassangerDetailsVC.swift
//  LeaveCasa
//
//  Created by acme on 20/12/22.
//

import UIKit
import DropDown
import SKCountryPicker
import IBAnimatable
import SearchTextField

//protocol PassangerDetailsVCDelegate {
//    func fetchExistingCustomers(_ passangerDetails: PassangerDetails, selectedIndex: Int)
//}
//
//var passangerDetailsVCDelegate: PassangerDetailsVCDelegate?

class PassangerDetailsVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblSourceDestination: UILabel!
    @IBOutlet weak var cnstTblVwPassTop: NSLayoutConstraint!
    @IBOutlet weak var tblVwHeight2: NSLayoutConstraint!
    @IBOutlet weak var tblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var tblVwFairDetail: UITableView!
    @IBOutlet weak var vwFareDetail: AnimatableView!
    @IBOutlet weak var imgVwDropDown: UIImageView!
    @IBOutlet weak var btnDone: AnimatableButton!
    @IBOutlet weak var tblVwPassenges: UITableView!
    //MARK: - Variables
    var ret = 0
    var passangerDetails = [PassangerDetails]()
    var passangerDetail = PassangerDetails()
    var passangerList = [FlightStruct]()
    var dataFlight = Flight()
    var numberOfAdults = 1
    var numberOfChildren = 0
    var numberOfInfants = 0
    var ssrData : SsrFlightModel?
    var mealCode = String()
    var mealDescription = String()
    var seatCode = String()
    var seatDescription = String()
    var logId = 0
    var tokenId = ""
    var traceId = ""
    var param = [String:Any]()
    var viewModel = PassangerDetailsViewModel()
    let dropDown = DropDown()
    var typeOfPassport = ""
    let country = CountryManager.shared.currentCountry
    var selectedIndex = -1
    var selectedPassenger = -1
    var isFirstClass = true
    var selectedTextFeild = SearchTextField()
    //Price Breakup
    var discount = Double()
    var totalPrice = String()
    var basePrice = Double()
    var convenientFee = Double()
    var baggagePrice = Double()
    var mealPrice = Double()
    var taxes = Double()
    var array = [FlightStruct]()
    var countryCode = "IN"
    let dateFormatter = DateFormatter()
    var returnDataFlight = [Flight]()
    
    //FareDetails
    var isDomasticRountTrip = false
    var dataFlight1 = [Flight]()
    var isMultiCity = false
    
    var isOpen = false
    var tblFareHeight = CGFloat()
    var returnResultIndex: String?
    
    var taxesK3 = Double()
    var conBirfurcation = Double()
    var isInsurance = Bool()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        lblSourceDestination.text = LoaderClass.shared.sourceSestination
        tblVwPassenges.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblVwFairDetail.addObserver(self, forKeyPath: "contentSize", options: .new, context: UnsafeMutableRawPointer(bitPattern: 1))
        
        lblTotalPrice.text = totalPrice.contains("₹") ? "₹\(LoaderClass.shared.commaSeparatedPrice(val:Int((totalPrice.components(separatedBy: ".").count > 0 ? totalPrice.components(separatedBy: ".")[0] : totalPrice).replacingOccurrences(of: "₹", with: "").replacingOccurrences(of: ",", with: "")) ?? 0))" : "₹\(LoaderClass.shared.commaSeparatedPrice(val:Int(totalPrice.components(separatedBy: ".").count > 0 ? totalPrice.components(separatedBy: ".")[0] : totalPrice) ?? 0))"
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        self.setupTableView()
        
        tblVwHeight.constant = 0
        
        if GetData.share.isOnwordBook() == true {
            LoaderClass.shared.numberOfAdults = numberOfAdults
            LoaderClass.shared.numberOfInfants = numberOfInfants
            LoaderClass.shared.numberOfChildren = numberOfChildren
        }
        
        
        let loopCount = self.numberOfAdults + self.numberOfInfants + self.numberOfChildren
        if !LoaderClass.shared.passengerReturn.isEmpty {
            numberOfAdults = LoaderClass.shared.numberOfAdults
            numberOfInfants = LoaderClass.shared.numberOfInfants
            numberOfChildren = LoaderClass.shared.numberOfChildren
            
            for at in 0..<((LoaderClass.shared.passengerReturn["Passengers"] as? [Any])?.count ?? 0)  {
                var passanger = PassangerDetails()
                if let passengers = LoaderClass.shared.passengerReturn["Passengers"] as? [[String: Any]] {
                    
                    passanger.firstName = passengers[at]["FirstName"] as! String
                    passanger.lastName = passengers[at]["LastName"] as! String
                    passanger.nationality = passengers[at]["Nationality"] as! String
                    passanger.gender = (passengers[at]["Gender"] as! Int) == 1 ? "Male" : "Female"
                    passanger.title = passengers[at]["Title"] as! String
                    passanger.saveUser = (passengers[at]["savepassenger"] as! String) == "no" ? false : true
                    passanger.address = passengers[at]["AddressLine1"] as! String
                    passanger.city = passengers[at]["City"] as! String
                    passanger.countryCode = passengers[at]["CountryCode"] as! String
                    passanger.paxType = passengers[at]["PaxType"] as! String
                    passanger.dob = passengers[at]["DateOfBirth"] as! String
                    passanger.country = passengers[at]["CountryName"] as! String
                    passanger.state = passengers[at]["State"] as! String
                    passanger.email = passengers[at]["Email"] as! String
                    passanger.ffAirline = passengers[at]["FFAirline"] as! String
                    passanger.ffNumber = passengers[at]["FFNumber"] as! String
                    passanger.mobile = passengers[at]["ContactNo"] as! String
                    passanger.countryMobileCode = LoaderClass.shared.ownwardMobileCode
                    
                    
                    passanger.isGST = passengers[0]["GSTCompanyAddress"] as? String != "" && passengers[0]["GSTCompanyAddress"] as? String != nil ? true : false
                    if passanger.isGST && at == 0 {
                        passanger.gstCompanyName = passengers[at]["GSTCompanyName"] as! String
                        passanger.gstAddress = passengers[at]["GSTCompanyAddress"] as! String
                        passanger.gstNumber = passengers[at]["GSTNumber"] as! String
                        passanger.gstCompanyEmail = passengers[at]["GSTCompanyEmail"] as! String
                        passanger.gstCompanyContactNumber = passengers[at]["GSTCompanyContactNumber"] as! String
                    }
                }
                self.passangerDetails.append(passanger)
            }
            
        } else {
            for at in 0..<loopCount {
                var passanger = PassangerDetails()
                
                if at+1 <= self.numberOfAdults {
                    passanger.paxType = "1"
                } else if at+1 > self.numberOfAdults && at+1 <= (self.numberOfAdults + self.numberOfChildren) {
                    passanger.paxType = "2"
                } else {
                    passanger.paxType = "3"
                }
                passanger.nationality = "IN"
                passanger.countryCode = "IN"
                passanger.countryMobileCode = "+91"
                LoaderClass.shared.ownwardMobileCode = "+91"
                passanger.country = "India"//country?.countryName ?? ""
                passanger.email = Cookies.userInfo()?.email ?? ""
                passanger.mobile = Cookies.userInfo()?.mobile ?? ""
                passanger.firstName = Cookies.userInfo()?.name.components(separatedBy: " ")[0] ?? ""
                passanger.lastName = Cookies.userInfo()?.name.components(separatedBy: " ").count ?? 0 > 1 ? Cookies.userInfo()?.name.components(separatedBy: " ")[1] ?? "" : Cookies.userInfo()?.name.components(separatedBy: " ")[0] ?? ""
                passanger.title = Cookies.userInfo()?.title ?? ""
                // passanger.dob = convertDateFormat(date: Cookies.userInfo()?.dob ?? "", getFormat: "MMM dd, yyyy", dateFormat: "yyyy-MM-dd")
                passanger.address = Cookies.userInfo()?.address ?? ""
                passanger.city = Cookies.userInfo()?.city ?? ""
                
                self.passangerDetails.append(passanger)
            }
        }
        self.viewModel.searchStateApi("IN", view: self)
        //MARK: GET PASSANGER LIST
        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false {
            DispatchQueue.background(background: {
                self.viewModel.getPassangerList(view: self)
            }, completion:{
                
            })
        }
        
        cnstTblVwPassTop.constant = -(tblFareHeight)
        
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tblVwPassenges.reloadData()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "contentSize" {
            
            if context == nil {
                if object is UITableView {
                    if let newValue = change?[.newKey]{
                        let newSize = newValue as! CGSize
                        self.tblVwHeight2.constant = newSize.height
                    }
                }
            } else {
                if object is UITableView {
                    if let newValue = change?[.newKey]{
                        let newSize = newValue as! CGSize
                        self.tblVwHeight.constant = newSize.height-15
                        self.tblFareHeight = newSize.height-15
                        cnstTblVwPassTop.constant = -(newSize.height-15)
                    }
                }
            }
        }
    }
    
    
    //MARK: - Custom methods
    func setupTableView() {
        self.tblVwPassenges.delegate = self
        self.tblVwPassenges.dataSource = self
        self.tblVwPassenges.tableFooterView = UIView()
        self.tblVwPassenges.ragisterNib(nibName: "PassangerDetailXIB")
        self.tblVwFairDetail.ragisterNib(nibName: FareFlightXIB().identifire)
        self.tblVwFairDetail.ragisterNib(nibName: FareFlightHeaderXIB().identifire)
    }
    
    //MARK: - @IBActions
    @IBAction func backOnPress(_ sender: UIButton) {
        
        self.popView()
    }
    @IBAction func actionFareBreakup(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .FareBrakeupVC, StoryboardName: .Flight) as? FareBrakeupVC {
            vc.discount = self.discount
            vc.basePrice = basePrice
            vc.convenientFee = convenientFee
            vc.taxes = taxes
            vc.taxesK3 = taxesK3
            vc.conBirfurcation = conBirfurcation
            self.present(vc, animated: true)
        }
    }
    @IBAction func actionDropDownUp(_ sender: UIButton) {
        if isOpen {
            imgVwDropDown.image = UIImage(named: "ic_dropDown")
            isOpen = false
            cnstTblVwPassTop.constant = -(self.tblFareHeight)
            tblVwFairDetail.isHidden = true
            
        } else {
            imgVwDropDown.image = UIImage(named: "ic_dropUp")
            tblVwFairDetail.isHidden = false
            cnstTblVwPassTop.constant = 20
            self.tblVwHeight.constant = self.tblFareHeight
            isOpen = true
        }
    }
    
    @IBAction func soneOnPress(_ sender: UIButton) {
        if isValidatePassanger() {
            if self.ssrData?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
                debugPrint("Its Direct Flight")
                
                self.param = [WSRequestParams.WS_REQS_PARAM_RECIPIENT_EMAIL: passangerDetails[0].email,
                              WSRequestParams.WS_REQS_PARAM_RECIPIENT_PHONE: passangerDetails[0].mobile,
                              WSResponseParams.WS_RESP_PARAM_LOGID:self.logId,
                              WSResponseParams.WS_RESP_PARAM_TOKEN:self.tokenId,
                              WSResponseParams.WS_RESP_PARAM_TRACE_ID:self.traceId,
                              WSResponseParams.WS_RESP_PARAM_RESULTS_INDEX:self.dataFlight.sResultIndex,
                              WSRequestParams.WS_REQS_PARAM_CUSTOMER_ID: UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false ? Cookies.userInfo()?.id ?? 0 : 0]
                //heree
                var Passengers = [[String:Any]]()
                var price = 0.0
                for (at,index) in self.passangerDetails.enumerated() {
                    var indexPassender = [WSRequestParams.WS_REQS_PARAM_TITLE.capitalized:index.title,
                                          WSResponseParams.WS_RESP_PARAM_FIRSTNAME:index.firstName,
                                          WSResponseParams.WS_RESP_PARAM_LASTNAME:index.lastName,
                                          WSRequestParams.WS_REQS_PARAM_PAX_TYPE:index.paxType,
                                          WSRequestParams.WS_REQS_PARAM_DATE_OF_BIRTH:index.dob,
                                          WSRequestParams.WS_REQS_PARAM_GENDER.capitalized: index.gender == "Male" ? 1 : 2,
                                          CommonParam.ADDRESS1: "Delhi",//index.address.isEmpty == true ? self.passangerDetails[at].address : index.address,
                                          WSResponseParams.WS_RESP_PARAM_CITY: "Delhi", //index.city.isEmpty == true ? self.passangerDetails[at].city : index.city,
                                          WSResponseParams.WS_RESP_PARAM_STATE: "Delhi", //index.state.isEmpty == true ? self.passangerDetails[at].state : index.state,
                                          WSResponseParams.WS_RESP_PARAM_COUNTRYCODE_CAP:index.nationality.isEmpty == true ? self.passangerDetails[at].nationality : index.nationality,
                                          WSResponseParams.WS_RESP_PARAM_COUNTRYNAME_CAP:index.country.isEmpty == true ? self.passangerDetails[at].country : index.country,
                                          WSResponseParams.WS_RESP_PARAM_CONTACTNO:index.mobile.isEmpty == true ? self.passangerDetails[at].mobile : index.mobile,
                                          WSRequestParams.WS_REQS_PARAM_EMAIL.capitalized:index.email.isEmpty == true ? self.passangerDetails[at].email : index.email,
                                          WSRequestParams.WS_REQS_PARAM_IS_LEAD_PAX: at == 0 ? true:false,
                                          WSResponseParams.WS_RESP_PARAM_NATIONALITY:index.nationality.isEmpty == true ? self.passangerDetails[at].nationality : index.nationality,
                                          "FFAirline" : index.ffAirline,
                                          "FFNumber": index.ffNumber] as [String : Any]
                    price = price + index.baggageAndMealPrice
                    
                    if self.ssrData?.fare_quote?.response?.fareQuoteResult?.isPassportRequiredAtBook == true{
                        indexPassender[WSRequestParams.WS_REQS_PARAM_PASSPORT_NO] = index.passportNumber
                        indexPassender[WSRequestParams.WS_REQS_PARAM_PASSPORT_ISSUE_DATE] = index.passportIssueDate.passportDate()
                        indexPassender[WSRequestParams.WS_REQS_PARAM_PASSPORT_EXPIRY] = index.passportExpDate.passportDate()
                    }
                    
                    if index.isGST == true {
                        indexPassender[WSRequestParams.WS_REQS_PARAM_GST_COMPANY_NAME] = index.gstCompanyName
                        indexPassender[WSRequestParams.WS_REQS_PARAM_GST_NUMBER] = index.gstNumber
                        indexPassender[WSRequestParams.WS_REQS_PARAM_GST_COMPANY_EMAIL] = index.gstCompanyEmail
                        indexPassender[WSRequestParams.WS_REQS_PARAM_GST_COMPANY_ADDRESS]  = index.gstAddress
                        indexPassender[WSRequestParams.WS_REQS_PARAM_GST_COMPANY_CONTACT_NO]  = index.gstCompanyContactNumber
                    }
                    
                    if self.ssrData?.ssr?.response?.seatPreference?.count ?? 0 > 0 {
                        if self.ssrData?.fare_quote?.response?.fareQuoteResult?.isLCC == true{
                            indexPassender[WSResponseParams.WS_RESP_PARAM_SEAT_DYNAMIC] = [index.seatPrefrance?.seatsPreferenceDict]
                        }else{
                            indexPassender[WSResponseParams.WS_RESP_PARAM_SEAT_PREFERENCE] = index.seatPrefrance?.seatsPreferenceDict
                        }
                    }
                    
                    var transectionFee = Int()
                    
                    for index in self.dataFlight.sFare.sTaxBreakup {
                        if index.sKey == "TransactionFee" {
                            transectionFee = Int(index.sValue)
                        }
                    }
                    
                    let fare = [WSResponseParams.WS_RESP_PARAM_BASE_FARE:self.dataFlight.sFare.sBaseFare,WSResponseParams.WS_RESP_PARAM_TAX:self.dataFlight.sFare.sTax,WSResponseParams.WS_RESP_PARAM_OTHER_CHARGES:transectionFee,WSResponseParams.WS_RESP_PARAM_YQTAX:self.dataFlight.sFare.sYQTax,WSResponseParams.WS_RESP_PARAM_ADDITIONAL_TXN_FEE_RD:self.dataFlight.sFare.sAdditionalTxnFeeOfrd,WSResponseParams.WS_RESP_PARAM_ADDITIONAL_TXN_FEE_PUB:self.dataFlight.sFare.sAdditionalTxnFeePub] as [String : Any]
                    
                    indexPassender[WSResponseParams.WS_RESP_PARAM_FARE_CAP] = fare
                    
                    if index.lccMealData?.code ?? "" == ""{
                        indexPassender.removeValue(forKey: WSResponseParams.WS_RESP_PARAM_MEAL_DYNAMIC)
                    }else{
                        indexPassender[WSResponseParams.WS_RESP_PARAM_MEAL_DYNAMIC] = [index.lccMealData?.MealDynamicDict ?? [:]]
                    }
                    
                    if index.lccBaggageData?.code ?? "" == ""{
                        indexPassender.removeValue(forKey: WSResponseParams.WS_RESP_PARAM_BAGGAGE)
                    }else{
                        indexPassender[WSResponseParams.WS_RESP_PARAM_BAGGAGE] = [index.lccBaggageData?.baggageDict ?? [:]]
                    }
                    
                    if passangerDetails[at].saveUser {
                        indexPassender[WSRequestParams.WS_REQS_PARAM_SAVE_PASSENGER] = "yes"
                    } else {
                        indexPassender[WSRequestParams.WS_REQS_PARAM_SAVE_PASSENGER] = "no"
                    }
                    
                    Passengers.append(indexPassender)
                }
                
                self.param[WSRequestParams.WS_REQS_PARAM_PASSENGERS] = Passengers
                debugPrint(self.param)
                
                if let vc = ViewControllerHelper.getViewController(ofType: .FlightReviewDetailsVC, StoryboardName: .Flight) as? FlightReviewDetailsVC {
                    vc.passengerDetails = passangerDetails
                    vc.numberOfAdults = numberOfAdults
                    vc.numberOfInfants = numberOfInfants
                    vc.numberOfChildren = numberOfChildren
                    
                    vc.doneCompletion = {
                        val in
                        if self.ssrData?.ssr?.response?.seatDynamic?.first?.segmentSeat?.first?.rowSeats?.count ?? 0 == 0 && self.ssrData?.ssr?.response?.baggage?.count ?? 0 == 0 || self.ssrData?.ssr?.response?.mealDynamic?.count == 0 {

                            if let vc = ViewControllerHelper.getViewController(ofType: .WalletPaymentVC, StoryboardName: .Main) as? WalletPaymentVC {
                                vc.param = self.param
                                let price = self.totalPrice.replacingOccurrences(of: "₹", with: "")
                                vc.amount = Double(price.replacingOccurrences(of: ",", with: "")) ?? 0.0
                                vc.screenFrom = .flight
                                vc.passengerEmail = self.passangerDetails[0].email
                                vc.passengerPhone = self.passangerDetails[0].mobile
                                vc.passengerName = self.passangerDetails[0].firstName
                                vc.dataFlight = self.dataFlight
                                if GetData.share.isOnwordBook() == true {
                                    vc.returnResultIndex = self.returnResultIndex
                                }
                                vc.tracID = self.traceId
                                vc.logId = self.logId
                                vc.token = self.tokenId
                                vc.ssrModel = self.ssrData
                                vc.publishedFare = self.basePrice + self.taxes
                                self.pushView(vc: vc)
                            }
                        }else{
                            if let vc = ViewControllerHelper.getViewController(ofType: .SelectSeatVC, StoryboardName: .Flight) as? SelectSeatVC {
                                
                                LoaderClass.shared.arrSelectedSeat = []
                                LoaderClass.shared.seletedSeatIndex = []
                                vc.param = self.param
                                vc.dataFlight = self.dataFlight
                                let price = (self.totalPrice.replacingOccurrences(of: "₹", with: ""))
                                vc.priceData = Double(price.replacingOccurrences(of: ",", with: "")) ?? 0.0
                                vc.passengerEmail = self.passangerDetails[0].email
                                vc.passengerPhone = self.passangerDetails[0].mobile
                                vc.passengerName = self.passangerDetails[0].firstName
                                vc.traceId = self.traceId
                                vc.logId = self.logId
                                vc.tokenId = self.tokenId
                                vc.ssrModel = self.ssrData
                                vc.numberOfSeat = self.passangerDetails.count
                                vc.resultIndex = self.dataFlight.sResultIndex
                                if GetData.share.isOnwordBook() == true {
                                    vc.returnResultIndex = self.returnResultIndex
                                }
                                vc.discount = self.discount
                                vc.basePrice = self.basePrice //dataFlight[0].sFare.sBaseFare
                                vc.convenientFee = self.convenientFee
                                vc.taxes = self.taxes
                                vc.taxesK3 = self.taxesK3
                                vc.conBirfurcation = self.conBirfurcation
                               // vc.passangerDetails = self.passangerDetails
                                //vc.baggagePrice = self.baggagePrice
                                //vc.mealPrice = self.mealPrice
                                
                                
                                //vc.selectedIndex = sender.tag
                                //vc.modalPresentationStyle = .custom
                                //vc.modalTransitionStyle = .crossDissolve
                                //vc.baggagePrice = baggagePrice
                                //vc.mealPrice = mealPrice
                                vc.baggageDetails = self.ssrData?.ssr?.response?.baggage ?? []
                                vc.mealData = self.ssrData?.ssr?.response?.mealDynamic ?? []
                                vc.mealDataNonLCC = self.ssrData?.ssr?.response?.meal ?? []
//                                vc.meal = self.passangerDetails[sender.tag].lccMealData
//                                vc.baggage = self.passangerDetails[sender.tag].lccBaggageData
//                                vc.mealNonLCC = self.passangerDetails[sender.tag].nonLccMealData
//                                vc.nonLCCBaggage = self.passangerDetails[sender.tag].nonLccBaggageData
//                                vc.delegate = self
//                                self.present(vc, animated: true)
                                
                                
                                
                                
                                self.pushView(vc: vc)
                            }
                        }
                    }
                    present(vc, animated: true)
                }
                
                //MARK: GET PASSANGER LIST
                DispatchQueue.background(background: {
                    //                    let param = [WSRequestParams.WS_REQS_PARAM_PASSENGERS :Passengers]
                    //                    self.viewModel.savePassangerList(param:param)
                }, completion:{
                    
                })
                
            }else{
                debugPrint("Its Non Direct Flight")
                
                self.param = [WSRequestParams.WS_REQS_PARAM_RECIPIENT_EMAIL: passangerDetails[0].email,
                              WSRequestParams.WS_REQS_PARAM_RECIPIENT_PHONE: passangerDetails[0].mobile,
                              WSResponseParams.WS_RESP_PARAM_LOGID:self.logId,
                              WSResponseParams.WS_RESP_PARAM_TOKEN:self.tokenId,
                              WSResponseParams.WS_RESP_PARAM_TRACE_ID:self.traceId,
                              WSResponseParams.WS_RESP_PARAM_RESULTS_INDEX:self.dataFlight.sResultIndex,
                              WSRequestParams.WS_REQS_PARAM_CUSTOMER_ID: UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false ? Cookies.userInfo()?.id ?? 0 : 0]
                
                var Passengers = [[String:Any]]()
                
                for (at,index) in self.passangerDetails.enumerated(){
                    var indexPassender = [WSRequestParams.WS_REQS_PARAM_TITLE.capitalized:index.title,
                                          WSResponseParams.WS_RESP_PARAM_FIRSTNAME:index.firstName,
                                          WSResponseParams.WS_RESP_PARAM_LASTNAME:index.lastName,
                                          WSRequestParams.WS_REQS_PARAM_PAX_TYPE:index.paxType,
                                          WSRequestParams.WS_REQS_PARAM_DATE_OF_BIRTH:index.dob,
                                          WSRequestParams.WS_REQS_PARAM_GENDER.capitalized:index.gender == "Male" ? 1 : 2  ,
                                          CommonParam.ADDRESS1: "Delhi", //index.address.isEmpty == true ? self.passangerDetails[0].address : index.address,
                                          WSResponseParams.WS_RESP_PARAM_CITY: "Delhi", //index.city.isEmpty == true ? self.passangerDetails[0].city : index.city,
                                          WSResponseParams.WS_RESP_PARAM_STATE: "Delhi", //index.state.isEmpty == true ? self.passangerDetails[at].state : index.state,
                                          WSResponseParams.WS_RESP_PARAM_COUNTRYCODE_CAP:index.nationality.isEmpty == true ? self.passangerDetails[0].nationality : index.nationality,
                                          WSResponseParams.WS_RESP_PARAM_COUNTRYNAME_CAP:index.country.isEmpty == true ? self.passangerDetails[0].country : index.country,
                                          WSResponseParams.WS_RESP_PARAM_CONTACTNO:index.mobile.isEmpty == true ? self.passangerDetails[0].mobile : index.mobile,
                                          WSRequestParams.WS_REQS_PARAM_EMAIL.capitalized:index.email.isEmpty == true ? self.passangerDetails[0].email : index.email,
                                          WSRequestParams.WS_REQS_PARAM_IS_LEAD_PAX: at == 0 ? true:false,
                                          WSResponseParams.WS_RESP_PARAM_NATIONALITY:index.nationality.isEmpty == true ? self.passangerDetails[at].nationality : index.nationality,
                                          "FFAirline" : index.ffAirline,
                                          "FFNumber": index.ffNumber] as [String : Any]
                    
                    if self.ssrData?.fare_quote?.response?.fareQuoteResult?.isPassportRequiredAtBook == true{
                        indexPassender[WSRequestParams.WS_REQS_PARAM_PASSPORT_NO] = index.passportNumber
                        indexPassender[WSRequestParams.WS_REQS_PARAM_PASSPORT_ISSUE_DATE] = index.passportIssueDate.passportDate()
                        indexPassender[WSRequestParams.WS_REQS_PARAM_PASSPORT_EXPIRY] = index.passportExpDate.passportDate()
                    }
                    
                    if self.ssrData?.ssr?.response?.seatPreference?.count ?? 0 > 0{
                        if self.ssrData?.fare_quote?.response?.fareQuoteResult?.isLCC == true{
                            indexPassender[WSResponseParams.WS_RESP_PARAM_SEAT_DYNAMIC] = [index.seatPrefrance?.seatsPreferenceDict]
                        }else{
                            indexPassender[WSResponseParams.WS_RESP_PARAM_SEAT_PREFERENCE] = index.seatPrefrance?.seatsPreferenceDict
                        }
                    }
                    
                    if index.isGST == true {
                        indexPassender[WSRequestParams.WS_REQS_PARAM_GST_COMPANY_NAME] = index.gstCompanyName
                        indexPassender[WSRequestParams.WS_REQS_PARAM_GST_NUMBER] = index.gstNumber
                        indexPassender[WSRequestParams.WS_REQS_PARAM_GST_COMPANY_EMAIL] = index.gstCompanyEmail
                        indexPassender[WSRequestParams.WS_REQS_PARAM_GST_COMPANY_ADDRESS]  = index.gstAddress
                        indexPassender[WSRequestParams.WS_REQS_PARAM_GST_COMPANY_CONTACT_NO]  = index.gstCompanyContactNumber
                    }
                    
                    var transectionFee = Int()
                    
                    for index in self.dataFlight.sFare.sTaxBreakup {
                        if index.sKey == "TransactionFee" {
                            transectionFee = Int(index.sValue)
                        }
                    }
                    
                    let fare = [WSResponseParams.WS_RESP_PARAM_BASE_FARE:self.dataFlight.sFare.sBaseFare,WSResponseParams.WS_RESP_PARAM_TAX:self.dataFlight.sFare.sTax,WSResponseParams.WS_RESP_PARAM_OTHER_CHARGES:transectionFee,WSResponseParams.WS_RESP_PARAM_YQTAX:self.dataFlight.sFare.sYQTax,WSResponseParams.WS_RESP_PARAM_ADDITIONAL_TXN_FEE_RD:self.dataFlight.sFare.sAdditionalTxnFeeOfrd,WSResponseParams.WS_RESP_PARAM_ADDITIONAL_TXN_FEE_PUB:self.dataFlight.sFare.sAdditionalTxnFeePub] as [String : Any]
                    
                    indexPassender[WSResponseParams.WS_RESP_PARAM_FARE_CAP] = fare
                    
                    if index.nonLccMealData?.code ?? "" == ""{
                        indexPassender.removeValue(forKey: WSResponseParams.WS_RESP_PARAM_MEAL)
                    }else{
                        indexPassender[WSResponseParams.WS_RESP_PARAM_MEAL] = index.nonLccMealData?.MealDynamicDict
                    }
                    
                    if index.nonLccBaggageData?.code ?? "" == ""{
                        indexPassender.removeValue(forKey: WSResponseParams.WS_RESP_PARAM_BAGGAGE)
                    }else{
                        indexPassender[WSResponseParams.WS_RESP_PARAM_BAGGAGE] = index.nonLccBaggageData?.baggageDict
                    }
                    
                    Passengers.append(indexPassender)
                }
                
                self.param[WSRequestParams.WS_REQS_PARAM_PASSENGERS] = Passengers
                
                if let vc = ViewControllerHelper.getViewController(ofType: .FlightReviewDetailsVC, StoryboardName: .Flight) as? FlightReviewDetailsVC {
                    vc.passengerDetails = passangerDetails
                    vc.numberOfAdults = numberOfAdults
                    vc.numberOfInfants = numberOfInfants
                    vc.numberOfChildren = numberOfChildren
                    
                    vc.doneCompletion = {
                        val in
                        
                        if self.ssrData?.ssr?.response?.seatDynamic?.first?.segmentSeat?.first?.rowSeats?.count ?? 0 == 0 && self.ssrData?.ssr?.response?.baggage?.count ?? 0 == 0 || self.ssrData?.ssr?.response?.mealDynamic?.count == 0 {
                            //                    if self.ssrData?.ssr?.response?.seatPreference?.count ?? 0 > 0{
                            //                        LoaderClass.shared.loadAnimation()
                            //                        self.viewModel.flightBook(param: self.param, view: self, flightData: self.dataFlight, token: self.tokenId, traceID: self.traceId, logID: self.logId, amount: Double(self.ssrData?.fare_quote?.response?.fareQuoteResult?.fare?.publishedFare ?? 0 ),ssrModel:self.ssrData! )
                            //                    }else{
                            
                            if let vc = ViewControllerHelper.getViewController(ofType: .WalletPaymentVC, StoryboardName: .Main) as? WalletPaymentVC {
                                vc.param = self.param
                                let price = self.totalPrice.replacingOccurrences(of: "₹", with: "")
                                vc.amount = Double(price.replacingOccurrences(of: ",", with: "")) ?? 0.0
                                //vc.amount = Double(self.ssrData?.fare_quote?.response?.fareQuoteResult?.fare?.publishedFare ?? 0 )
                                vc.screenFrom = .flight
                                vc.passengerEmail = self.passangerDetails[0].email
                                vc.passengerPhone = self.passangerDetails[0].mobile
                                vc.passengerName = self.passangerDetails[0].firstName
                                vc.dataFlight = self.dataFlight
                                
                                if GetData.share.isOnwordBook() == true {
                                    vc.returnResultIndex = self.returnResultIndex
                                }
                                vc.tracID = self.traceId
                                vc.logId = self.logId
                                vc.token = self.tokenId
                                vc.publishedFare = self.basePrice + self.taxes
                                
                                self.pushView(vc: vc)
                            }
                            // }
                        }else{
                            if let vc = ViewControllerHelper.getViewController(ofType: .SelectSeatVC, StoryboardName: .Flight) as? SelectSeatVC{
                                LoaderClass.shared.arrSelectedSeat = []
                                LoaderClass.shared.seletedSeatIndex = []
                                vc.param = self.param
                                vc.dataFlight = self.dataFlight
                                vc.traceId = self.traceId
                                vc.logId = self.logId
                                vc.tokenId = self.tokenId
                                vc.ssrModel = self.ssrData
                                vc.numberOfSeat = self.passangerDetails.count
                                vc.passengerEmail = self.passangerDetails[0].email
                                vc.passengerPhone = self.passangerDetails[0].mobile
                                vc.passengerName = self.passangerDetails[0].firstName
                                vc.resultIndex = self.dataFlight.sResultIndex
                                if GetData.share.isOnwordBook() == true {
                                    vc.returnResultIndex = self.returnResultIndex
                                }
                                let price = (self.totalPrice.replacingOccurrences(of: "₹", with: ""))
                                vc.priceData = Double(price.replacingOccurrences(of: ",", with: "")) ?? 0.0
                                vc.discount = self.discount
                                vc.basePrice = self.basePrice //dataFlight[0].sFare.sBaseFare
                                vc.convenientFee = self.convenientFee
                                vc.taxes = self.taxes
                                vc.taxesK3 = self.taxesK3
                                vc.conBirfurcation = self.conBirfurcation
                                vc.baggagePrice = self.baggagePrice
                                vc.mealPrice = self.mealPrice
                                
                                self.pushView(vc: vc)
                            }
                        }
                    }
                    present(vc, animated: true)
                }
                //MARK: GET PASSANGER LIST
                DispatchQueue.background(background: {
                    //                    let param = [WSRequestParams.WS_REQS_PARAM_PASSENGERS :Passengers]
                    //                    self.viewModel.savePassangerList(param:param)
                }, completion:{
                    
                })
            }
        }
    }
    
    func isValidatePassanger() -> Bool {
        
        for (at,index) in self.passangerDetails.enumerated(){
            if index.title.isEmptyCheck() == true {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(CommonMessage.PLEASE_FILL_TITLE)")
                return false
            }else if index.firstName.isEmptyCheck() == true{
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(CommonMessage.PLEASE_FILL_FIRST_NAME)")
                return false
            }else if index.lastName.isEmptyCheck() == true{
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(CommonMessage.PLEASE_FILL_FIRST_LAST)")
                return false
            }else if index.dob.isEmptyCheck() == true{
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(CommonMessage.PLEASE_FILL_DATE_OF_BIRTH)")
                return false
            } else if index.gender.isEmptyCheck() == true{
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(CommonMessage.PLEASE_FILL_GENDER)")
                return false
            }else if index.email.isEmptyCheck() == true && at == 0 {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(CommonMessage.PLEASE_FILL_EMAIL)")
                return false
            }else if index.email.isValidEmail() == false && at == 0 {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(CommonMessage.PLEASE_FILL_VALID_EMAIL)")
                return false
            }else if index.countryMobileCode.isEmptyCheck() == true && at == 0 {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(CommonMessage.PLEASE_FILL_COUNTRY_CODE)")
                return false
            }else if index.mobile.isEmptyCheck() == true && at == 0 {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(CommonMessage.PLEASE_FILL_MOBILE_NUMBER)")
                return false
            }
            else if index.country.isEmptyCheck() == true && at == 0 {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(CommonMessage.PLEASE_FILL_COUNTRY)")
                return false
            }

            else if self.ssrData?.fare_quote?.response?.fareQuoteResult?.isPassportRequiredAtBook == true && index.passportNumber.isEmptyCheck() == true && at == 0 {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(WSRequestParams.WS_REQS_PARAM_PASSPORT_NO)")
                return false
            }else if self.ssrData?.fare_quote?.response?.fareQuoteResult?.isPassportRequiredAtBook == true && index.passportIssueDate.isEmptyCheck() == true && at == 0 {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(WSRequestParams.WS_REQS_PARAM_PASSPORT_ISSUE_DATE)")
                return false
            }else if self.ssrData?.fare_quote?.response?.fareQuoteResult?.isPassportRequiredAtBook == true && index.passportExpDate.isEmptyCheck() == true && at == 0 {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) passenger \(at+1) \(WSRequestParams.WS_REQS_PARAM_PASSPORT_EXPIRY)")
                return false
            } else if index.isGST == true && at == 0 {
                if index.gstNumber.isEmptyCheck() == true {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) \(CommonMessage.PLEASE_FILL_GST_NUMBER)")
                    return false
                } else if index.gstNumber.count < 15 || index.gstNumber.validateGSTNumber() == false {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.VALID_GST)
                    return false
                } else if index.gstCompanyName.isEmptyCheck() == true{
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) \(CommonMessage.PLEASE_FILL_GST_COMPANY_NAME)")
                    return false
                } else if index.gstAddress.isEmptyCheck() == true {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) \(CommonMessage.PLEASE_FILL_GST_COMPANY_ADDRESS)")
                    return false
                } else if index.gstCompanyEmail.isEmptyCheck() == true {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) \(CommonMessage.PLEASE_FILL_GST_COMPANY_EMAIL)")
                    return false
                } else if index.gstCompanyEmail.isValidEmail() == false {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.VALID_COMPANY_EMAIL)")
                    return false
                } else if index.gstCompanyContactNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.COMPANY_PHONE)
                    return false
                } else {
                    return true
                }
            } else if let selectedDate = dateFormatter.date(from: index.dob) {
                let calendar = Calendar.current
                let currentDate = Date()
                
                let ageComponents = calendar.dateComponents([.year], from: selectedDate, to: currentDate)
                
                if let age = ageComponents.year, age > 12 {
                  //  return true
                } else {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: "Adult's age must be more than 12 years")
                    return false
                }
            }
        }
        return true
    }
    
    @objc func existingOnPress(sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .ExistingPassangerVC, StoryboardName: .Flight) as? ExistingPassangerVC {
            vc.modalPresentationStyle = .overFullScreen
            vc.passangerList = self.viewModel.passangerList?.data ?? []
            vc.selectedPassengerIndex = sender.tag
            vc.selectedIndex = self.selectedPassenger
            vc.tableCellDelegate = {
                detail, index, selectedIndex in
                self.selectedPassenger = selectedIndex
                self.passangerDetails[index] = detail
                let loopCount = self.numberOfAdults + self.numberOfInfants + self.numberOfChildren
                
                for at in 0..<loopCount {
                  //  var passanger = PassangerDetails()
                    
                    if at+1 <= self.numberOfAdults {
                        self.passangerDetails[index].paxType = "1"
                    }
                    else if at+1 > self.numberOfAdults && at+1 <= (self.numberOfAdults + self.numberOfChildren) {
                        self.passangerDetails[index].paxType = "2"
                    }
                    else {
                        self.passangerDetails[index].paxType = "3"
                    }
                   // self.passangerDetails.append(passanger)
                }
                self.tblVwPassenges.reloadData()
            }
            self.present(vc, animated: true)
        }
    }
    
    @objc func saveUserOnPress(sender:UIButton) {
        self.passangerDetails[sender.tag].saveUser = self.passangerDetails[sender.tag].saveUser != true
        self.tblVwPassenges.reloadData()
    }
    
    @objc func gstOnPress(sender:UIButton){
        if self.passangerDetails.first?.isGST == true {
            self.passangerDetails[0].isGST = false
        }else{
            self.passangerDetails[0].isGST = true
        }
        self.tblVwPassenges.reloadData()
    }
    
    @objc func addOnPress(sender:UIButton) {
        if self.ssrData?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
            if self.ssrData?.ssr?.response?.mealDynamic?.first?.count ?? 0 == 0 && self.ssrData?.ssr?.response?.baggage?.first?.count ?? 0 == 0{
                Alert.showSimple("No Meal and Baggage are included in this flight")
            }else{
                self.moveAddOn(sender:sender)
            }
        }else{
            if self.ssrData?.ssr?.response?.meal?.count ?? 0 == 0 && self.ssrData?.ssr?.response?.baggage?.first?.count ?? 0 == 0{
                Alert.showSimple("No Meal and Baggage are included in this flight")
            }else{
                self.moveAddOn(sender:sender)
            }
        }
    }
    
    func moveAddOn(sender:UIButton) {
        
        if let vc = ViewControllerHelper.getViewController(ofType: .PassangerMealandBaggageVC, StoryboardName: .Flight) as? PassangerMealandBaggageVC {
            vc.selectedIndex = sender.tag
            vc.modalPresentationStyle = .custom
            vc.modalTransitionStyle = .crossDissolve
            vc.baggagePrice = baggagePrice
            vc.mealPrice = mealPrice
            vc.baggageDetails = self.ssrData?.ssr?.response?.baggage ?? []
            vc.mealData = self.ssrData?.ssr?.response?.mealDynamic ?? []
            vc.mealDataNonLCC = self.ssrData?.ssr?.response?.meal ?? []
            vc.ssrData = self.ssrData
            vc.meal = self.passangerDetails[sender.tag].lccMealData
            vc.baggage = self.passangerDetails[sender.tag].lccBaggageData
            vc.mealNonLCC = self.passangerDetails[sender.tag].nonLccMealData
            vc.nonLCCBaggage = self.passangerDetails[sender.tag].nonLccBaggageData
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
    
    @objc func baggageOnPress(sender:UIButton){
        if let vc = ViewControllerHelper.getViewController(ofType: .BaggageDetailsVC, StoryboardName: .Flight) as? BaggageDetailsVC{
            vc.modalPresentationStyle = .custom
            vc.modalTransitionStyle = .crossDissolve
            vc.source = "\(self.dataFlight.sSegments.first?.first?.sOriginAirport.sAirportCode ?? "") - \(self.dataFlight.sSegments.first?.first?.sDestinationAirport.sAirportCode ?? "")"
            vc.cabin = self.dataFlight.sSegments.first?.first?.sCabinBaggage.count == 0 ? "(Not Included)" : "\(self.dataFlight.sSegments.first?.first?.sCabinBaggage ?? "" == "Included" ? self.dataFlight.sSegments.first?.first?.sCabinBaggage ?? "" : "\(self.dataFlight.sSegments.first?.first?.sCabinBaggage ?? "") (Included)")"
            vc.checkIn = self.dataFlight.sSegments.first?.first?.sBaggage.count == 0 ? "(Not Included)" : "\(self.dataFlight.sSegments.first?.first?.sBaggage ?? "" == "Included" ? self.dataFlight.sSegments.first?.first?.sBaggage ?? "" : "\(self.dataFlight.sSegments.first?.first?.sBaggage ?? "") (Included)")"
            self.present(vc, animated: true)
        }
    }
}

//MARK: - UITABLEVIEW METHODS
extension PassangerDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == tblVwFairDetail ? (isDomasticRountTrip == true ? dataFlight1[0].sSegments.count + returnDataFlight[0].sSegments.count  : dataFlight1[0].sSegments.count) : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVwFairDetail {
            if isMultiCity {
                return dataFlight1[0].sSegments[section].count
            } else {
                if isDomasticRountTrip {
                    if section == dataFlight1[0].sSegments.count - 1 {
                        for i in 0..<dataFlight1[0].sSegments.count {
                            ret = dataFlight1[0].sSegments[i].count
                        }
                    } else if section == dataFlight1[0].sSegments.count + returnDataFlight[0].sSegments.count - 1 {
                        for i in 0..<returnDataFlight[0].sSegments.count {
                            ret = returnDataFlight[0].sSegments[i].count
                        }
                    } else {
                        ret = 1
                    }
                } else {
                    if section != dataFlight1[0].sSegments.count {
                        for i in 0..<dataFlight1[0].sSegments.count {
                            ret = dataFlight1[0].sSegments[i].count
                        }
                    } else {
                        ret = 1
                    }
                }
                return ret
            }
        } else {
            if !LoaderClass.shared.passengerReturn.isEmpty {
                let passengers = LoaderClass.shared.passengerReturn["Passengers"] as? [Any]
                return passengers?.count ?? 0
            } else {
                return self.passangerDetails.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblVwFairDetail {
            if isDomasticRountTrip {
                if indexPath.section == dataFlight1[0].sSegments.count - 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FareFlightXIB().identifire, for: indexPath) as! FareFlightXIB
                    cell.viewPink.isHidden = true
                    if dataFlight1[0].sSegments[indexPath.section].count > 1 {
                        if indexPath.row == dataFlight1[0].sSegments[indexPath.section].count - 1 {
                            cell.imgMultipleFlights.isHidden = true
                            cell.lblAircraftType.isHidden = true
                            cell.lblLayoverTime.isHidden = true
                        } else {
                            cell.imgMultipleFlights.isHidden = false
                            cell.lblAircraftType.isHidden = false
                            cell.lblLayoverTime.isHidden = false
                            
                            
                            var haltTime = Int()
                            if ((dataFlight1[0].sSegments[indexPath.section].last?.sAccDuration ?? 0) - (dataFlight1[0].sSegments[indexPath.section].last?.sDuration ?? 0) - (dataFlight1[0].sSegments[indexPath.section].first?.sDuration ?? 0)) < 0 {
                                haltTime = ((dataFlight1[0].sSegments[indexPath.section].last?.sAccDuration ?? 0) - (dataFlight1[0].sSegments[indexPath.section].last?.sDuration ?? 0) - (dataFlight1[0].sSegments[indexPath.section].first?.sDuration ?? 0)) * -1
                            } else {
                                haltTime = ((dataFlight1[0].sSegments[indexPath.section].last?.sAccDuration ?? 0) - (dataFlight1[0].sSegments[indexPath.section].last?.sDuration ?? 0) - (dataFlight1[0].sSegments[indexPath.section].first?.sDuration ?? 0))
                            }
                            
                            cell.lblLayoverTime.text = "Layover Time\n\(haltTime.getDuration())"
                            cell.lblAircraftType.text = "\(dataFlight1[0].sSegments[indexPath.section].first?.sAirline.sFlightNumber ?? "") \(dataFlight1[0].sSegments[indexPath.section].first?.sAirline.sFareClass ?? "")" == "\(dataFlight1[0].sSegments[indexPath.section].last?.sAirline.sFlightNumber ?? "") \(dataFlight1[0].sSegments[indexPath.section].last?.sAirline.sFareClass ?? "")" ? "Same\nAircraft" : "Change\nAircraft"
                         //   cell.lblAircraftType.text = dataFlight1[0].sSegments[indexPath.section].first?.sAirline.sAirlineName == dataFlight1[0].sSegments[indexPath.section].last?.sAirline.sAirlineName ? "Same\nAircraft" : "Change\nAircraft"
                        }
                    } else {
                        cell.imgMultipleFlights.isHidden = true
                        cell.lblAircraftType.isHidden = true
                        cell.lblLayoverTime.isHidden = true
                    }
                    
                    cell.lblDate.isHidden = dataFlight1[0].sSegments[indexPath.section].count > 1 && isMultiCity == false ? false : true
                    let firstIndex = dataFlight1[0].sSegments[indexPath.section][indexPath.row]
                    cell.lblFlightName.text = firstIndex.sAirline.sAirlineName
                    cell.imgFlight.image = UIImage.init(named: firstIndex.sAirline.sAirlineCode)
                    cell.lblCabbinBaggage.text = "\(firstIndex.sCabinBaggage == "Included" ? firstIndex.sCabinBaggage : "\(firstIndex.sCabinBaggage) (Included)")"
                    cell.lblCheckinBaggage.text = "\(firstIndex.sBaggage == "Included" ? firstIndex.sBaggage : "\(firstIndex.sBaggage) (Included)")"
                    
                    cell.lblTitleCode.text = "\(firstIndex.sAirline.sAirlineCode) - \(firstIndex.sAirline.sFlightNumber) \(firstIndex.sAirline.sFareClass)"
                    lblDateTime.text = "\(firstIndex.sOriginDeptTime.convertDateWithString("dd MMM",oldFormat: "yyyy-MM-dd'T'HH:mm:ss")) | \(firstIndex.sOriginDeptTime.convertStoredDate())"
                    cell.lblToFlightCode.text = firstIndex.sDestinationArrvTime.convertDateWithString("EEE,dd MMM yy",oldFormat: "yyyy-MM-dd'T'HH:mm:ss")
                    cell.lblFlightFromCode.text = firstIndex.sOriginDeptTime.convertDateWithString("EEE,dd MMM yy",oldFormat: "yyyy-MM-dd'T'HH:mm:ss")
                    
                    cell.lblDestinationCity.text = firstIndex.sDestinationAirport.sCityName
                    cell.lblSourceCity.text = firstIndex.sOriginAirport.sCityName
                    
                    cell.lblSourceTerminal.text = "\(firstIndex.sOriginAirport.sAirportName)\nTerminal \(firstIndex.sOriginAirport.sTerminal)"
                    cell.lblDestinationTerminal.text = "\(firstIndex.sDestinationAirport.sAirportName)\nTerminal \(firstIndex.sDestinationAirport.sTerminal)"
                    
                    cell.lblDate.text = firstIndex.sOriginDeptTime.convertStoredDay()
                    cell.lblFromFlightTime.text = firstIndex.sOriginDeptTime.convertStoredDate()
                    cell.lblToflightTime.text = firstIndex.sDestinationArrvTime.convertStoredDate()
                    
                    cell.lblTotalTime.text = firstIndex.sDuration.getDuration()
                    
                    return cell
                } else if indexPath.section == dataFlight1[0].sSegments.count + returnDataFlight[0].sSegments.count - 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FareFlightXIB().identifire, for: indexPath) as! FareFlightXIB
                    cell.viewPink.isHidden = true
                    if returnDataFlight[0].sSegments[0].count > 1 {
                        cell.imgMultipleFlights.isHidden = indexPath.row == returnDataFlight[0].sSegments[0].count - 1
                    } else {
                        cell.imgMultipleFlights.isHidden = true
                    }
                    
                    let firstIndex = returnDataFlight[0].sSegments[0][indexPath.row]
                    cell.lblFlightName.text = firstIndex.sAirline.sAirlineName
                    cell.imgFlight.image = UIImage.init(named: firstIndex.sAirline.sAirlineCode)
                    cell.lblCabbinBaggage.text = "\(firstIndex.sCabinBaggage == "Included" ? firstIndex.sCabinBaggage : "\(firstIndex.sCabinBaggage) (Included)")"
                    cell.lblCheckinBaggage.text = "\(firstIndex.sBaggage == "Included" ? firstIndex.sBaggage : "\(firstIndex.sBaggage) (Included)")"
                  
                    cell.lblDate.text = firstIndex.sOriginDeptTime.convertStoredDay()
                    cell.lblFromFlightTime.text = firstIndex.sOriginDeptTime.convertStoredDate()
                    cell.lblToflightTime.text = firstIndex.sDestinationArrvTime.convertStoredDate()
                    
                    cell.lblTotalTime.text = firstIndex.sDuration.getDuration()
                    
                    cell.lblTitleCode.text = "\(firstIndex.sAirline.sAirlineCode) - \(firstIndex.sAirline.sFlightNumber) \(firstIndex.sAirline.sFareClass)"
                    lblDateTime.text = "\(firstIndex.sOriginDeptTime.convertDateWithString("dd MMM",oldFormat: "yyyy-MM-dd'T'HH:mm:ss")) | \(firstIndex.sOriginDeptTime.convertStoredDate())"

                    cell.lblToFlightCode.text = firstIndex.sDestinationArrvTime.convertDateWithString("EEE,dd MMM yy",oldFormat: "yyyy-MM-dd'T'HH:mm:ss")
                    cell.lblFlightFromCode.text = firstIndex.sOriginDeptTime.convertDateWithString("EEE,dd MMM yy",oldFormat: "yyyy-MM-dd'T'HH:mm:ss")
                    
                    cell.lblDestinationCity.text = firstIndex.sDestinationAirport.sCityName
                    cell.lblSourceCity.text = firstIndex.sOriginAirport.sCityName
                    
                    cell.lblSourceTerminal.text = "\(firstIndex.sOriginAirport.sAirportName)\nTerminal \(firstIndex.sOriginAirport.sTerminal)"
                    cell.lblDestinationTerminal.text = "\(firstIndex.sDestinationAirport.sAirportName)\nTerminal \(firstIndex.sDestinationAirport.sTerminal)"
                    
                    return cell
                }
            } else {
                if indexPath.section != self.dataFlight1[0].sSegments.count {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FareFlightXIB().identifire, for: indexPath) as! FareFlightXIB
                    cell.viewPink.isHidden = true
                    if dataFlight1[0].sSegments[indexPath.section].count > 1 {
                        if indexPath.row == dataFlight1[0].sSegments[indexPath.section].count - 1 {
                            cell.imgMultipleFlights.isHidden = true
                            cell.lblLayoverTime.isHidden = true
                            cell.lblAircraftType.isHidden = true
                        }
                        else {
                            cell.imgMultipleFlights.isHidden = false
                            cell.lblLayoverTime.isHidden = false
                            cell.lblAircraftType.isHidden = false
                            
                            var haltTime = Int()
                            if ((dataFlight1[0].sSegments[indexPath.section].last?.sAccDuration ?? 0) - (dataFlight1[0].sSegments[indexPath.section].last?.sDuration ?? 0) - (dataFlight1[0].sSegments[indexPath.section].first?.sDuration ?? 0)) < 0 {
                                haltTime = ((dataFlight1[0].sSegments[indexPath.section].last?.sAccDuration ?? 0) - (dataFlight1[0].sSegments[indexPath.section].last?.sDuration ?? 0) - (dataFlight1[0].sSegments[indexPath.section].first?.sDuration ?? 0)) * -1
                            } else {
                                haltTime = ((dataFlight1[0].sSegments[indexPath.section].last?.sAccDuration ?? 0) - (dataFlight1[0].sSegments[indexPath.section].last?.sDuration ?? 0) - (dataFlight1[0].sSegments[indexPath.section].first?.sDuration ?? 0))
                            }
                            
                            cell.lblLayoverTime.text = "Layover Time\n\(haltTime.getDuration())"
                           // cell.lblAircraftType.text = dataFlight1[0].sSegments[indexPath.section].first?.sAirline.sAirlineName == dataFlight1[0].sSegments[indexPath.section].last?.sAirline.sAirlineName ? "Same\nAircraft" : "Change\nAircraft"
                            
                            cell.lblAircraftType.text = "\(dataFlight1[0].sSegments[indexPath.section].first?.sAirline.sFlightNumber ?? "") \(dataFlight1[0].sSegments[indexPath.section].first?.sAirline.sFareClass ?? "")" == "\(dataFlight1[0].sSegments[indexPath.section].last?.sAirline.sFlightNumber ?? "") \(dataFlight1[0].sSegments[indexPath.section].last?.sAirline.sFareClass ?? "")" ? "Same\nAircraft" : "Change\nAircraft"

                        }
                    } else {
                        cell.imgMultipleFlights.isHidden = true
                        cell.lblLayoverTime.isHidden = true
                        cell.lblAircraftType.isHidden = true
                    }
                    cell.lblDate.isHidden = dataFlight1[0].sSegments[indexPath.section].count > 1 && isMultiCity == false ? false : true
                    if dataFlight1[0].sSegments[indexPath.section].count > 0 {
                        let firstIndex = dataFlight1[0].sSegments[indexPath.section][indexPath.row]
                        
                        cell.lblFlightName.text = firstIndex.sAirline.sAirlineName
                        cell.imgFlight.image = UIImage.init(named: firstIndex.sAirline.sAirlineCode)
                        cell.lblCabbinBaggage.text = "\(firstIndex.sCabinBaggage == "Included" ? firstIndex.sCabinBaggage : "\(firstIndex.sCabinBaggage) (Included)")"
                        cell.lblCheckinBaggage.text = "\(firstIndex.sBaggage == "Included" ? firstIndex.sBaggage : "\(firstIndex.sBaggage) (Included)")"
                        
                        cell.lblDate.text = firstIndex.sOriginDeptTime.convertStoredDay()
                        cell.lblFromFlightTime.text = firstIndex.sOriginDeptTime.convertStoredDate()
                        cell.lblToflightTime.text = firstIndex.sDestinationArrvTime.convertStoredDate()
                        
                        cell.lblTotalTime.text = firstIndex.sDuration.getDuration()
                        
                        
                        cell.lblTitleCode.text = "\(firstIndex.sAirline.sAirlineCode) - \(firstIndex.sAirline.sFlightNumber) \(firstIndex.sAirline.sFareClass)"
                        lblDateTime.text = "\(firstIndex.sOriginDeptTime.convertDateWithString("dd MMM",oldFormat: "yyyy-MM-dd'T'HH:mm:ss")) | \(firstIndex.sOriginDeptTime.convertStoredDate())"

                        cell.lblToFlightCode.text = firstIndex.sDestinationArrvTime.convertDateWithString("EEE,dd MMM yy",oldFormat: "yyyy-MM-dd'T'HH:mm:ss")
                        cell.lblFlightFromCode.text = firstIndex.sOriginDeptTime.convertDateWithString("EEE,dd MMM yy",oldFormat: "yyyy-MM-dd'T'HH:mm:ss")
                        
                        cell.lblDestinationCity.text = firstIndex.sDestinationAirport.sCityName
                        cell.lblSourceCity.text = firstIndex.sOriginAirport.sCityName
                        
                        cell.lblSourceTerminal.text = "\(firstIndex.sOriginAirport.sAirportName)\nTerminal \(firstIndex.sOriginAirport.sTerminal)"
                        cell.lblDestinationTerminal.text = "\(firstIndex.sDestinationAirport.sAirportName)\nTerminal \(firstIndex.sDestinationAirport.sTerminal)"
                    }
                    return cell
                }
                //            else {
                //                let cell = tableView.dequeueReusableCell(withIdentifier: SecureTripXIB().identifire, for: indexPath) as! SecureTripXIB
                //
                //                cell.btnSecure.addTarget(self, action: #selector(handleSecureTap(_:)), for: .touchUpInside)
                //                cell.btnUnsecure.addTarget(self, action: #selector(handleUnsecureTap(_:)), for: .touchUpInside)
                //
                //                return cell
                //            }
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PassangerDetailXIB", for: indexPath) as! PassangerDetailXIB
            
            let indexData = self.passangerDetails[indexPath.row]
            
            DispatchQueue.main.async {
                cell.btnExistingUser.isHidden = self.viewModel.passangerList?.data?.count == 0 || self.viewModel.passangerList?.data?.count == nil || UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true
            }
            
            
            //From here
//            cell.txtFirstName.text = "Radhika"
//            cell.txtLastName.text = "Anand"
//            cell.txtDob.text = "Mar 01, 1995"
//            cell.txtTitle.text = "Miss"
//            cell.txtEmail.text = "radhika@leavecasa.com"
//            cell.txtMobile.text = "9041723151"
//            cell.txtCountryCode.text = "+91"
//
//            self.passangerDetails[0].ffNumber = cell.txtFldFFNumber.text ?? ""
//            self.passangerDetails[0].ffAirline = cell.txtFldFFAirline.text ?? ""
//            self.passangerDetails[0].title = cell.txtTitle.text ?? ""
//            self.passangerDetails[0].firstName = cell.txtFirstName.text ?? ""
//            self.passangerDetails[0].lastName = cell.txtLastName.text ?? ""
//            self.passangerDetails[0].dob = cell.txtDob.text ?? ""
//            self.passangerDetails[0].gender = "2"//cell.txtGender.text ?? ""
//            self.passangerDetails[0].email = cell.txtEmail.text ?? ""
//            self.passangerDetails[0].countryMobileCode = cell.txtCountryCode.text ?? ""
//            self.passangerDetails[0].mobile = cell.txtMobile.text ?? ""
//            self.passangerDetails[0].address = cell.txtAddress.text ?? ""
//            self.passangerDetails[0].country = cell.txtCountry.text ?? ""
//            self.passangerDetails[0].state = cell.txtState.text ?? ""
//            self.passangerDetails[0].city = cell.txtCity.text ?? ""
//            self.passangerDetails[0].gstNumber = cell.txtGstNumber.text ?? ""
//            self.passangerDetails[0].gstAddress = cell.txtCompanyAddress.text ?? ""
//            self.passangerDetails[0].gstCompanyName = cell.txtGstCompanyName.text ?? ""
//            self.passangerDetails[0].gstCompanyEmail = cell.txtGstEmail.text ?? ""
//            self.passangerDetails[0].gstCompanyContactNumber = cell.txtFldGstPhone.text ?? ""
//            self.passangerDetails[0].passportNumber = cell.txtPassportNumber.text ?? ""
//            self.passangerDetails[0].passportExpDate = cell.txtPassportExpDate.text ?? ""
//            self.passangerDetails[0].passportIssueDate = cell.txtPassportIsuueDate.text ?? ""
            
//            self.passangerDetails[1].ffNumber = cell.txtFldFFNumber.text ?? ""
//            self.passangerDetails[1].ffAirline = cell.txtFldFFAirline.text ?? ""
//            self.passangerDetails[1].title = cell.txtTitle.text ?? ""
//            self.passangerDetails[1].firstName = cell.txtFirstName.text ?? ""
//            self.passangerDetails[1].lastName = cell.txtLastName.text ?? ""
//            self.passangerDetails[1].dob = cell.txtDob.text ?? ""
//            self.passangerDetails[1].gender = "2"//cell.txtGender.text ?? ""
//            self.passangerDetails[1].email = cell.txtEmail.text ?? ""
//            self.passangerDetails[1].countryMobileCode = cell.txtCountryCode.text ?? ""
//            self.passangerDetails[1].mobile = cell.txtMobile.text ?? ""
//            self.passangerDetails[1].address = cell.txtAddress.text ?? ""
//            self.passangerDetails[1].country = cell.txtCountry.text ?? ""
//            self.passangerDetails[1].state = cell.txtState.text ?? ""
//            self.passangerDetails[1].city = cell.txtCity.text ?? ""
//            self.passangerDetails[1].gstNumber = cell.txtGstNumber.text ?? ""
//            self.passangerDetails[1].gstAddress = cell.txtCompanyAddress.text ?? ""
//            self.passangerDetails[1].gstCompanyName = cell.txtGstCompanyName.text ?? ""
//            self.passangerDetails[1].gstCompanyEmail = cell.txtGstEmail.text ?? ""
//            self.passangerDetails[1].gstCompanyContactNumber = cell.txtFldGstPhone.text ?? ""
//            self.passangerDetails[1].passportNumber = cell.txtPassportNumber.text ?? ""
//            self.passangerDetails[1].passportExpDate = cell.txtPassportExpDate.text ?? ""
//            self.passangerDetails[1].passportIssueDate = cell.txtPassportIsuueDate.text ?? ""
//
            //Till here
            
            
            if !LoaderClass.shared.passengerReturn.isEmpty {
                cell.btnGST.isUserInteractionEnabled = false
                cell.txtFirstName.isUserInteractionEnabled = false
                cell.txtLastName.isUserInteractionEnabled = false
                cell.txtTitle.isUserInteractionEnabled = false
                cell.txtCountryCode.isUserInteractionEnabled = false
                cell.txtAddress.isUserInteractionEnabled = false
                cell.txtEmail.isUserInteractionEnabled = false
                cell.txtMobile.isUserInteractionEnabled = false
                cell.txtGender.isUserInteractionEnabled = false
                cell.txtDob.isUserInteractionEnabled = false
                cell.txtCity.isUserInteractionEnabled = false
                cell.txtCountry.isUserInteractionEnabled = false
                cell.txtGstEmail.isUserInteractionEnabled = false
                cell.txtState.isUserInteractionEnabled = false
                cell.txtSeatPreference.isUserInteractionEnabled = false
                cell.txtPassportIsuueDate.isUserInteractionEnabled = false
                cell.txtPassportExpDate.isUserInteractionEnabled = false
                cell.txtPassportNumber.isUserInteractionEnabled = false
                cell.txtFldGstPhone.isUserInteractionEnabled = false
                cell.txtGstNumber.isUserInteractionEnabled = false
                cell.txtGstCompanyName.isUserInteractionEnabled = false
                cell.txtCompanyAddress.isUserInteractionEnabled = false
                cell.txtFldFFNumber.isUserInteractionEnabled = false
                cell.txtFldFFAirline.isUserInteractionEnabled = false
            }
            
            
            if indexPath.row % 2 == 0 {
                cell.mainView.backgroundColor = .clear
            }
            else {
                cell.mainView.backgroundColor = .white.withAlphaComponent(0.5)
            }
            
            if self.ssrData?.ssr?.response?.seatPreference?.count ?? 0 > 0 {
                cell.seatPreferenceStack.isHidden = false
            }
            else {
                cell.seatPreferenceStack.isHidden = true
            }
            
            if self.ssrData?.fare_quote?.response?.fareQuoteResult?.isPassportRequiredAtBook == true {
                cell.passportDateStack.isHidden = false
                cell.passportNumberStack.isHidden = false
                cell.countryStack.isHidden = false
                cell.stateStack.isHidden = false
            }
            else {
                cell.passportDateStack.isHidden = true
                cell.passportNumberStack.isHidden = true
                cell.countryStack.isHidden = true
                cell.stateStack.isHidden = true
            }
            
            if indexPath.row == 0 {
                cell.emailStack.isHidden = false
                //cell.countryStack.isHidden = true
                cell.mobileStack.isHidden = false
                cell.gstMainView.isHidden = false
                cell.ihaveGstView.isHidden = false
            } else {
                cell.ihaveGstView.isHidden = true
                cell.gstMainView.isHidden = true
                cell.emailStack.isHidden = true
                //cell.countryStack.isHidden = true
                cell.mobileStack.isHidden = true
            }
            DispatchQueue.main.async {
                
                LoaderClass.shared.txtFldborder(txtFld: cell.txtPassportNumber)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtPassportExpDate)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtPassportIsuueDate)
                
                LoaderClass.shared.txtFldborder(txtFld: cell.txtFirstName)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtTitle)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtLastName)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtDob)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtGender)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtEmail)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtCountryCode)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtCountry)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtMobile)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtAddress)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtState)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtCity)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtSeatPreference)
                
                LoaderClass.shared.txtFldborder(txtFld: cell.txtGstNumber)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtGstEmail)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtCompanyAddress)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtGstCompanyName)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtFldGstPhone)
                
                LoaderClass.shared.txtFldborder(txtFld: cell.txtFldFFNumber)
                LoaderClass.shared.txtFldborder(txtFld: cell.txtFldFFAirline)
            }
            cell.btnBaggage.tag = indexPath.row
            cell.btnAddOn.tag = indexPath.row
            cell.btnExistingUser.tag = indexPath.row
            
            cell.btnBaggage.addTarget(self, action: #selector(self.baggageOnPress(sender:)), for: .touchUpInside)
            cell.btnAddOn.addTarget(self, action: #selector(self.addOnPress(sender:)), for: .touchUpInside)
            cell.btnGST.addTarget(self, action: #selector(self.gstOnPress(sender:)), for: .touchUpInside)
            cell.btnExistingUser.addTarget(self, action: #selector(self.existingOnPress(sender:)), for: .touchUpInside)
            cell.btnSaveUser.addTarget(self, action: #selector(self.saveUserOnPress(sender:)), for: .touchUpInside)
            cell.txtState.addTarget(self, action: #selector(self.searchState(_:)), for: .editingChanged)
            cell.txtCity.addTarget(self, action: #selector(self.searchCity(_:)), for: .editingChanged)
            
            cell.txtFirstName.delegate = self
            cell.txtLastName.delegate = self
            cell.txtTitle.delegate = self
            cell.txtCountryCode.delegate = self
            cell.txtAddress.delegate = self
            cell.txtEmail.delegate = self
            cell.txtMobile.delegate = self
            cell.txtGender.delegate = self
            cell.txtDob.delegate = self
            cell.txtCity.delegate = self
            cell.txtCountry.delegate = self
            cell.txtGstEmail.delegate = self
            cell.txtState.delegate = self
            cell.txtSeatPreference.delegate = self
            cell.txtPassportIsuueDate.delegate = self
            cell.txtPassportExpDate.delegate = self
            cell.txtPassportNumber.delegate = self
            cell.txtFldGstPhone.delegate = self
            cell.txtGstNumber.delegate = self
            cell.txtGstCompanyName.delegate = self
            cell.txtCompanyAddress.delegate = self
            cell.txtFldFFNumber.delegate = self
            cell.txtFldFFAirline.delegate = self
            
            cell.txtSeatPreference.tag = indexPath.row
            cell.txtPassportIsuueDate.tag = indexPath.row
            cell.txtPassportExpDate.tag = indexPath.row
            cell.txtPassportNumber.tag = indexPath.row
            cell.txtFirstName.tag = indexPath.row
            cell.txtLastName.tag = indexPath.row
            cell.txtTitle.tag = indexPath.row
            cell.txtCountryCode.tag = indexPath.row
            cell.txtAddress.tag = indexPath.row
            cell.txtEmail.tag = indexPath.row
            cell.txtMobile.tag = indexPath.row
            cell.txtGender.tag = indexPath.row
            cell.txtDob.tag = indexPath.row
            cell.txtCity.tag = indexPath.row
            cell.txtCountry.tag = indexPath.row
            cell.txtGstEmail.tag = indexPath.row
            cell.txtState.tag = indexPath.row
            cell.btnSaveUser.tag = indexPath.row
            
            cell.txtFldFFNumber.tag = indexPath.row
            cell.txtFldFFAirline.tag = indexPath.row
            
            cell.txtGender.isUserInteractionEnabled = false
            cell.txtCountry.isUserInteractionEnabled = false
            
            //MARK: Set Passanger Data
            cell.txtFldFFNumber.text = indexData.ffNumber
            cell.txtFldFFAirline.text = indexData.ffAirline
            cell.txtFldGstPhone.text = indexData.gstCompanyContactNumber
            cell.txtGstEmail.text = indexData.gstCompanyEmail
            cell.txtGstNumber.text = indexData.gstNumber
            cell.txtGstCompanyName.text = indexData.gstCompanyName
            cell.txtCompanyAddress.text = indexData.gstAddress
            
            cell.txtFirstName.text = indexData.firstName
            cell.txtLastName.text = indexData.lastName
            cell.txtTitle.text = indexData.title
            cell.txtCountryCode.text = indexData.countryMobileCode
            if GetData.share.isOnwordBook() == true {
                LoaderClass.shared.ownwardMobileCode = indexData.countryMobileCode
            }
            // cell.txtAddress.text = indexData.address
            cell.txtEmail.text = indexData.email
            cell.txtMobile.text = indexData.mobile
            cell.txtGender.text = indexData.gender
            cell.txtDob.text = indexData.dob
            cell.txtCity.text = indexData.city
            cell.txtCountry.text = indexData.country
            cell.txtState.text = indexData.state
            cell.txtSeatPreference.text = indexData.seatPrefrance?.description ?? ""
            cell.txtPassportNumber.text = indexData.passportNumber
            cell.txtPassportExpDate.text = indexData.passportExpDate
            cell.txtPassportIsuueDate.text = indexData.passportIssueDate
            
            
            cell.lblPassangerIndex.text = "Passenger \(indexPath.row + 1)"
            cell.btnSaveUser.setImage(indexData.saveUser == true ? .checkMark() : .uncheckMark(), for: .normal)
            
            if indexPath.row+1 <= self.numberOfAdults{
                cell.lblAdultIndexCount.text = "(Adult \(indexPath.row+1)/\(self.numberOfAdults))"
            }else if indexPath.row+1 > self.numberOfAdults && indexPath.row+1 <= (self.numberOfAdults + self.numberOfChildren){
                cell.lblAdultIndexCount.text = "(Child \(indexPath.row-numberOfAdults+1)/\(self.numberOfChildren))"
            }else{
                cell.lblAdultIndexCount.text = "(Infant \(indexPath.row-numberOfAdults-numberOfChildren+1)/\(self.numberOfInfants))"
            }
            
            if indexData.isGST == true{
                cell.gstNumberView.isHidden = false
                cell.companyAddressView.isHidden = false
                cell.gstCompanyVIew.isHidden = false
                cell.gstEmailView.isHidden = false
                cell.vwCompanyPhone.isHidden = false
                cell.btnGST.setImage(.checkMark(), for: .normal)
            }else{
                cell.vwCompanyPhone.isHidden = true
                cell.gstEmailView.isHidden = true
                cell.gstNumberView.isHidden = true
                cell.companyAddressView.isHidden = true
                cell.gstCompanyVIew.isHidden = true
                cell.btnGST.setImage(.uncheckMark(), for: .normal)
            }
            cell.vwSaveMyCustomerList.isHidden = UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true
            cell.cnstSaveCustomer.constant = UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true ? 0 : 60
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == tblVwFairDetail {
            
            if isDomasticRountTrip {
                if section == dataFlight1[0].sSegments.count - 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FareFlightHeaderXIB().identifire) as! FareFlightHeaderXIB
                    cell.vwBackground.backgroundColor = .clear
                    cell.lblTitle.textColor = .black
                    let firstIndex = dataFlight1[0].sSegments[section].first
                    let lastIndex = dataFlight1[0].sSegments[section].last
                    cell.lblTitle.text = "\(firstIndex?.sOriginAirport.sCityName ?? "") - \(lastIndex?.sDestinationAirport.sCityName ?? "")".uppercased()
                    return cell
                }
                else if section == dataFlight1[0].sSegments.count + returnDataFlight[0].sSegments.count - 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FareFlightHeaderXIB().identifire) as! FareFlightHeaderXIB
                    cell.vwBackground.backgroundColor = .clear
                    cell.lblTitle.textColor = .black
                    let firstIndex = returnDataFlight[0].sSegments[0].first
                    let lastIndex = returnDataFlight[0].sSegments[0].last
                    
                    cell.lblTitle.text = "\(firstIndex?.sOriginAirport.sCityName ?? "") - \(lastIndex?.sDestinationAirport.sCityName ?? "")".uppercased()
                    return cell
                }
                else {
                    return nil
                }
            } else {
                if section != self.dataFlight1[0].sSegments.count {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FareFlightHeaderXIB().identifire) as! FareFlightHeaderXIB
                    cell.vwBackground.backgroundColor = .clear
                    cell.lblTitle.textColor = .black
                    let firstIndex = self.dataFlight1[0].sSegments[section].first
                    let lastIndex = self.dataFlight1[0].sSegments[section].last
                    cell.lblTitle.text = "\(firstIndex?.sOriginAirport.sCityName ?? "") - \(lastIndex?.sDestinationAirport.sCityName ?? "")".uppercased()
                    
                    return cell
                } else {
                    return nil
                }
            }
        } else {
            let view = UIView()
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblVwFairDetail {
            if isDomasticRountTrip {
                return section == dataFlight1[0].sSegments.count - 1 || section == dataFlight1[0].sSegments.count + returnDataFlight[0].sSegments.count - 1 ? UITableView.automaticDimension : 0
            } else {
                return section != self.dataFlight1[0].sSegments.count ? UITableView.automaticDimension : 0
            }
        } else {
            return 0//UITableView.automaticDimension
        }
    }
    
    @objc func searchCity(_ sender: SearchTextField) {

        self.selectedTextFeild = sender
        
        let string = sender.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20") ?? ""
        
        if string.isEmpty == true{
            return
        }
        
        let arr = viewModel.arrCity.filter { $0.lowercased().contains(string.lowercased()) }
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.tblVwPassenges.cellForRow(at: indexPath) as! PassangerDetailXIB
        
        cell.txtCity.theme = SearchTextFieldTheme.lightTheme()
        cell.txtCity.theme.font = UIFont.systemFont(ofSize: 12)
        cell.txtCity.theme.bgColor = UIColor.white
        cell.txtCity.theme.fontColor = UIColor.theamColor()
        cell.txtCity.theme.cellHeight = 40
        cell.txtCity.filterStrings(arr)
        cell.txtCity.itemSelectionHandler = { filteredResults, itemPosition in
            DispatchQueue.main.async {
                cell.txtCity.text = arr[itemPosition]
                cell.txtCity.resignFirstResponder()
            }
        }
    }
    
    @objc func searchState(_ sender: SearchTextField) {

        self.selectedTextFeild = sender
        
        let string = sender.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20") ?? ""
        
        if string.isEmpty == true{
            return
        }
        
        let arr = viewModel.arrState.filter { $0.name?.lowercased().contains(string.lowercased()) ?? false }
        var arr1 = [String]()
        
        arr.forEach({ val in
            arr1.append(val.name ?? "")
        })
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.tblVwPassenges.cellForRow(at: indexPath) as! PassangerDetailXIB
        
        cell.txtState.theme = SearchTextFieldTheme.lightTheme()
        cell.txtState.theme.font = UIFont.systemFont(ofSize: 12)
        cell.txtState.theme.bgColor = UIColor.white
        cell.txtState.theme.fontColor = UIColor.theamColor()
        cell.txtState.theme.cellHeight = 40
        cell.txtState.filterStrings(arr1)
        cell.txtState.itemSelectionHandler = { filteredResults, itemPosition in
            DispatchQueue.main.async {
                cell.txtState.text = arr[itemPosition].name
                self.viewModel.searchCityApi("\(self.countryCode)-\(arr[itemPosition].code ?? "")", view: self)
                cell.txtState.resignFirstResponder()
            }
        }
    }
}

extension PassangerDetailsVC:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let indexPath = IndexPath(row: textField.tag, section: 0)
        let cell = self.tblVwPassenges.cellForRow(at: indexPath) as! PassangerDetailXIB
        if textField == cell.txtGstNumber || textField == cell.txtMobile || textField == cell.txtFldGstPhone{
            let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            if newText.count > 15 {
                return false
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexPath = IndexPath(row: textField.tag, section: 0)
        let cell = self.tblVwPassenges.cellForRow(at: indexPath) as! PassangerDetailXIB
        
        cell.border.borderColor = UIColor.darkGray.cgColor
        
        cell.border.frame = CGRect(x: 0, y: textField.frame.size.height - cell.lineHeight, width:  textField.frame.size.width, height: textField.frame.size.height)
        cell.border.borderWidth = cell.lineHeight
        textField.layer.addSublayer(cell.border)
        textField.layer.masksToBounds = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let indexPath = IndexPath(row: textField.tag, section: 0)
        
        let cell = self.tblVwPassenges.cellForRow(at: indexPath) as! PassangerDetailXIB
        
        if textField == cell.txtTitle {
            self.showShortDropDown(textFeild: textField, data: GetData.share.getUserTitle())
            return false
        }else if textField == cell.txtGender {
            self.showShortDropDown(textFeild: textField, data: GetData.share.getGender())
            return false
        }else if textField == cell.txtDob {
            view.endEditing(true)
            textField.resignFirstResponder()
            self.selectedIndex = textField.tag
            self.typeOfPassport = ""
            self.openDateCalendar()
            return false
        }else if textField == cell.txtPassportIsuueDate {
            textField.resignFirstResponder()
            self.selectedIndex = textField.tag
            self.typeOfPassport = "issue"
            self.openDateCalendar()
            return false
        }else if textField == cell.txtPassportExpDate {
            textField.resignFirstResponder()
            self.selectedIndex = textField.tag
            self.typeOfPassport = "exp"
            self.openDateCalendar()
            return false
        }else if textField == cell.txtCountryCode {
            view.endEditing(true)
            textField.resignFirstResponder()
            self.selectedIndex = textField.tag
            CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
                textField.text = country.dialingCode ?? ""
                self.passangerDetails[textField.tag].countryMobileCode = country.dialingCode ?? ""
                self.passangerDetails[textField.tag].countryCode = country.countryCode
                self.passangerDetails[textField.tag].country = country.countryName
                self.passangerDetails[textField.tag].nationality = country.countryCode
                self.countryCode = country.countryCode
                self.viewModel.searchStateApi(country.countryCode, view: self)
                self.tblVwPassenges.reloadData()
            }
            return false
        }else if textField == cell.txtSeatPreference {
            var  descriptionData = self.ssrData?.ssr?.response?.seatPreference?.map{ $0.description ?? "" } ?? []
            descriptionData.insert("No Preference", at: 0)
            self.showShortDropDown(textFeild: textField, data: descriptionData)
            return false
        } else if textField == cell.txtCity {
            if cell.txtState.text == "" {
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
        let cell = self.tblVwPassenges.cellForRow(at: indexPath) as! PassangerDetailXIB
        
        cell.border.borderColor = UIColor.customPink().cgColor
        
        cell.border.frame = CGRect(x: 0, y: textField.frame.size.height - cell.lineHeight, width:  textField.frame.size.width, height: textField.frame.size.height)
        cell.border.borderWidth = cell.lineHeight
        textField.layer.addSublayer(cell.border)
        textField.layer.masksToBounds = true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if let cell = self.tblVwPassenges.cellForRow(at: IndexPath(row: textField.tag, section: 0)) as? PassangerDetailXIB {
            cell.border.borderColor = UIColor.darkGray.cgColor
            
            cell.border.frame = CGRect(x: 0, y: textField.frame.size.height - cell.lineHeight, width:  textField.frame.size.width, height: textField.frame.size.height)
            cell.border.borderWidth = cell.lineHeight
            textField.layer.addSublayer(cell.border)
            textField.layer.masksToBounds = true
            
            self.passangerDetails[textField.tag].ffNumber = cell.txtFldFFNumber.text ?? ""
            self.passangerDetails[textField.tag].ffAirline = cell.txtFldFFAirline.text ?? ""
            self.passangerDetails[textField.tag].title = cell.txtTitle.text ?? ""
            self.passangerDetails[textField.tag].firstName = cell.txtFirstName.text ?? ""
            self.passangerDetails[textField.tag].lastName = cell.txtLastName.text ?? ""
            self.passangerDetails[textField.tag].dob = cell.txtDob.text ?? ""
            self.passangerDetails[textField.tag].gender = cell.txtGender.text ?? ""
            self.passangerDetails[textField.tag].email = cell.txtEmail.text ?? ""
            self.passangerDetails[textField.tag].countryMobileCode = cell.txtCountryCode.text ?? ""
            self.passangerDetails[textField.tag].mobile = cell.txtMobile.text ?? ""
            self.passangerDetails[textField.tag].address = cell.txtAddress.text ?? ""
            self.passangerDetails[textField.tag].country = cell.txtCountry.text ?? ""
            self.passangerDetails[textField.tag].state = cell.txtState.text ?? ""
            self.passangerDetails[textField.tag].city = cell.txtCity.text ?? ""
            self.passangerDetails[textField.tag].gstNumber = cell.txtGstNumber.text ?? ""
            self.passangerDetails[textField.tag].gstAddress = cell.txtCompanyAddress.text ?? ""
            self.passangerDetails[textField.tag].gstCompanyName = cell.txtGstCompanyName.text ?? ""
            self.passangerDetails[textField.tag].gstCompanyEmail = cell.txtGstEmail.text ?? ""
            self.passangerDetails[textField.tag].gstCompanyContactNumber = cell.txtFldGstPhone.text ?? ""
            self.passangerDetails[textField.tag].passportNumber = cell.txtPassportNumber.text ?? ""
            self.passangerDetails[textField.tag].passportExpDate = cell.txtPassportExpDate.text ?? ""
            self.passangerDetails[textField.tag].passportIssueDate = cell.txtPassportIsuueDate.text ?? ""
            self.tblVwPassenges.reloadData()
        }
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
            let cell = self.tblVwPassenges.cellForRow(at: indexPath) as! PassangerDetailXIB
            
            // Action triggered on selection
            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
                if textFeild == cell.txtTitle{
                    self.passangerDetails[textFeild.tag].title = item
                    self.passangerDetails[textFeild.tag].gender = GetData.share.getGenderData(string: item)
                }else if textFeild == cell.txtSeatPreference{
                    if index != 0{
                        self.passangerDetails[textFeild.tag].seatPrefrance = self.ssrData?.ssr?.response?.seatPreference?[index - 1]
                    }else{
                        self.passangerDetails[textFeild.tag].seatPrefrance?.description = "No Preference"
                    }
                }
                self.tblVwPassenges.reloadData()
            }
            self.dropDown.show()
        }
    }
}

extension PassangerDetailsVC:BaggageAndMealDetails{
    
    func baggageAndMealDetails(index: Int, mealCode: String, mealDesecription: String, baggageCode: String, baggageDescription: String, baggage: Any, meal: Any,mealPrice: Double, baggagePrice: Double) {
        
        self.baggagePrice = baggagePrice
        self.mealPrice = mealPrice
        
        if self.ssrData?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
            var price = 0
            if let meal = meal as? MealDynamic{
                self.passangerDetails[index].lccMealData = meal
                price = price + (meal.price ?? 0)
            }
            if let baggage = baggage as? Baggage{
                self.passangerDetails[index].lccBaggageData = baggage
                price = price + (baggage.price ?? 0)
            }
            self.passangerDetails[index].baggageAndMealPrice = Double(price)
        }else{
            if let meal = meal as? Meal{
                self.passangerDetails[index].nonLccMealData = meal
            }
            if let baggage = baggage as? BaggageNonLCC{
                self.passangerDetails[index].nonLccBaggageData = baggage
            }
        }
    }
    
    func openDateCalendar() {
        if let calendar = UIStoryboard.init(name: ViewControllerType.WWCalendarTimeSelector.rawValue, bundle: nil).instantiateInitialViewController() as? WWCalendarTimeSelector {
            view.endEditing(true)
            calendar.delegate = self
          
            if self.typeOfPassport == "exp" {
                calendar.optionCurrentDate = self.passangerDetails[self.selectedIndex].passportExpDate == "" ? Date() : returnDate(self.passangerDetails[self.selectedIndex].passportExpDate, strFormat: "MMM dd, yyyy")
            }else if self.typeOfPassport == "issue" {
                calendar.optionCurrentDate = self.passangerDetails[self.selectedIndex].passportIssueDate == "" ? Date() : returnDate(self.passangerDetails[self.selectedIndex].passportIssueDate, strFormat: "MMM dd, yyyy")
            }else{
                calendar.optionCurrentDate = self.passangerDetails[self.selectedIndex].dob == "" ? Date() : returnDate(self.passangerDetails[self.selectedIndex].dob, strFormat: "MMM dd, yyyy")
            }
            calendar.optionStyles.showDateMonth(true)
            calendar.optionStyles.showMonth(false)
            calendar.optionStyles.showYear(true)
            calendar.optionStyles.showTime(false)
            calendar.optionButtonShowCancel = true
            self.present(calendar, animated: true, completion: nil)
        }
    }
}

// MARK: - WWCALENDARTIMESELECTOR DELEGATE
extension PassangerDetailsVC: WWCalendarTimeSelectorProtocol {
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        if self.typeOfPassport == "exp" {
            self.passangerDetails[self.selectedIndex].passportExpDate = self.convertDateWithDateFormater("MMM dd, yyyy", date)
        }else if self.typeOfPassport == "issue" {
            self.passangerDetails[self.selectedIndex].passportIssueDate = self.convertDateWithDateFormater("MMM dd, yyyy",date)
        }else{
            self.passangerDetails[self.selectedIndex].dob = self.convertDateWithDateFormater("MMM dd, yyyy",date)
        }
        
        self.tblVwPassenges.reloadData()
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        if date > Date() && self.typeOfPassport != "exp"{
            return false
        } else if date < Date() && self.typeOfPassport == "exp"{
            return false
        } else {
            return true
        }
    }
}
