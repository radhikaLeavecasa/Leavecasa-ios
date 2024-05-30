//
//  FlightReturnTripVC.swift
//  LeaveCasa
//
//  Created by acme on 16/11/22.
//

import UIKit
import DropDown
import IBAnimatable

class FlightReturnTripVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var collVwBottomFilter: UICollectionView!
    @IBOutlet weak var lblDateAndTime: UILabel!
    @IBOutlet weak var lblToCity: UILabel!
    @IBOutlet weak var lblFromCity: UILabel!
    @IBOutlet weak var imgVwProfilePic: AnimatableImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    var uniqueArrayOfDictionaries: [[String: String]] = []
    var logId = 0
    var tokenId = ""
    var traceId = ""
    var flights = [[Flight]]()
    var flightsFilter = [[Flight]]()
    var flightsFilterDuplicacy = [[Flight]]()
    var startDate = Date()
    var dates = [Date]()
    var selectedDate = 0
    var calenderParam : [String: Any] = [:]
    var searchParams: [String: Any] = [:]
    var searchedFlight = [FlightStruct]()
    var numberOfAdults = 1
    var numberOfChildren = 0
    var numberOfInfants = 0
    var markups = [Markup]()
    var selectedflightTime: Int = 0
    var selectedflightStop:Int = 0
    var selectedflightType: Int = 0
    var selectedTab = 0
    var isCheapest : SortType? = .isNoSort
    var viewModel = FlightListViewModel()
    var nonStop = false
    var oneStop = false
    var airlineCode: [String]?
    var isRefund: String?
    var couponData = [CouponData]()
    var isFirstTime = true
    var arrBottom = ["Refundable", "Non-Refundable", "Non-Stop", "1 Stop"]
    var selectedFilter = [Int]()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        self.flights[0] = self.flights[0].sorted{(($0.sFare.sPublishedFare) < ($1.sFare.sPublishedFare))}
        flightsFilterDuplicacy = flights
        
        self.viewModel.delegate = self
        self.setupTableView()
        imgVwProfilePic.sd_setImage(with: URL(string: Cookies.userInfo()?.profile_pic ?? ""), placeholderImage: .placeHolderProfile())
        self.lblFromCity.text = self.searchedFlight.first?.source
        self.lblToCity.text = self.searchedFlight.first?.destination
        self.lblDateAndTime.text = "\(self.searchedFlight.first?.from ?? "")-\(self.searchedFlight.first?.to ?? "") | \(numberOfAdults+numberOfChildren+numberOfInfants) \(AlertMessages.PASSENGER)"
        
        var filteredArray = [Flight]()
        // Create a set to keep track of unique FlightNumbers
        var uniqueFlightNumbers = Set<String>()
        DispatchQueue.main.async {
            for element in self.flights[0] {
                // Check if the element is a dictionary and contains the "FlightNumber" key
                if let flightNumber = element.sSegments.first?.first?.sAirline.sFlightNumber {
                    let flightNumber1 = element.sSegments[1].first?.sAirline.sFlightNumber
                    let flightNumberString = String(flightNumber)
                    let flightNumberString1 = String(flightNumber1!)
                    // Check if the FlightNumber is unique
                    if !uniqueFlightNumbers.contains(flightNumberString) || !uniqueFlightNumbers.contains(flightNumberString1) {
                        // Add the element to the filtered array
                        filteredArray.append(element)
                        // Add the FlightNumber to the set of unique FlightNumbers
                        uniqueFlightNumbers.insert(flightNumberString)
                        uniqueFlightNumbers.insert(flightNumberString1)
                    }
                }
            }
            self.flights[0] = filteredArray
            self.flightsFilter = self.flights
            self.tableView.reloadData()
        }
    }
    
    //MARK: - @IBActions
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
        if isFirstTime {
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
            isFirstTime = false
        }
        if let vc = ViewControllerHelper.getViewController(ofType: .FlightFiltersVC, StoryboardName: .Flight) as? FlightFiltersVC {
            vc.delegate = self
            vc.isReturn = true
            vc.flightsDict = uniqueArrayOfDictionaries
            vc.flights = flights
            vc.isRefund = isRefund ?? ""
            vc.nonStop = nonStop
            vc.oneStop = oneStop
            vc.isCheapest = isCheapest
            vc.selectedAirline = airlineCode ?? []
            self.pushView(vc: vc)
        }
    }
    
    @IBAction func actionProfile(_ sender: UIButton) {
        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true {
            let vc = ViewControllerHelper.getViewController(ofType: .GuestLoginVC, StoryboardName: .Main) as! GuestLoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let profile = ViewControllerHelper.getViewController(ofType: .ProfileVC, StoryboardName: .Main) as! ProfileVC
            self.pushView(vc: profile)
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
    
    @IBAction func sortOnPress(_ sender: UIButton) {
        self.showShortDropDown(view: sender)
    }
    
    //MARK: - Custom methods
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.ragisterNib(nibName: FlightRoundTripXIB().identifire)
        self.tableView.ragisterNib(nibName: NoDataFoundXIB().identifire)
    }
    
    func showShortDropDown(view:UIView){
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.dataSource = ["  Price: Low to High  ", "  Price High to Low  "]
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0{
                self.flights[0] = self.flights[0].sorted{(($0.sFare.sPublishedFare) < ($1.sFare.sPublishedFare))}
            }else{
                self.flights[0] = self.flights[0].sorted{(($0.sFare.sPublishedFare) > ($1.sFare.sPublishedFare))}
            }
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        dropDown.show()
    }
}

extension FlightReturnTripVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.flights.first?.count ?? 0 == 0 ? 1 : self.flights.first?.count ?? 0 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.flights.first?.count ?? 0 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundXIB().identifire, for: indexPath) as! NoDataFoundXIB
            cell.img.image = .noFlight()
            cell.lblMsg.text = AlertMessages.NO_FLIGHT_FOUND
            cell.lblTitleMsg.text = ""
            cell.lblSubTitleMsg.text = ""
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FlightRoundTripXIB().identifire, for: indexPath) as! FlightRoundTripXIB
            
            if let flight = self.flights.first?[indexPath.row] {
                cell.setUp(indexPath: indexPath, flight: flight, paxNumber: numberOfAdults+numberOfInfants+numberOfChildren)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let ownowrdData = self.flights.first?[indexPath.row]
//        let returnData = self.flights.first?[indexPath.row]
//
//        let data = self.flightsFilterDuplicacy.first?.filter {
//            $0.sSegments.first?.first?.sAirline.sFlightNumber == ownowrdData?.sSegments.first?.first?.sAirline.sFlightNumber ?? ""
//        }
//
//        let returnFlightData = self.flightsFilterDuplicacy.first?.filter {
//            $0.sSegments.first?.last?.sAirline.sFlightNumber == returnData?.sSegments.first?.last?.sAirline.sFlightNumber ?? ""
//        }
        
//        let data = self.flightsFilterDuplicacy.first?.filter {
//            ($0.sSegments.first?.first?.sAirline.sFlightNumber == self.flights.first?[indexPath.row].sSegments.first?.first?.sAirline.sFlightNumber ?? "") && ($0.sSegments[1].first?.sAirline.sFlightNumber == self.flights.first?[indexPath.row].sSegments[1]?.first?.sAirline.sFlightNumber ?? "")
//        }
//
        
        guard let firstFlight = self.flights.first?[indexPath.row] else {
            return
        }

        let flightNumber1 = firstFlight.sSegments.first?.first?.sAirline.sFlightNumber ?? ""
        let flightNumber2 = firstFlight.sSegments[1].first?.sAirline.sFlightNumber ?? ""

        let data = self.flightsFilterDuplicacy.first?.filter {
            guard let segment1 = $0.sSegments.first?.first, let segment2 = $0.sSegments[1].first else {
                return false
            }
            
            return segment1.sAirline.sFlightNumber == flightNumber1 && segment2.sAirline.sFlightNumber == flightNumber2
        }
        
        if let vc = ViewControllerHelper.getViewController(ofType: .FareDetailsVC, StoryboardName: .Flight) as? FareDetailsVC {
            vc.dataFlight = data ?? []
            vc.couponData = couponData
          //  vc.returnDataFlight = returnFlightData ?? []
            vc.isDomasticRountTrip = false
            vc.markups = self.markups
            vc.logId = self.logId
            vc.tokenId = self.tokenId
            vc.traceId = self.traceId
            vc.searchFlight = self.searchedFlight
            vc.numberOfAdults = self.numberOfAdults
            vc.numberOfChildren = self.numberOfChildren
            vc.numberOfInfants = self.numberOfInfants
            vc.searchParams = searchParams
            vc.calenderParam = calenderParam
            vc.selectedTab = selectedTab
            self.pushView(vc: vc)
        }
    }
}

extension FlightReturnTripVC: isFilter, ResponseProtocol {
 
    func onSuccess() {
        
    }
    
    func filterFlight(nonStop: Bool, nonStop2: Bool, oneStop: Bool, oneStop2: Bool, isCheapestFirst: SortType, isCheapestFirst2: SortType, airlineCode: [String], airlineCode2: [String], isRefund: String, isRefund2: String, returnNonStop: Bool, returnNonStop2: Bool, returnOneStop: Bool, returnOneStop2: Bool) {

        self.nonStop = nonStop
        self.oneStop = oneStop
        self.isCheapest = isCheapestFirst
        self.airlineCode = airlineCode
        self.isRefund = isRefund
        self.selectedFilter = []
        self.flights = flightsFilter
//        self.logId = logId
//        self.tokenId = tokenId
//        self.traceId = traceId
        
        if self.isCheapest == .isDurationSort {
            
            for i in 0..<self.flights[0].count {
                for j in 0..<self.flights[0].count{
                    var temp = Flight()
                    
                    let duration1 = self.flights[0][i].sSegments.first?.last?.sAccDuration == 0 ? self.flights[0][i].sSegments.first?.first?.sDuration : self.flights[0][i].sSegments.first?.last?.sAccDuration
                    
                    let duration2 = self.flights[0][j].sSegments.first?.last?.sAccDuration == 0 ? self.flights[0][j].sSegments.first?.first?.sDuration : self.flights[0][j].sSegments.first?.last?.sAccDuration
                    
                    //Return flight
                    let duration3 = self.flights[0][i].sSegments[1].last?.sAccDuration == 0 ? self.flights[0][i].sSegments[1].first?.sDuration : self.flights[0][i].sSegments[1].last?.sAccDuration
                    
                    let duration4 = self.flights[0][j].sSegments[1].last?.sAccDuration == 0 ? self.flights[0][j].sSegments[1].first?.sDuration : self.flights[0][j].sSegments[1].last?.sAccDuration
                    
                    
                    if duration1 ?? 0 < duration2 ?? 0 && duration3 ?? 0 < duration4 ?? 0 {
                        temp = self.flights[0][i]
                        self.flights[0][i] = self.flights[0][j]
                        self.flights[0][j] = temp
                    }
                }
            }
        }
        
        if self.isCheapest == .isEarlyDeparture {
            self.flights[0] = self.flights[0].sorted{(($0.sSegments.first?.first?.sOriginDeptTime ?? "") < ($1.sSegments.first?.first?.sOriginDeptTime ?? "")) && (($0.sSegments[1].first?.sOriginDeptTime ?? "") < ($1.sSegments[1].first?.sOriginDeptTime ?? ""))}
        }
        
        if self.isCheapest == .isLateDeparture {
            
            self.flights[0] = self.flights[0].sorted{(($0.sSegments.first?.first?.sOriginDeptTime ?? "") > ($1.sSegments.first?.first?.sOriginDeptTime ?? "")) && (($0.sSegments[1].first?.sOriginDeptTime ?? "") > ($1.sSegments[1].first?.sOriginDeptTime ?? ""))}
        }
        
        if isRefund == "1" {
            self.flights[0] = self.flights[0].filter{$0.sIsRefundable == true}
            selectedFilter.append(0)
        } else if isRefund == "0" {
            self.flights[0] = self.flights[0].filter{$0.sIsRefundable == false}
            selectedFilter.append(1)
        }
        
        if self.airlineCode?.count ?? 0 > 0 {
            var flightsData = [Flight]()
            for code in self.airlineCode ?? [] {
                flightsData.append(contentsOf: self.flights[0].filter({ $0.sAirlineCode == code }))
            }
            self.flights[0] = flightsData
        }
        
        if self.isCheapest == .isCheapest{
            self.flights[0] = self.flights[0].sorted{(($0.sFare.sPublishedFare) < ($1.sFare.sPublishedFare))}
        }
        
        if oneStop == true && nonStop == true {
            self.flights[0] = self.flights[0].filter({($0.sSegments.first?.count == 1 || $0.sSegments.first?.count == 2) && ($0.sSegments[1].count == 1 || $0.sSegments[1].count == 2)})
            selectedFilter.append(2)
            selectedFilter.append(3)
        } else if nonStop == true {
            self.flights[0] = self.flights[0].filter({($0.sSegments.first?.count == 1) && ($0.sSegments[1].count == 1)})
            selectedFilter.append(2)
        } else if oneStop == true {
            self.flights[0] = self.flights[0].filter({($0.sSegments.first?.count == 2) && ($0.sSegments[1].count == 2)})
            selectedFilter.append(3)
        }
        if self.flights.count > 0 {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.collVwBottomFilter.reloadData()
        }
    }
}

extension FlightReturnTripVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrBottom.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomFilterCVC", for: indexPath) as! BottomFilterCVC
        cell.lblText.text = self.arrBottom[indexPath.row]
        cell.vwBackgrd.backgroundColor = selectedFilter.contains(where: {$0 == indexPath.row}) ? .white : .lightGray
        cell.vwBackgrd.borderColor = selectedFilter.contains(where: {$0 == indexPath.row}) ? .lightBlue() : .clear
        cell.lblText.textColor = selectedFilter.contains(where: {$0 == indexPath.row}) ? .lightBlue() : .white
        cell.lblLine.isHidden = indexPath.row == self.arrBottom.count-1
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = LoaderClass.shared.calculateWidthForCell(at: indexPath, arr: arrBottom)
        return CGSize(width: cellWidth+18, height: self.collVwBottomFilter.frame.size.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 && self.selectedFilter.contains(indexPath.item+1) {
            let index = self.selectedFilter.firstIndex(of: indexPath.item+1) ?? 0
            self.selectedFilter.remove(at: index)
            self.selectedFilter.append(indexPath.item)
        } else if indexPath.item == 1 && self.selectedFilter.contains(indexPath.item-1) {
            let index = self.selectedFilter.firstIndex(of: indexPath.item-1) ?? 0
            self.selectedFilter.remove(at: index)
            self.selectedFilter.append(indexPath.item)
        } else {
            if self.selectedFilter.contains(indexPath.item) {
                let index = self.selectedFilter.firstIndex(of: indexPath.item) ?? 0
                self.selectedFilter.remove(at: index)
            } else {
                self.selectedFilter.append(indexPath.item)
            }
        }
        
        if self.selectedFilter.contains(0) {
            isRefund = "1"
        }
        if self.selectedFilter.contains(1) {
            isRefund = "0"
        }
        if !self.selectedFilter.contains(0) && !self.selectedFilter.contains(1) {
            isRefund = ""
        }
        if self.selectedFilter.contains(2) {
            nonStop = true
        }
        if !self.selectedFilter.contains(2) {
            nonStop = false
        }
        if self.selectedFilter.contains(3) {
            oneStop = true
        }
        if !self.selectedFilter.contains(3) {
            oneStop = false
        }
        filterFlight(nonStop: nonStop, nonStop2: nonStop, oneStop: oneStop, oneStop2: oneStop, isCheapestFirst: isCheapest ?? .isNoSort, isCheapestFirst2: isCheapest ?? .isNoSort, airlineCode: airlineCode ?? [], airlineCode2: airlineCode ?? [], isRefund: isRefund ?? "", isRefund2: isRefund ?? "", returnNonStop: nonStop, returnNonStop2: nonStop, returnOneStop: oneStop, returnOneStop2: oneStop)
        
        self.collVwBottomFilter.reloadData()
    }
}
