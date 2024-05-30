//
//  FareDetailsVC.swift
//  LeaveCasa
//
//  Created by acme on 21/11/22.
//

import UIKit
import IBAnimatable
import AMPopTip

protocol FlightBookingDelegate {
    func applyCoupon(discount: Double, couponCode: String, couponId: Int)
}
var flightBookingDelegate: FlightBookingDelegate?

class FareDetailsVC: UIViewController, FlightBookingDelegate {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var lblCouponName: UILabel!
    @IBOutlet weak var priceBottomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwCouponApplied: AnimatableView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPromoCode: UILabel!
    //MARK: - Variables
    var searchParams: [String: Any] = [:]
    var calenderParam: [String: Any] = [:]
    var markups = [Markup]()
    var dataFlight = [Flight]()
    var couponData = [CouponData]()
    var arrFlightsWithoutFilter = [Flight]()
    var logId = 0
    var tokenId = ""
    var traceId = ""
    var searchFlight = [FlightStruct]()
    var returnDataFlight = [Flight]()
    var isDomasticRountTrip = false
    var isInternationalRountTrip = false
    var numberOfAdults = 1
    var numberOfChildren = 0
    var numberOfInfants = 0
    var discount = Double()
    var couponCode = ""
    var couponId = 0
    var convenientFee = Double()
    var isMultiCity = false
    var convenientFee2 = Double()
    var conBifurcation = Double()
    var conBifurcation2 = Double()
    var taxk3 = Double()
    var taxK3Return = Double()
    var selectedTab = 0
    var popTip = PopTip()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        lblPromoCode.text = UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true ? "Login to access amazing offers" : "Promo-code/Bank offers"
        self.setupTableview()
        flightBookingDelegate = self
        if isDomasticRountTrip {
            var markup = markups.filter({$0.airline == dataFlight[0].sSegments[0].first?.sAirline.sAirlineCode}).first ?? Markup()
            if markup.amountBy == "" {
                markup = markups.filter({$0.airline == "all"}).first ?? Markup()
            }
            if markup.amountBy == Strings.PERCENT {
                let price = (dataFlight[0].sPrice * markup.amount)/100
                conBifurcation = (price * 18)/100
                convenientFee = 236//(price+conBifurcation).rounded()
            } else {
                let markup1 = (markup.amount)
                conBifurcation = (markup.amount * 18)/100
                convenientFee = 236 //(markup1+conBifurcation).rounded()
            }
            var markup1 = markups.filter({$0.airline == returnDataFlight[0].sSegments[0].first?.sAirline.sAirlineCode}).first ?? Markup()
            if markup1.amountBy == "" {
                markup1 = markups.filter({$0.airline == "all"}).first ?? Markup()
            }
            if markup1.amountBy == Strings.PERCENT {
                let price1 = (returnDataFlight[0].sPrice * markup1.amount)/100
                conBifurcation2 = (price1 * 18)/100
                convenientFee2 = 236//(price1+conBifurcation2).rounded()
            } else {
                let markup2 = (markup1.amount)
                conBifurcation2 = (markup1.amount * 18)/100
                convenientFee2 = 236//(markup2+conBifurcation2).rounded()
            }
            let finalPrice = (dataFlight[0].sFare.sBaseFare+convenientFee+returnDataFlight[0].sFare.sBaseFare+convenientFee2+(dataFlight[0].sFare.sPublishedFare - dataFlight[0].sFare.sBaseFare)+(returnDataFlight[0].sFare.sPublishedFare - returnDataFlight[0].sFare.sBaseFare)-self.discount).rounded()
            self.lblPrice.text = "₹\(LoaderClass.shared.commaSeparatedPrice(val: Int(finalPrice)))"
        } else {
            var markup = markups.filter({$0.airline == dataFlight[0].sSegments[0].first?.sAirline.sAirlineCode}).first ?? Markup()
            if markup.amountBy == "" {
                markup = markups.filter({$0.airline == "all"}).first ?? Markup()
            }
            if markup.amountBy == Strings.PERCENT {
                let price = (dataFlight[0].sPrice * markup.amount)/100
                conBifurcation = (price * 18)/100
                convenientFee = selectedTab == 1 ? 472 : 236//(price+conBifurcation).rounded()
            } else {
                let markup1 = (markup.amount)
                conBifurcation = (markup.amount * 18)/100
                convenientFee = selectedTab == 1 ? 472 : 236//(markup1+conBifurcation).rounded()
            }
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedPrice = numberFormatter.string(from: NSNumber(value: (dataFlight[0].sPrice+convenientFee+(dataFlight[0].sFare.sPublishedFare - dataFlight[0].sPrice)-self.discount)))
            
            self.lblPrice.text = "₹\(formattedPrice ?? "")"
        }
        
    }
    //MARK: - Custom methods
    func setupTableview() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.ragisterNib(nibName: FareFlightXIB().identifire)
        //self.tableView.ragisterNib(nibName: SecureTripXIB().identifire)
        self.tableView.ragisterNib(nibName: FareFlightHeaderXIB().identifire)
    }
    //MARK: - @IBActions
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
//    var isDomasticRountTrip = false
//    var dataFlight1 = [Flight]()
//    var isMultiCity = false
    @IBAction func continuePressed(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .SelectFareVC, StoryboardName: .Flight) as? SelectFareVC {
            vc.couponData = couponData
            vc.isMultipleCity = self.isMultiCity
            vc.isDomasticRountTrip = isDomasticRountTrip
            vc.returnDataFlight = returnDataFlight
            vc.dataFlight = dataFlight
            vc.arrFlightWithoutFilter = arrFlightsWithoutFilter
            vc.logId = self.logId
            vc.tokenId = self.tokenId
            vc.traceId = self.traceId
            vc.searchFlight = self.searchFlight
            vc.numberOfAdults = self.numberOfAdults
            vc.numberOfChildren = self.numberOfChildren
            vc.numberOfInfants = self.numberOfInfants
            vc.discount = self.discount
            vc.searchParams = searchParams
            vc.calenderParam = calenderParam
            vc.selectedTab = selectedTab
            vc.totalPrice = isDomasticRountTrip ? "₹\(Int((dataFlight[0].sFare.sBaseFare+convenientFee+(dataFlight[0].sFare.sPublishedFare - dataFlight[0].sFare.sBaseFare)-self.discount).rounded()))" : lblPrice.text ?? ""
            vc.basePrice = dataFlight[0].sFare.sBaseFare
            vc.convenientFee = convenientFee
            vc.conBifurcation = conBifurcation
            vc.taxes = dataFlight[0].sFare.sPublishedFare - dataFlight[0].sFare.sBaseFare
            dataFlight[0].sFare.sTaxBreakup.forEach { val in
                if val.sKey == "K3" {
                    vc.taxesK3 = val.sValue
                    taxk3 = val.sValue
                }
            }
            
            if isDomasticRountTrip {
                vc.conBifurcation2 = conBifurcation2
                vc.returnBasePrice = returnDataFlight[0].sFare.sBaseFare
                vc.returnPublishedPrice = returnDataFlight[0].sFare.sPublishedFare
                vc.returnConvenientFee = selectedTab == 1 ? 236 : 236//convenientFee2
                vc.returnTaxes = returnDataFlight[0].sFare.sPublishedFare - returnDataFlight[0].sFare.sBaseFare
                
                returnDataFlight[0].sFare.sTaxBreakup.forEach { val in
                    if val.sKey == "K3" {
                        vc.taxesK3Return = val.sValue
                        taxK3Return = val.sValue
                    }
                }
            }
            self.pushView(vc: vc)
        }
    }
    
    @IBAction func offerOnPress(_ sender: UIButton) {
        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true {
            let vc = ViewControllerHelper.getViewController(ofType: .GuestLoginVC, StoryboardName: .Main) as! GuestLoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if let vc = ViewControllerHelper.getViewController(ofType: .CouponVC, StoryboardName: .Hotels) as? CouponVC {
                vc.isFromFlight = true
                self.present(vc, animated: true)
            }
        }
    }
    
    @IBAction func actionRemoveCoupon(_ sender: UIButton) {
        vwCouponApplied.isHidden = true
        self.discount = 0
        
        if isDomasticRountTrip {
            let finalPrice = (dataFlight[0].sFare.sBaseFare+convenientFee+returnDataFlight[0].sPrice+convenientFee2+(dataFlight[0].sFare.sPublishedFare - dataFlight[0].sFare.sBaseFare)+(returnDataFlight[0].sFare.sPublishedFare - returnDataFlight[0].sFare.sBaseFare)-self.discount).rounded()
            self.lblPrice.text = "₹\(LoaderClass.shared.commaSeparatedPrice(val: Int(finalPrice)))"
        } else {
            self.lblPrice.text = "₹\(String(format: "%.0f", dataFlight[0].sFare.sBaseFare+convenientFee+(dataFlight[0].sFare.sPublishedFare - dataFlight[0].sFare.sBaseFare)-discount))"
        }
    }
    @IBAction func actionFareBreakup(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .FareBrakeupVC, StoryboardName: .Flight) as? FareBrakeupVC {
            vc.discount = self.discount
            
            if isDomasticRountTrip {
                vc.basePrice = dataFlight[0].sFare.sBaseFare + returnDataFlight[0].sFare.sBaseFare
                vc.convenientFee = 472//convenientFee + convenientFee2
                vc.taxes = (dataFlight[0].sFare.sPublishedFare - dataFlight[0].sFare.sBaseFare) + (returnDataFlight[0].sFare.sPublishedFare - returnDataFlight[0].sFare.sBaseFare)
                vc.taxesK3 = taxK3Return //dataFlight[0].sFare.sYQTax + returnDataFlight[0].sFare.sYQTax
                vc.conBirfurcation = conBifurcation + conBifurcation2
            } else {
                vc.basePrice = dataFlight[0].sFare.sBaseFare
                vc.convenientFee = selectedTab == 1 ? 472 : 236//convenientFee
                vc.taxes = dataFlight[0].sFare.sPublishedFare - dataFlight[0].sFare.sBaseFare
                vc.taxesK3 = taxk3 //dataFlight[0].sFare.sYQTax
                vc.conBirfurcation = conBifurcation
            }
            self.present(vc, animated: true)
        }
    }
    //MARK: - Coupon Delegate Method
    func applyCoupon(discount: Double, couponCode: String, couponId: Int) {
        
        if isDomasticRountTrip {
            let finalPrice = (dataFlight[0].sPrice+convenientFee+returnDataFlight[0].sPrice+convenientFee2+(dataFlight[0].sFare.sPublishedFare - dataFlight[0].sPrice)+(returnDataFlight[0].sFare.sPublishedFare - returnDataFlight[0].sPrice)-discount).rounded()
            self.lblPrice.text = "₹\(LoaderClass.shared.commaSeparatedPrice(val: Int(finalPrice)))"
        } else {
            self.lblPrice.text = "₹\(String(format: "%.0f", dataFlight[0].sPrice+convenientFee+(dataFlight[0].sFare.sPublishedFare - dataFlight[0].sPrice)-discount))"
        }
        self.discount = discount
        self.couponCode = couponCode
        self.couponId = couponId
        self.lblCouponName.text = couponCode
        self.vwCouponApplied.isHidden = false
        let vc = ViewControllerHelper.getViewController(ofType: .CouponAppliedVC, StoryboardName: .Bus) as! CouponAppliedVC
        vc.couponPrize = "\(Int(discount))"
        
        self.present(vc, animated: true)
        // self.setupPriceDetails(priceDetails: self.hotleRate ?? HotelRate())
    }
    
    //...... Will be used in Future......
    
    //    @objc func handleSecureTap(_ sender: UIButton) {
    //        let indexPath = IndexPath(row: 0, section: dataFlight[0].sSegments.count)
    //        if let cell = tableView.cellForRow(at: indexPath) as? SecureTripXIB {
    //            cell.btnSecure.setImage(UIImage.checkMark(), for: .normal)
    //            cell.btnUnsecure.setImage(UIImage.uncheckMark(), for: .normal)
    //        }
    //    }
    
    //    @objc func handleUnsecureTap(_ sender: UIButton) {
    //        let indexPath = IndexPath(row: 0, section: dataFlight[0].sSegments.count)
    //        if let cell = tableView.cellForRow(at: indexPath) as? SecureTripXIB {
    //            cell.btnSecure.setImage(UIImage.uncheckMark(), for: .normal)
    //            cell.btnUnsecure.setImage(UIImage.checkMark(), for: .normal)
    //        }
    //    }
}

extension FareDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isDomasticRountTrip == true ? dataFlight[0].sSegments.count + returnDataFlight[0].sSegments.count  : dataFlight[0].sSegments.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMultiCity {
            return dataFlight[0].sSegments[section].count
        } else {
            var ret = 0
            if isDomasticRountTrip {
                if section == dataFlight[0].sSegments.count - 1 {
                    for i in 0..<dataFlight[0].sSegments.count {
                        ret = dataFlight[0].sSegments[i].count
                    }
                } else if section == dataFlight[0].sSegments.count + returnDataFlight[0].sSegments.count - 1 {
                    for i in 0..<returnDataFlight[0].sSegments.count {
                        ret = returnDataFlight[0].sSegments[i].count
                    }
                } else {
                    ret = 1
                }
            } else {
                if section != dataFlight[0].sSegments.count {
                   // for i in 0..<dataFlight[0].sSegments.count {
                        ret = dataFlight[0].sSegments[section].count
                  //  }
                }
                else {
                    ret = 1
                }
            }
            return ret
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isDomasticRountTrip {
            if indexPath.section == dataFlight[0].sSegments.count - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: FareFlightXIB().identifire, for: indexPath) as! FareFlightXIB
                
                if dataFlight[0].sSegments[indexPath.section].count > 1 {
                    cell.btnFlight.tag = indexPath.row
                  //  cell.btnFlight.accessibilityLabel = "\(indexPath.row)"
                    cell.btnFlight.addTarget(self, action: #selector(actionFlightPopOver(_ :)), for: .touchUpInside)
                   // cell.lblAircraftType.text = dataFlight[0].sSegments[indexPath.section].first?.sAirline.sAirlineName == dataFlight[1].sSegments[indexPath.section].first?.sAirline.sAirlineName ? "Same\nAircraft" : "Change\nAircraft"
                    
                    cell.lblAircraftType.text =  "\(dataFlight[0].sSegments[indexPath.section].first?.sAirline.sFlightNumber ?? "") \(dataFlight[0].sSegments[indexPath.section].first?.sAirline.sFareClass ?? "")" == "\(dataFlight[0].sSegments[indexPath.section].last?.sAirline.sFlightNumber ?? "") \(dataFlight[0].sSegments[indexPath.section].last?.sAirline.sFareClass ?? "")" ? "Same\nAircraft" : "Change\nAircraft"
                    
                    if indexPath.row == dataFlight[0].sSegments[indexPath.section].count - 1 {
                        cell.imgMultipleFlights.isHidden = true
                        cell.lblLayoverTime.isHidden = true
                        cell.lblAircraftType.isHidden = true
                        
                    } else {
                        cell.imgMultipleFlights.isHidden = false
                        cell.lblLayoverTime.isHidden = false
                        cell.lblAircraftType.isHidden = false
                        
                        var haltTime = Int()
                        if ((dataFlight[0].sSegments[indexPath.section].last?.sAccDuration ?? 0) - (dataFlight[0].sSegments[indexPath.section].last?.sDuration ?? 0) - (dataFlight[0].sSegments[indexPath.section].first?.sDuration ?? 0)) < 0 {
                            haltTime = ((dataFlight[0].sSegments[indexPath.section].last?.sAccDuration ?? 0) - (dataFlight[0].sSegments[indexPath.section].last?.sDuration ?? 0) - (dataFlight[0].sSegments[indexPath.section].first?.sDuration ?? 0)) * -1
                        } else {
                            haltTime = ((dataFlight[0].sSegments[indexPath.section].last?.sAccDuration ?? 0) - (dataFlight[0].sSegments[indexPath.section].last?.sDuration ?? 0) - (dataFlight[0].sSegments[indexPath.section].first?.sDuration ?? 0))
                        }
                        
                        cell.lblLayoverTime.text = "Layover Time\n\(haltTime.getDuration())"
                    }
                } else {
                    cell.lblLayoverTime.isHidden = true
                    cell.lblAircraftType.isHidden = true
                    cell.imgMultipleFlights.isHidden = true
                }
                
                cell.viewPink.isHidden = indexPath.row != 0
                cell.lblDate.isHidden = dataFlight[0].sSegments[indexPath.section].count > 1 && isMultiCity == false ? false : true
                let firstIndex = dataFlight[0].sSegments[indexPath.section][indexPath.row]
                cell.lblFlightName.text = firstIndex.sAirline.sAirlineName
                cell.imgFlight.image = UIImage.init(named: firstIndex.sAirline.sAirlineCode)
                
                
                
                cell.lblCabbinBaggage.text = "\(firstIndex.sCabinBaggage == "Included" ? firstIndex.sCabinBaggage : "\(firstIndex.sCabinBaggage) (Included)")"
                cell.lblCheckinBaggage.text = "\(firstIndex.sBaggage == "Included" ? firstIndex.sBaggage : "\(firstIndex.sBaggage) (Included)")"
                
                cell.lblTitleCode.text = "\(firstIndex.sAirline.sAirlineCode) - \(firstIndex.sAirline.sFlightNumber) \(firstIndex.sAirline.sFareClass)"
                
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
            } else if indexPath.section == dataFlight[0].sSegments.count + returnDataFlight[0].sSegments.count - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: FareFlightXIB().identifire, for: indexPath) as! FareFlightXIB
                
                if returnDataFlight[0].sSegments[0].count > 1 {
                    cell.imgMultipleFlights.isHidden = indexPath.row == returnDataFlight[0].sSegments[0].count - 1
                } else {
                    cell.imgMultipleFlights.isHidden = true
                }
                cell.viewPink.isHidden = indexPath.row != 0
                
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
                
                cell.lblToFlightCode.text = firstIndex.sDestinationArrvTime.convertDateWithString("EEE,dd MMM yy",oldFormat: "yyyy-MM-dd'T'HH:mm:ss")
                cell.lblFlightFromCode.text = firstIndex.sOriginDeptTime.convertDateWithString("EEE,dd MMM yy",oldFormat: "yyyy-MM-dd'T'HH:mm:ss")
                
                cell.lblDestinationCity.text = firstIndex.sDestinationAirport.sCityName
                cell.lblSourceCity.text = firstIndex.sOriginAirport.sCityName
                
                cell.lblSourceTerminal.text = "\(firstIndex.sOriginAirport.sAirportName)\nTerminal \(firstIndex.sOriginAirport.sTerminal)"
                cell.lblDestinationTerminal.text = "\(firstIndex.sDestinationAirport.sAirportName)\nTerminal \(firstIndex.sDestinationAirport.sTerminal)"
                
                return cell
            }
        } else {
            if indexPath.section != self.dataFlight[0].sSegments.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: FareFlightXIB().identifire, for: indexPath) as! FareFlightXIB
                cell.btnFlight.tag = indexPath.row
              //  cell.btnFlight.accessibilityLabel = "\(indexPath.row)"
                cell.btnFlight.addTarget(self, action: #selector(actionFlightPopOver(_ :)), for: .touchUpInside)
                if dataFlight[0].sSegments[indexPath.section].count > 1 {
                    if indexPath.row == dataFlight[0].sSegments[indexPath.section].count - 1 {
                        cell.imgMultipleFlights.isHidden = true
                        cell.lblLayoverTime.isHidden = true
                        cell.lblAircraftType.isHidden = true
                    }
                    else {
                        cell.imgMultipleFlights.isHidden = false
                        cell.lblLayoverTime.isHidden = false
                        cell.lblAircraftType.isHidden = false
                        
                        var haltTime = Int()
                        if ((dataFlight[0].sSegments[indexPath.section].last?.sAccDuration ?? 0) - (dataFlight[0].sSegments[indexPath.section].last?.sDuration ?? 0) - (dataFlight[0].sSegments[indexPath.section].first?.sDuration ?? 0)) < 0 {
                            haltTime = ((dataFlight[0].sSegments[indexPath.section].last?.sAccDuration ?? 0) - (dataFlight[0].sSegments[indexPath.section].last?.sDuration ?? 0) - (dataFlight[0].sSegments[indexPath.section].first?.sDuration ?? 0)) * -1
                        } else {
                            haltTime = ((dataFlight[0].sSegments[indexPath.section].last?.sAccDuration ?? 0) - (dataFlight[0].sSegments[indexPath.section].last?.sDuration ?? 0) - (dataFlight[0].sSegments[indexPath.section].first?.sDuration ?? 0))
                        }
                        
                        cell.lblLayoverTime.text = "Layover Time\n\(haltTime.getDuration())"
                      //  cell.lblAircraftType.text = dataFlight[0].sSegments[indexPath.section].first?.sAirline.sAirlineName == dataFlight[0].sSegments[indexPath.section].last?.sAirline.sAirlineName ? "Same\nAircraft" : "Change\nAircraft"
                        cell.lblAircraftType.text = "\(dataFlight[0].sSegments[indexPath.section].first?.sAirline.sFlightNumber ?? "") \(dataFlight[0].sSegments[indexPath.section].first?.sAirline.sFareClass ?? "")" == "\(dataFlight[0].sSegments[indexPath.section].last?.sAirline.sFlightNumber ?? "") \(dataFlight[0].sSegments[indexPath.section].last?.sAirline.sFareClass ?? "")" ? "Same\nAircraft" : "Change\nAircraft"

                    }
                } else {
                    cell.lblLayoverTime.isHidden = true
                    cell.lblAircraftType.isHidden = true
                    cell.imgMultipleFlights.isHidden = true
                }
                cell.viewPink.isHidden = indexPath.row != 0
                cell.lblDate.isHidden = dataFlight[0].sSegments[indexPath.section].count > 1 && isMultiCity == false ? false : true
                if dataFlight[0].sSegments[indexPath.section].count > indexPath.row {
                    let firstIndex = dataFlight[0].sSegments[indexPath.section][indexPath.row]
                    
                    cell.lblFlightName.text = firstIndex.sAirline.sAirlineName
                    cell.imgFlight.image = UIImage.init(named: firstIndex.sAirline.sAirlineCode)
                    cell.lblCabbinBaggage.text = "\(firstIndex.sCabinBaggage == "Included" ? firstIndex.sCabinBaggage : "\(firstIndex.sCabinBaggage) (Included)")"
                    cell.lblCheckinBaggage.text = "\(firstIndex.sBaggage == "Included" ? firstIndex.sBaggage : "\(firstIndex.sBaggage) (Included)")"
                   
                    cell.lblDate.text = firstIndex.sOriginDeptTime.convertStoredDay()
                    cell.lblFromFlightTime.text = firstIndex.sOriginDeptTime.convertStoredDate()
                    cell.lblToflightTime.text = firstIndex.sDestinationArrvTime.convertStoredDate()
                    
                    cell.lblTotalTime.text = firstIndex.sDuration.getDuration()
                    
                    cell.lblTitleCode.text = "\(firstIndex.sAirline.sAirlineCode) - \(firstIndex.sAirline.sFlightNumber) \(firstIndex.sAirline.sFareClass)"
                    
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
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isDomasticRountTrip {
            if section == dataFlight[0].sSegments.count - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: FareFlightHeaderXIB().identifire) as! FareFlightHeaderXIB
                
                let firstIndex = dataFlight[0].sSegments[section].first
                let lastIndex = dataFlight[0].sSegments[section].last
                
                cell.lblTitle.text = "\(firstIndex?.sOriginAirport.sCityName ?? "") - \(lastIndex?.sDestinationAirport.sCityName ?? "")".uppercased()
                return cell
            }
            else if section == dataFlight[0].sSegments.count + returnDataFlight[0].sSegments.count - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: FareFlightHeaderXIB().identifire) as! FareFlightHeaderXIB
                
                let firstIndex = returnDataFlight[0].sSegments[0].first
                let lastIndex = returnDataFlight[0].sSegments[0].last
                
                cell.lblTitle.text = "\(firstIndex?.sOriginAirport.sCityName ?? "") - \(lastIndex?.sDestinationAirport.sCityName ?? "")".uppercased()
                return cell
            }
            else {
                return nil
            }
        } else {
            if section != self.dataFlight[0].sSegments.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: FareFlightHeaderXIB().identifire) as! FareFlightHeaderXIB
                
                let firstIndex = self.dataFlight[0].sSegments[section].first
                let lastIndex = self.dataFlight[0].sSegments[section].last
                
                cell.lblTitle.text = "\(firstIndex?.sOriginAirport.sCityName ?? "") - \(lastIndex?.sDestinationAirport.sCityName ?? "")".uppercased()
                
                return cell
            } else {
                return nil
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isDomasticRountTrip {
            return section == dataFlight[0].sSegments.count - 1 || section == dataFlight[0].sSegments.count + returnDataFlight[0].sSegments.count - 1 ? UITableView.automaticDimension : 0
        } else {
            return section != self.dataFlight[0].sSegments.count ? UITableView.automaticDimension : 0
        }
    }
    
    @objc func actionFlightPopOver(_ sender: UIButton){

        let firstIndex = dataFlight[0].sSegments[sender.tag][Int(sender.accessibilityLabel ?? "0") ?? 0]
        var haltTime = Int()
        if ((dataFlight[0].sSegments[sender.tag].last?.sAccDuration ?? 0) - (dataFlight[0].sSegments[sender.tag].last?.sDuration ?? 0) - (dataFlight[0].sSegments[sender.tag].first?.sDuration ?? 0)) < 0 {
            haltTime = ((dataFlight[0].sSegments[sender.tag].last?.sAccDuration ?? 0) - (dataFlight[0].sSegments[sender.tag].last?.sDuration ?? 0) - (dataFlight[0].sSegments[sender.tag].first?.sDuration ?? 0)) * -1
        } else {
            haltTime = ((dataFlight[0].sSegments[sender.tag].last?.sAccDuration ?? 0) - (dataFlight[0].sSegments[sender.tag].last?.sDuration ?? 0) - (dataFlight[0].sSegments[sender.tag].first?.sDuration ?? 0))
        }
        
        
        if let vc = ViewControllerHelper.getViewController(ofType: .TaxBifurcationVC, StoryboardName: .Flight) as? TaxBifurcationVC {
            vc.otherChagerOrOT = "Your layover is at \(firstIndex.sDestinationAirport.sCityName) for \(haltTime.getDuration()).\nYour aircraft will be \("\(dataFlight[0].sSegments[sender.tag].first?.sAirline.sFlightNumber ?? "") \(dataFlight[0].sSegments[sender.tag].first?.sAirline.sFareClass ?? "")" == "\(dataFlight[0].sSegments[sender.tag].last?.sAirline.sFlightNumber ?? "") \(dataFlight[0].sSegments[sender.tag].last?.sAirline.sFareClass ?? "")" ? "Same" : "Changed")\n "
            vc.tax = ""
            vc.titleStr = ""
            vc.title = "FareFlight"
            vc.view.backgroundColor = .lightGray
            LoaderClass.shared.presentPopover(self, vc, sender: sender, size: CGSize(width: 400, height: 45),arrowDirection: .any)
        }
        

    }
}
