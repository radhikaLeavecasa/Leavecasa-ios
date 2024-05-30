//
//  SelectFareVC.swift
//  LeaveCasa
//
//  Created by acme on 01/12/22.
//

import UIKit
import IBAnimatable

class SelectFareVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var onwordFlightDetailsView: AnimatableView!
    @IBOutlet weak var returnFlightDetailsView: AnimatableView!
    @IBOutlet weak var lblOnwordFlightDestinationCode: UILabel!
    @IBOutlet weak var lblOnwordPrice: UILabel!
    @IBOutlet weak var lblOnwordFlightCode: UILabel!
    @IBOutlet weak var lblOnwordFlightName: UILabel!
    @IBOutlet weak var imgOnwordFlight: UIImageView!
    @IBOutlet weak var lblOnwordFlightSourceTime: UILabel!
    @IBOutlet weak var lblOnwordFlightDestinationTime: UILabel!
    @IBOutlet weak var lblReturnFlightDestinationCode: UILabel!
    @IBOutlet weak var lblReturnPrice: UILabel!
    @IBOutlet weak var lblReturnFlightCode: UILabel!
    @IBOutlet weak var lblReturnFlightName: UILabel!
    @IBOutlet weak var imgReturnFlight: UIImageView!
    @IBOutlet weak var lblReturnFlightSourceTime: UILabel!
    @IBOutlet weak var lblReturnFlightDestinationTime: UILabel!
    
    //MARK: - Variables
    var selectedTab = 0
    var couponData = [CouponData]()
    var searchParams: [String: Any] = [:]
    var calenderParam: [String: Any] = [:]
    var selectedIndex : Int? = 0
    var dataFlight = [Flight]()
    var returnDataFlight = [Flight]()
    var arrFlightWithoutFilter = [Flight]()
    var isDomasticRountTrip = false
    var conBifurcation = Double()
    var conBifurcation2 = Double()
    var logId = 0
    var tokenId = ""
    var traceId = ""
    var searchFlight = [FlightStruct]()
    
    var numberOfAdults = 1
    var numberOfChildren = 0
    var numberOfInfants = 0
    
    var viewModel = SelectFareViewModel()
    var objSearchFlightVM = SearchFlightViewModel()

    var discount = Double()
    var totalPrice = String()
    var basePrice = Double()
    var convenientFee = Double()
    var taxes = Double()
    var taxesK3 = Double()
    var returnBasePrice = Double()
    var returnPublishedPrice = Double()
    var returnConvenientFee = Double()
    var returnTaxes = Double()
    var taxesK3Return = Double()
    var isMultipleCity = false
    var isFirstTimeReturn = true
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        var filteredArray = [Flight]()

        // Create a set to keep track of unique FlightNumbers
        var uniqueFlightNumbers = Set<Double>()

        // Iterate through each element in the array
        for element in dataFlight {
           
                // Check if the FlightNumber is unique
                if !uniqueFlightNumbers.contains(element.sFare.sPublishedFare) {
                    // Add the element to the filtered array
                    filteredArray.append(element)
                    // Add the FlightNumber to the set of unique FlightNumbers
                    uniqueFlightNumbers.insert(element.sFare.sPublishedFare)
            }
        }
        
        self.dataFlight = filteredArray
        self.lblPrice.text = totalPrice
        if GetData.share.isOnwordBook() == true {
            self.selectedIndex = 0
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.selectedIndex = 0
        if GetData.share.isReturnTrip() == true{
            
            DispatchQueue.main.async {
                if self.isDomasticRountTrip == true{
                    self.onwordFlightDetailsView.isHidden = false
                    self.returnFlightDetailsView.isHidden = false
                }else{
                    self.onwordFlightDetailsView.isHidden = true
                    self.returnFlightDetailsView.isHidden = true
                }
            }
            let tax = dataFlight[selectedIndex ?? 0].sFare.sPublishedFare - dataFlight[selectedIndex ?? 0].sFare.sBaseFare
            if GetData.share.isOnwordBook() == true {
                if isFirstTimeReturn {
                    self.selectedIndex = 0
                }
                self.onwordFlightDetailsView.alpha = 0.3
                self.returnFlightDetailsView.alpha = 1
                self.dataFlight = self.returnDataFlight
                let tax = dataFlight[selectedIndex ?? 0].sFare.sPublishedFare - dataFlight[selectedIndex ?? 0].sFare.sBaseFare
                lblPrice.text = "₹\(LoaderClass.shared.commaSeparatedPrice(val: Int((returnBasePrice+tax+returnConvenientFee).rounded())))"
                self.totalPrice = "\((returnBasePrice+tax+returnConvenientFee).rounded())"
                self.tableView.reloadData()
                isFirstTimeReturn = false
            } else {
                self.totalPrice = "\((dataFlight[selectedIndex ?? 0].sFare.sBaseFare+tax+convenientFee-discount).rounded())"
                self.onwordFlightDetailsView.alpha = 1
                self.returnFlightDetailsView.alpha = 0.3
            }
        }
        else {
            self.onwordFlightDetailsView.isHidden = true
            self.returnFlightDetailsView.isHidden = true
        }
        
        //self.lblPrice.text = "₹\(LoaderClass.shared.commaSeparatedPrice(val:Int(Double(totalPrice) ?? 0)))"
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }
    //MARK: - @IBActions
    @IBAction func backOnPress(_ sender: UIButton) {
        if GetData.share.isOnwordBook() == true {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: TabbarVC.self) {
                    if let vc = ViewControllerHelper.getViewController(ofType: .TabbarVC, StoryboardName: .Main) as? TabbarVC {
                        vc.Index = 2
                        self.setView(vc: vc, animation: false)
                    }
                }
            }
        } else {
            self.popView()
        }
    }
    
    @IBAction func continueOnPress(_ sender: UIButton) {
        LoaderClass.shared.loadAnimation()
        if GetData.share.isOnwordBook() == true {
            self.viewModel.getFareSSR(traceId: self.traceId, tokenId: self.tokenId, logId: "\(self.logId)", resultIndex: self.returnDataFlight[self.selectedIndex ?? 0].sResultIndex,view: self)
        } else {
            self.viewModel.getFareSSR(traceId: self.traceId, tokenId: self.tokenId, logId: "\(self.logId)", resultIndex: self.dataFlight[self.selectedIndex ?? 0].sResultIndex,view: self)
        }
    }
    @IBAction func actionChooseAnotherFare(_ sender: Any) {
        objSearchFlightVM.searchFlight(param: searchParams, selectedTab: selectedTab, array: searchFlight, sharedParam: calenderParam, view: self, couponData: couponData, isFareScreen: true)
    }
    
    @IBAction func breakUpOnPress(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .FareBrakeupVC, StoryboardName: .Flight) as? FareBrakeupVC {
            if GetData.share.isOnwordBook() == true {
                vc.basePrice = returnBasePrice //dataFlight[0].sFare.sBaseFare
                vc.convenientFee = returnConvenientFee
                
                vc.taxes = (returnDataFlight[selectedIndex ?? 0].sFare.sPublishedFare - returnDataFlight[selectedIndex ?? 0].sFare.sBaseFare).rounded()
                vc.taxesK3 = taxesK3Return
                vc.conBirfurcation = conBifurcation2
            } else {
                vc.discount = self.discount
                vc.basePrice = basePrice //dataFlight[0].sFare.sBaseFare
                vc.convenientFee = convenientFee
                vc.taxes = dataFlight[selectedIndex ?? 0].sFare.sPublishedFare - dataFlight[selectedIndex ?? 0].sFare.sBaseFare
                vc.taxesK3 = taxesK3
                vc.conBirfurcation = conBifurcation
            }
            self.present(vc, animated: true)
        }
    }
    
    //MARK: - Custom methods
    func setupTableView(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.ragisterNib(nibName: FareXIB().identifire)
        self.viewModel.delegate = self
        lblPrice.text = totalPrice
        self.setupFlightData()
    }
    
    func setupFlightData(){
        //MARK: Setup Onword Flight Data
        if GetData.share.isReturnTrip() == true{
           // if GetData.share.isOnwordBook() == true{
            if self.returnDataFlight.count > 0 {
                let returnData = self.returnDataFlight[self.selectedIndex ?? 0]
                
                self.lblReturnFlightCode.text = returnData.sSegments.first?.first?.sOriginAirport.sCityCode
                self.lblReturnFlightSourceTime.text = returnData.sSegments.first?.first?.sOriginDeptTime.convertStoredDate()
                self.lblReturnFlightDestinationCode.text = returnData.sSegments.first?.last?.sDestinationAirport.sCityCode
                self.lblReturnFlightDestinationTime.text = returnData.sSegments.first?.last?.sDestinationArrvTime.convertStoredDate()
                self.lblReturnFlightName.text = returnData.sSegments.first?.first?.sAirline.sAirlineName
                self.imgReturnFlight.image = UIImage.init(named: returnData.sSegments.first?.first?.sAirline.sAirlineCode ?? "")
                
                let returnPrice = returnData.sPrice
                self.lblReturnPrice.text = "₹\(LoaderClass.shared.commaSeparatedPrice(val: Int(returnPrice)))"
            }
            //}else{
                let ownowrdData = self.dataFlight[self.selectedIndex ?? 0]
                
                self.lblOnwordFlightCode.text = ownowrdData.sSegments.first?.first?.sOriginAirport.sCityCode
                self.lblOnwordFlightSourceTime.text = ownowrdData.sSegments.first?.first?.sOriginDeptTime.convertStoredDate()
                self.lblOnwordFlightDestinationCode.text = ownowrdData.sSegments.first?.last?.sDestinationAirport.sCityCode
                self.lblOnwordFlightDestinationTime.text = ownowrdData.sSegments.first?.last?.sDestinationArrvTime.convertStoredDate()
                self.lblOnwordFlightName.text = ownowrdData.sSegments.first?.first?.sAirline.sAirlineName
                self.imgOnwordFlight.image = UIImage.init(named: ownowrdData.sSegments.first?.first?.sAirline.sAirlineCode ?? "")
                
                let ownowrdPrice = ownowrdData.sPrice
                
            self.lblOnwordPrice.text = "₹\(LoaderClass.shared.commaSeparatedPrice(val: Int(ownowrdPrice)))"
         //   self.lblPrice.text = "₹\(LoaderClass.shared.commaSeparatedPrice(val: Int(returnBasePrice+returnTaxes+returnConvenientFee)))"
           // }
        }else{
            let ownowrdData = self.dataFlight[self.selectedIndex ?? 0]
            
            self.lblOnwordFlightCode.text = ownowrdData.sSegments.first?.first?.sOriginAirport.sCityCode
            self.lblOnwordFlightSourceTime.text = ownowrdData.sSegments.first?.first?.sOriginDeptTime.convertStoredDate()
            self.lblOnwordFlightDestinationCode.text = ownowrdData.sSegments.first?.last?.sDestinationAirport.sCityCode
            self.lblOnwordFlightDestinationTime.text = ownowrdData.sSegments.first?.last?.sDestinationArrvTime.convertStoredDate()
            self.lblOnwordFlightName.text = ownowrdData.sSegments.first?.first?.sAirline.sAirlineName
            self.imgOnwordFlight.image = UIImage.init(named: ownowrdData.sSegments.first?.first?.sAirline.sAirlineCode ?? "")
            
            let ownowrdPrice = ownowrdData.sPrice
            
            self.lblOnwordPrice.text = "₹\(LoaderClass.shared.commaSeparatedPrice(val: Int(ownowrdPrice)))"
        }
    }
}

extension SelectFareVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataFlight.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FareXIB().identifire, for: indexPath) as! FareXIB
        
        let indexData = self.dataFlight[indexPath.row]
        
        if indexData.sMiniFareRules.count > 0 {
            cell.airlineRemark = farePointAddition(arr: indexData.sMiniFareRules.first ?? [MiniFareRulesModel()])
        }
        
        // cell.airlineRemark = self.dataFlight[indexPath.row].sAirlineRemark
        cell.fareData = self.getFare(bus: indexData)
        //   cell.tableViewHeight.constant = CGFloat(self.getFare(bus: indexData).count*40 + 40 )
        cell.lblPrice.text = "₹\(String(format: "%.0f", indexData.sFare.sPublishedFare))"
        cell.lblfareName.text = (indexData.sFareClassification[CommonParam.TYPE_CP] as? String ?? "").uppercased()
        cell.imgSelect.image = self.selectedIndex == indexPath.row ? .checkMark() : .uncheckMark()
        cell.actionMoreInfo.tag = indexPath.row
        cell.actionMoreInfo.addTarget(self, action: #selector(actionMoreInfo(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tableView.layoutIfNeeded()
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        let tax = dataFlight[indexPath.row].sFare.sPublishedFare - dataFlight[indexPath.row].sFare.sBaseFare
        
        self.totalPrice = "\((dataFlight[indexPath.row].sFare.sBaseFare+tax+convenientFee-discount).rounded())"
        basePrice = dataFlight[indexPath.row].sFare.sBaseFare
        self.lblPrice.text = "₹\(LoaderClass.shared.commaSeparatedPrice(val: Int((dataFlight[indexPath.row].sFare.sBaseFare+tax+convenientFee-discount).rounded())))"
        if GetData.share.isOnwordBook() == true {
            self.lblReturnPrice.text = "₹\(LoaderClass.shared.commaSeparatedPrice(val: Int(dataFlight[indexPath.row].sFare.sPublishedFare.rounded())))"

        } else {
            self.lblOnwordPrice.text = "₹\(LoaderClass.shared.commaSeparatedPrice(val: Int(dataFlight[indexPath.row].sFare.sPublishedFare.rounded())))"
        }
        self.tableView.reloadData()
        //self.setupFlightData()
    }
    @objc func actionMoreInfo(_ sender: UIButton) {
        if GetData.share.isOnwordBook() == true {
            self.viewModel.getFareSSR(traceId: self.traceId, tokenId: self.tokenId, logId: "\(self.logId)", resultIndex: self.returnDataFlight[sender.tag].sResultIndex,view: self, isMoreInfo: true, api: .flightFarerule)
        } else {
            self.viewModel.getFareSSR(traceId: self.traceId, tokenId: self.tokenId, logId: "\(self.logId)", resultIndex: self.dataFlight[sender.tag].sResultIndex,view: self, isMoreInfo: true, api: .flightFarerule)
        }
    }
    
    func getFare(bus:Flight) -> [String]{
        var fare = [String]()
        
        if bus.sSegments.first?.first?.sBaggage != "" {
            if bus.sSegments.first?.first?.sBaggage != "Included" {
                fare.append("\(bus.sSegments.first?.first?.sBaggage ?? "") Check-in baggage included")
            } else {
                fare.append("Check-in baggage included")
            }
        }
        
        if bus.sSegments.first?.first?.sCabinBaggage != ""{
            
            if bus.sSegments.first?.first?.sCabinBaggage != "Included" {
                fare.append("\(bus.sSegments.first?.first?.sCabinBaggage ?? "") Cabin baggage included")
            } else {
                fare.append("Cabin baggage included")
            }
        }
        
        //        if bus.sFare.sTotalSeatCharges == "" {
        //            fare.append("Free Seats Available")
        //        }
        //
        //        if bus.sFare.sTotalMealCharges == "" {
        //            fare.append("Free Meals Available")
        //        }
        
        if bus.sIsRefundable == true{
            fare.append("Refund Available")
        }else{
            fare.append("No-Refund Available")
        }
        
        if bus.sIsCouponAppilcable == true{
            fare.append("Discount Coupon Applicable")
        }
        return fare
    }
}

extension SelectFareVC:ResponseProtocol{
    
    func onSuccess() {
        LoaderClass.shared.stopAnimation()
        if viewModel.isMoreInfo {
            if let vc = ViewControllerHelper.getViewController(ofType: .MoreInfoVC, StoryboardName: .Hotels) as? MoreInfoVC {
                vc.moreInfoText = (viewModel.ssrModel?.fare_rule?.response?.fareRules?.first?.fareRuleDetail ?? "").htmlToString
                vc.title = "isMoreInfo"
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            }
        } else {
            //            if let vc = ViewControllerHelper.getViewController(ofType: .InsurancePopUpVC, StoryboardName: .Main) as? InsurancePopUpVC {
            //                vc.modalPresentationStyle = .overFullScreen
            //                vc.modalTransitionStyle = .crossDissolve
            //                vc.tableCellDelegate = {
            //                    val in
            if let vc = ViewControllerHelper.getViewController(ofType: .PassangerDetailsVC, StoryboardName: .Flight) as? PassangerDetailsVC{
                vc.dataFlight1 = self.dataFlight
                vc.returnDataFlight = self.returnDataFlight
                vc.isMultiCity = self.isMultipleCity
                vc.isDomasticRountTrip = self.isDomasticRountTrip
                if GetData.share.isOnwordBook() == true {
                    vc.returnResultIndex = self.returnDataFlight[self.selectedIndex ?? 0].sResultIndex
                }
                vc.dataFlight = self.dataFlight[self.selectedIndex ?? 0]
                vc.passangerList = self.searchFlight
                vc.numberOfChildren = self.numberOfChildren
                vc.numberOfAdults = self.numberOfAdults
                vc.numberOfInfants = self.numberOfInfants
                vc.ssrData = self.viewModel.ssrModel
                vc.tokenId = self.tokenId
                vc.traceId = self.traceId
                vc.logId = self.logId
                //vc.isInsurance = val
                if GetData.share.isOnwordBook() == true {
                    vc.basePrice = self.returnBasePrice //dataFlight[0].sFare.sBaseFare
                    vc.convenientFee = self.returnConvenientFee
                    
                    let tax = self.dataFlight[self.selectedIndex ?? 0].sFare.sPublishedFare - self.dataFlight[self.selectedIndex ?? 0].sFare.sBaseFare // return is added into dataflight
                    
                    vc.taxes = tax
                    vc.taxesK3 = self.taxesK3Return
                    vc.conBirfurcation = self.conBifurcation2
                    vc.totalPrice = "\((self.dataFlight[self.selectedIndex ?? 0].sFare.sBaseFare+self.returnConvenientFee+tax).rounded())"
                } else {
                    vc.discount = self.discount
                    vc.totalPrice = self.totalPrice
                    vc.basePrice = self.basePrice
                    vc.convenientFee = self.convenientFee
                    let tax = self.dataFlight[self.selectedIndex ?? 0].sFare.sPublishedFare - self.dataFlight[self.selectedIndex ?? 0].sFare.sBaseFare
                    
                    vc.taxes = tax
                    vc.taxesK3 = self.taxesK3
                    vc.conBirfurcation = self.conBifurcation
                }
                self.pushView(vc: vc)
            }
            //                }
            //                self.present(vc, animated: true)
            // }
            // LoaderClass.shared.stopFlightAnimation(view: self)
        }
    }
    
    func farePointAddition(arr: [MiniFareRulesModel]) -> String {
        var facilities = String()
        var detail = ""
        
        for fareRule in arr {
            if fareRule.sFrom == "" && fareRule.sTo == "" {
                detail = "\(fareRule.sType) charges - \(fareRule.sDetails) \(fareRule.sJourneyPoints)"
            } else if fareRule.sTo == ""{
                detail = "\(fareRule.sType) charges before \(fareRule.sFrom) \(fareRule.sUnit) - \(fareRule.sDetails) \(fareRule.sJourneyPoints)"
            } else {
                detail = "\(fareRule.sType) charges b/w \(fareRule.sFrom)-\(fareRule.sTo) \(fareRule.sUnit) \(fareRule.sDetails) \(fareRule.sJourneyPoints)"
            }
            if facilities == "" {
                facilities = detail
            } else {
                facilities = "\(facilities)\n\(detail)"
            }
        }
        return facilities
    }
}
