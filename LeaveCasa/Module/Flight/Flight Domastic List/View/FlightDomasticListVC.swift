//
//  FlightDomasticListVC.swift
//  LeaveCasa
//
//  Created by acme on 01/02/23.
//

import UIKit
import DropDown
import IBAnimatable

class FlightDomasticListVC: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var returnFlightTableView: UITableView!
    @IBOutlet weak var onwordFlightFlight: UITableView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDateAdults: UILabel!
    @IBOutlet weak var lblOnowrdDestinationTime: UILabel!
    @IBOutlet weak var lblOnowrDestinationCode: UILabel!
    @IBOutlet weak var lblOnowrdSourceTime: UILabel!
    @IBOutlet weak var lblOnowrdSourceCode: UILabel!
    @IBOutlet weak var lblOnwordFlightName: UILabel!
    @IBOutlet weak var imgFlightOnwordLogo: UIImageView!
    @IBOutlet weak var lblReturnDestinationTime: UILabel!
    @IBOutlet weak var lblReturnDestinationCode: UILabel!
    @IBOutlet weak var lblReturnSourceTime: UILabel!
    @IBOutlet weak var lblReturnSourceCode: UILabel!
    @IBOutlet weak var lblReturnFlightName: UILabel!
    @IBOutlet weak var imgFlightReturnLogo: UIImageView!
    @IBOutlet weak var lblPaxCount: UILabel!
    @IBOutlet weak var imgVwProfilePic: AnimatableImageView!
    
    //MARK: - Variables
    let dateFormatter = DateFormatter()
    var arrTime = String()
    var deptTime = String()
    var airlineCode: [String]?
    var airlineCode2: [String]?
    var isRefund: String?
    var isRefund2: String?
    var isCheapest : SortType? = .isNoSort
    var isCheapest2 : SortType? = .isNoSort
    var selectedOnwordIndex = 0
    var selectedReturnIndex = 0
    var logId = 0
    var tokenId = ""
    var traceId = ""
    var flights = [[Flight]]()
    var flightsFilter = [[Flight]]()
    var startDate = Date()
    var endDate = Date()
    var dates = [Date]()
    var selectedDate = 0
    var calenderParam : [String: Any] = [:]
    var searchParams: [String: Any] = [:]
    var searchedFlight = [FlightStruct]()
    var couponData = [CouponData]()
    var numberOfAdults = 1
    var numberOfChildren = 0
    var numberOfInfants = 0
    var selectedflightTime: Int = 0
    var selectedflightStop:Int = 0
    var selectedflightType: Int = 0
    var selectedTab = 0
    var viewModel = FlightListViewModel()
    var isOneWayFlightOrInternational : Bool = false
    var selectedFlightTab = 0
    var markups = [Markup]()
    var nonStop = false
    var oneStop = false
    
    var nonStop2 = false
    var oneStop2 = false
    var isFilter2 = false
    
    var uniqueArrayOfDictionaries: [[String: String]] = []
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        //DispatchQueue.main.async {
            self.flights[0] = self.flights[0].sorted{(($0.sFare.sPublishedFare) < ($1.sFare.sPublishedFare))}
            self.flights[1] = self.flights[1].sorted{(($0.sFare.sPublishedFare) < ($1.sFare.sPublishedFare))}
            self.flightsFilter = self.flights
       // }
        self.viewModel.delegate = self
        imgVwProfilePic.sd_setImage(with: URL(string: Cookies.userInfo()?.profile_pic ?? ""), placeholderImage: .placeHolderProfile())
        self.setupTableView()
        self.setupFlightData()
    }
    //MARK: - Custom methods
    func setupTableView(){
        lblDateAdults.text = "\(convertDate(startDate, format: DateFormat.monthDateYear)) - \(convertDate(endDate, format: DateFormat.monthDateYear)) | \(numberOfAdults+numberOfChildren+numberOfInfants) \(AlertMessages.PASSENGER)"
        
        self.returnFlightTableView.delegate = self
        self.returnFlightTableView.dataSource = self
        self.returnFlightTableView.tableFooterView = UIView()
        self.returnFlightTableView.ragisterNib(nibName: ReturnTripFlightXIB().identifire)
        self.returnFlightTableView.ragisterNib(nibName: NoDataFoundXIB().identifire)
        self.onwordFlightFlight.delegate = self
        self.onwordFlightFlight.dataSource = self
        self.onwordFlightFlight.tableFooterView = UIView()
        self.onwordFlightFlight.ragisterNib(nibName: ReturnTripFlightXIB().identifire)
    }
    
    func setupFlightData() {
        if self.flights.first?.count ?? 0 > 0 && self.flights.last?.count ?? 0 > 0 {
            let ownowrdData = self.flights.first?[self.selectedOnwordIndex]
            let returnData = self.flights.last?[self.selectedReturnIndex]
            
            self.lblOnowrdSourceCode.text = ownowrdData?.sSegments.first?.first?.sOriginAirport.sCityCode
            self.lblOnowrdSourceTime.text = ownowrdData?.sSegments.first?.first?.sOriginDeptTime.convertStoredDate()
            self.lblOnowrDestinationCode.text = ownowrdData?.sSegments.first?.last?.sDestinationAirport.sCityCode
            self.lblOnowrdDestinationTime.text = ownowrdData?.sSegments.first?.last?.sDestinationArrvTime.convertStoredDate()
            self.lblOnwordFlightName.text = ownowrdData?.sSegments.first?.first?.sAirline.sAirlineName
            self.imgFlightOnwordLogo.image = UIImage.init(named: ownowrdData?.sSegments.first?.first?.sAirline.sAirlineCode ?? "")
            
            self.lblReturnSourceCode.text = returnData?.sSegments.first?.first?.sOriginAirport.sCityCode
            self.lblReturnSourceTime.text = returnData?.sSegments.first?.first?.sOriginDeptTime.convertStoredDate()
            self.lblReturnDestinationCode.text = returnData?.sSegments.first?.last?.sDestinationAirport.sCityCode
            
            self.arrTime = ownowrdData?.sSegments.first?.last?.sDestinationArrvTime ?? ""
            self.deptTime = returnData?.sSegments.first?.first?.sOriginDeptTime ?? ""
            
            self.lblReturnDestinationTime.text = returnData?.sSegments.first?.last?.sDestinationArrvTime.convertStoredDate()
            self.lblReturnFlightName.text = returnData?.sSegments.first?.first?.sAirline.sAirlineName
            self.imgFlightReturnLogo.image = UIImage.init(named: returnData?.sSegments.first?.first?.sAirline.sAirlineCode ?? "")
            
            let ownowrdPrice = ownowrdData?.sFare.sPublishedFare ?? 0.0
            let returnPrice = returnData?.sFare.sPublishedFare ?? 0.0
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedPrice = numberFormatter.string(from: NSNumber(value: (Int(ownowrdPrice + returnPrice))))
            self.lblPrice.text = "₹\(formattedPrice ?? "")"
        }

        
        self.lblPaxCount.text = "for \(numberOfAdults+numberOfInfants+numberOfChildren) \((numberOfAdults+numberOfInfants+numberOfChildren) == 1 ? "pax" : "paxes")"
    }
    //MARK: - @IBActions
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
    
    @IBAction func bookOnPress(_ sender: UIButton) {
        let ownowrdData = self.flights.first?[self.selectedOnwordIndex]
        let returnData = self.flights.last?[self.selectedReturnIndex]
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let data = self.flights.first?.filter {
            $0.sSegments.first?.first?.sAirline.sFlightNumber == ownowrdData?.sSegments.first?.first?.sAirline.sFlightNumber ?? ""
        }
        
        let returnFlightData = self.flights.last?.filter {
            $0.sSegments.first?.first?.sAirline.sFlightNumber == returnData?.sSegments.first?.first?.sAirline.sFlightNumber ?? ""
        }
        
        if let date1 = dateFormatter.date(from: arrTime),
           let date2 = dateFormatter.date(from: deptTime) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour], from: date1, to: date2)
            let timeDifferenceInHours = components.hour ?? 0
            
            if timeDifferenceInHours == 0 || timeDifferenceInHours < 2 {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: "Please keep difference of atleast 2 hours between arrival time of first flight and departure time of second flight.")
            } else {
                if let vc = ViewControllerHelper.getViewController(ofType: .FareDetailsVC, StoryboardName: .Flight) as? FareDetailsVC {
                    vc.markups = markups
                    vc.couponData = couponData
                    vc.searchParams = searchParams
                    vc.calenderParam = calenderParam
                    vc.searchFlight = searchedFlight
                    vc.isDomasticRountTrip = true
                    vc.dataFlight = data?.sorted(by: {$0.sFare.sPublishedFare < $1.sFare.sPublishedFare}) ?? []
                    vc.returnDataFlight = returnFlightData?.sorted(by: {$0.sFare.sPublishedFare < $1.sFare.sPublishedFare}) ?? []
                    vc.logId = self.logId
                    vc.tokenId = self.tokenId
                    vc.traceId = self.traceId
                    vc.searchFlight = self.searchedFlight
                    vc.numberOfAdults = self.numberOfAdults
                    vc.numberOfChildren = self.numberOfChildren
                    vc.numberOfInfants = self.numberOfInfants
                    vc.selectedTab = selectedTab
                    self.pushView(vc: vc)
                }
            }
        }
    }
    @IBAction func actionModifySearch(_ sender: Any) {
        if LoaderClass.shared.isFareScreen {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: TabbarVC.self) {
                    if let vc = ViewControllerHelper.getViewController(ofType: .SearchFlightVC, StoryboardName: .Flight) as? SearchFlightVC {
                        vc.couponsData = couponData
                        self.pushView(vc: vc, animated: false)
                    }
                }
            }
        } else {
            self.popView()
        }
    }
    
    @IBAction func filterOnPress(_ sender: UIButton) {
        uniqueArrayOfDictionaries = []
        let airlineData = self.flightsFilter.first?.map{$0.sSegments.first?.first?.sAirline}
        
        var uniqueDictionary: [String: String] = [:]
        
        for dictionary in airlineData ?? [FlightAirline]() {
            if let name = dictionary?.sAirlineName as? String, let code = dictionary?.sAirlineCode as? String {
                if uniqueDictionary[name] == nil {
                    uniqueDictionary[name] = code
                }
            }
        }

        for (name, code) in uniqueDictionary {
            uniqueArrayOfDictionaries.append(["name": name, "code": code])
        }
        
        if let vc = ViewControllerHelper.getViewController(ofType: .FlightFiltersVC, StoryboardName: .Flight) as? FlightFiltersVC {
            vc.delegate = self
            vc.flightsDict = uniqueArrayOfDictionaries
            vc.flights = flights
            vc.isDomestic = true
            vc.isReturn = true
            
            vc.isRefund = isRefund ?? ""
            vc.nonStop = nonStop
            vc.oneStop = oneStop
            vc.isCheapest = isCheapest
            vc.selectedAirline = airlineCode ?? []
            
            
            vc.nonStop2 = nonStop2
            vc.oneStop2 = oneStop2
            vc.isCheapest2 = isCheapest2
            vc.selectedAirline2 = airlineCode2 ?? []
            vc.isRefund2 = isRefund2 ?? ""
            
            self.pushView(vc: vc, title: "Domestic Round")
        }
    }
    @IBAction func actionProfilePic(_ sender: UIButton) {
        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true {
            let vc = ViewControllerHelper.getViewController(ofType: .GuestLoginVC, StoryboardName: .Main) as! GuestLoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let profile = ViewControllerHelper.getViewController(ofType: .ProfileVC, StoryboardName: .Main) as! ProfileVC
            self.pushView(vc: profile)
        }
    }
    
    @IBAction func sortOnPress(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.dataSource = GetData.share.getSortData()
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if self.selectedTab == 0 {
                self.flights[0] = index == 0 ? self.flights[0].sorted{(($0.sFare.sPublishedFare) < ($1.sFare.sPublishedFare))} : self.flights[0].sorted{(($0.sFare.sPublishedFare) > ($1.sFare.sPublishedFare))}
                self.flights[1] = index == 0 ? self.flights[1].sorted{(($0.sFare.sPublishedFare) < ($1.sFare.sPublishedFare))} : self.flights[1].sorted{(($0.sFare.sPublishedFare) > ($1.sFare.sPublishedFare))}
            } else if self.selectedTab == 1 {
                self.flights[0] = index == 0 ? self.flights[0].sorted{(($0.sFare.sPublishedFare) < ($1.sFare.sPublishedFare))} : self.flights[0].sorted{(($0.sFare.sPublishedFare) > ($1.sFare.sPublishedFare))}
                self.flights[1] = index == 0 ? self.flights[1].sorted{(($0.sFare.sPublishedFare) < ($1.sFare.sPublishedFare))} : self.flights[1].sorted{(($0.sFare.sPublishedFare) > ($1.sFare.sPublishedFare))}
            }
            self.onwordFlightFlight.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            self.returnFlightTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            
            let ownowrdPrice = self.flights.first?[0].sFare.sPublishedFare
            let returnPrice = self.flights.last?[0].sFare.sPublishedFare
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedPrice = numberFormatter.string(from: NSNumber(value: (Double((ownowrdPrice ?? 0.0) + (returnPrice ?? 0.0)))))

            self.lblPrice.text = "₹\(formattedPrice ?? "")"
            
            self.onwordFlightFlight.reloadData()
            self.returnFlightTableView.reloadData()
        }
       
        dropDown.show()
    }
}

extension FlightDomasticListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == self.onwordFlightFlight ? self.flights.first?.count ?? 0 == 0 ? 1 : self.flights.first?.count ?? 0 : self.flights.last?.count ?? 0 == 0 ? 1 : self.flights.last?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.flights.first?.count ?? 0 > 0 && self.flights.last?.count ?? 0 > 0 {
            return tableView == self.onwordFlightFlight ? (self.flights.first?[section].sSegments.count ?? 0 == 0 ? 1 : self.flights.first?[section].sSegments.count)! : (self.flights.last?[section].sSegments.count ?? 0 == 0 ? 1 : self.flights.last?[section].sSegments.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.flights.first?[indexPath.section].sSegments.count ?? 0 == 0 || self.flights.last?[indexPath.section].sSegments.count ?? 0 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundXIB().identifire, for: indexPath) as! NoDataFoundXIB
            cell.img.image = .noFlight()
            cell.lblMsg.text = AlertMessages.NO_FLIGHT_FOUND
            cell.lblTitleMsg.text = ""
            cell.lblSubTitleMsg.text = ""
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReturnTripFlightXIB().identifire, for: indexPath) as! ReturnTripFlightXIB
            if tableView == self.onwordFlightFlight{
                cell.imgCheck.image = self.selectedOnwordIndex == indexPath.section ? .checkMark() : .uncheckMark()
                if let flight = self.flights.first?[indexPath.section] {
                    cell.setUp(indexPath: indexPath, flight: flight)
                }
            } else {
                cell.imgCheck.image = self.selectedReturnIndex == indexPath.section ? .checkMark() : .uncheckMark()
                if let flight = self.flights.last?[indexPath.section] {
                    cell.setUp(indexPath: indexPath, flight: flight)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.onwordFlightFlight {
            self.selectedOnwordIndex = indexPath.section
            self.onwordFlightFlight.reloadData()
        } else {
            self.selectedReturnIndex = indexPath.section
            self.returnFlightTableView.reloadData()
        }
        self.setupFlightData()
    }
}

extension FlightDomasticListVC: isFilter, ResponseProtocol {
    func filterFlight(nonStop: Bool, nonStop2: Bool, oneStop: Bool, oneStop2: Bool, isCheapestFirst: SortType, isCheapestFirst2: SortType, airlineCode: [String], airlineCode2: [String], isRefund: String, isRefund2: String, returnNonStop: Bool, returnNonStop2: Bool, returnOneStop: Bool, returnOneStop2: Bool) {
        
        self.searchParams[WSRequestParams.WS_REQS_PARAM_DIRECT_FLIGHT] = nonStop
        self.searchParams[WSRequestParams.WS_REQS_PARAM_ONESTOP_FLIGHT] = oneStop
        self.nonStop = nonStop
        self.oneStop = oneStop
        self.isCheapest = isCheapestFirst
        self.airlineCode = airlineCode
        self.isRefund = isRefund
        
        self.nonStop2 = nonStop2
        self.oneStop2 = oneStop2
        self.isCheapest2 = isCheapestFirst2
        self.airlineCode2 = airlineCode2
        self.isRefund2 = isRefund2
        
        selectedOnwordIndex = 0
        selectedReturnIndex = 0
        isFilter2 = true
        onFlightReload()
      //  self.viewModel.searchFlight(param: self.searchParams,view: self)
    }
    func onSuccess() {
        
    }
    
    func onFlightReload() {
        if !isFilter2 {
            self.flights = self.viewModel.flights
            self.logId = self.viewModel.logId
            self.tokenId = self.viewModel.tokenId
            self.traceId = self.viewModel.traceId
        }
        if self.isCheapest == .isCheapest {
            if self.flights.count > 1 {
                self.flights[0] = self.flights[0].sorted{(($0.sFare.sPublishedFare) < ($1.sFare.sPublishedFare))}
            } else {
                self.flights[0] = self.flights[0].sorted{(($0.sFare.sPublishedFare) < ($1.sFare.sPublishedFare))}
            }
        }
        
        if self.isCheapest2 == .isCheapest {
            if self.flights.count > 1 {
                self.flights[1] = self.flights[1].sorted{(($0.sFare.sPublishedFare) < ($1.sFare.sPublishedFare))}
            } else {
                self.flights[1] = self.flights[1].sorted{(($0.sFare.sPublishedFare) < ($1.sFare.sPublishedFare))}
            }
        }
        
        if self.isCheapest == .isDurationSort {
            
            for i in 0..<self.flights[0].count {
                for j in 0..<self.flights[0].count{
                    var temp = Flight()
                    
                    let duration1 = self.flights[0][i].sSegments.first?.last?.sAccDuration == 0 ? self.flights[0][i].sSegments.first?.first?.sDuration : self.flights[0][i].sSegments.first?.last?.sAccDuration
                    
                    let duration2 = self.flights[0][j].sSegments.first?.last?.sAccDuration == 0 ? self.flights[0][j].sSegments.first?.first?.sDuration : self.flights[0][j].sSegments.first?.last?.sAccDuration
                    
                    if duration1 ?? 0 < duration2 ?? 0 {
                        temp = self.flights[0][i]
                        self.flights[0][i] = self.flights[0][j]
                        self.flights[0][j] = temp
                    }
                }
            }
        }
        
        if self.isCheapest2 == .isDurationSort {
            
            for i in 0..<self.flights[1].count {
                for j in 0..<self.flights[1].count{
                    var temp = Flight()
                    
                    let duration1 = self.flights[1][i].sSegments.first?.last?.sAccDuration == 0 ? self.flights[1][i].sSegments.first?.first?.sDuration : self.flights[1][i].sSegments.first?.last?.sAccDuration
                    
                    let duration2 = self.flights[1][j].sSegments.first?.last?.sAccDuration == 0 ? self.flights[1][j].sSegments.first?.first?.sDuration : self.flights[1][j].sSegments.first?.last?.sAccDuration
                    
                    if duration1 ?? 0 < duration2 ?? 0 {
                        temp = self.flights[1][i]
                        self.flights[1][i] = self.flights[1][j]
                        self.flights[1][j] = temp
                    }
                }
            }
        }
        
        if self.isCheapest == .isEarlyDeparture {
            self.flights[0] = self.flights[0].sorted{(($0.sSegments.first?.first?.sOriginDeptTime ?? "") < ($1.sSegments.first?.first?.sOriginDeptTime ?? ""))}
        }
        
        if self.isCheapest2 == .isEarlyDeparture {
            self.flights[1] = self.flights[1].sorted{(($0.sSegments.first?.first?.sOriginDeptTime ?? "") < ($1.sSegments.first?.first?.sOriginDeptTime ?? ""))}
        }
        
        
        if self.isCheapest == .isLateDeparture {
            self.flights[0] = self.flights[0].sorted{(($0.sSegments.first?.first?.sOriginDeptTime ?? "") > ($1.sSegments.first?.first?.sOriginDeptTime ?? ""))}
        }
        
        if self.isCheapest2 == .isLateDeparture {
            self.flights[1] = self.flights[1].sorted{(($0.sSegments.first?.first?.sOriginDeptTime ?? "") > ($1.sSegments.first?.first?.sOriginDeptTime ?? ""))}
        }
        
        if isRefund == "1" {
            self.flights[0] = self.flights[0].filter{$0.sIsRefundable == true}
        } else if isRefund == "0" {
            self.flights[0] = self.flights[0].filter{$0.sIsRefundable == false}
        }
        
        if isRefund2 == "1" {
            self.flights[1] = self.flights[1].filter{$0.sIsRefundable == true}
        } else if isRefund == "0" {
            self.flights[1] = self.flights[1].filter{$0.sIsRefundable == false}
        }
        
        if self.airlineCode?.count ?? 0 > 0 {
            var flightsData = [Flight]()
            for code in self.airlineCode ?? [] {
                if self.flights.count > 0 {
                    flightsData.append(contentsOf: self.flights[0].filter({ $0.sAirlineCode == code }))
                }
            }
            if flightsData.count > 0 {
                self.flights[0] = flightsData
            }
        }
        
        if self.airlineCode2?.count ?? 0 > 0 {
            var flightsData2 = [Flight]()
            for code in self.airlineCode2 ?? [] {
                flightsData2.append(contentsOf: self.flights[1].filter({ $0.sAirlineCode == code }))
            }
            if flightsData2.count > 0 {
                self.flights[1] = flightsData2
            }
        }
        
        if self.flights.first?.count == 0 {
            self.flights[1] = []
        }
        if flights[1].count == 0 {
            self.flights[0] = []
        }
        self.setupFlightData()
        self.returnFlightTableView.reloadData()
        self.onwordFlightFlight.reloadData()
        self.onwordFlightFlight.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        self.returnFlightTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    func onFail(msg: String) {
        self.flights = self.viewModel.flights
        self.returnFlightTableView.reloadData()
        self.onwordFlightFlight.reloadData()
    }
}
