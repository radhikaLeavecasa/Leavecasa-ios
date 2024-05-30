//
//  FlightMultiCityVC.swift
//  LeaveCasa
//
//  Created by acme on 01/11/22.
//

import UIKit
import IBAnimatable
import DropDown

class FlightMultiCityVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var collVwBottomFilter: UICollectionView!
    @IBOutlet weak var imgUser: AnimatableImageView!
    @IBOutlet weak var lblPath: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Variables
    var selectedIndex : Int? = nil
    var selectedFlight : Int? = nil
    var markups = [Markup]()
    var logId = 0
    var tokenId = ""
    var traceId = ""
    var flights = [[Flight]]()
    var flightsFilter = [[Flight]]()
    var startDate = Date()
    var dates = [Date]()
    var selectedDate = 0
    var searchParams: [String: Any] = [:]
    var searchedFlight = [FlightStruct]()
    var calenderParam: [String: Any] = [:]
    var numberOfAdults = 1
    var numberOfChildren = 0
    var numberOfInfants = 0
    var selectedflightTime: Int = 0
    var selectedflightStop:Int = 0
    var selectedflightType: Int = 0
    var selectedTab = 0
    var sourceData = [String]()
    var isOneWayFlightOrInternational : Bool = false
    var uniqueArrayOfDictionaries: [[String: String]] = []
    var isCheapest : SortType? = .isNoSort
    var nonStop = false
    var oneStop = false
    var airlineCode: [String]?
    var isRefund: String?
    var couponData = [CouponData]()
    var arrBottom = ["Refundable", "Non-Refundable", "Non-Stop", "1 Stop"]
    var selectedFilter = [Int]()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        DispatchQueue.main.async {
            self.flights[0] = self.flights[0].sorted{(($0.sFare.sPublishedFare) < ($1.sFare.sPublishedFare))}
            self.flightsFilter = self.flights
        }
        self.setupTableView()
        self.lblPath.text = self.sourceData.joined(separator:" > ")
        self.imgUser.sd_setImage(with: URL(string: Cookies.userInfo()?.profile_pic ?? ""), placeholderImage: .placeHolderProfile())
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    //MARK: - @IBActions
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
    @IBAction func actionProfile(_ sender: Any) {
        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true {
            let vc = ViewControllerHelper.getViewController(ofType: .GuestLoginVC, StoryboardName: .Main) as! GuestLoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let profile = ViewControllerHelper.getViewController(ofType: .ProfileVC, StoryboardName: .Main) as! ProfileVC
            self.pushView(vc: profile)
        }
    }
    @IBAction func actionModifySearch(_ sender: Any) {
        if LoaderClass.shared.isFareScreen {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: TabbarVC.self) {
                    if let vc = ViewControllerHelper.getViewController(ofType: .SearchFlightVC, StoryboardName: .Flight) as? SearchFlightVC {
                        vc.couponsData = couponData
                        self.setView(vc: vc, animation: false)
                    }
                }
            }
        } else {
            self.popView()
        }
    }
    @IBAction func actionSortBy(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.dataSource = GetData.share.getSortData()
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.flights[0] = index == 0 ? self.flights[0].sorted{(($0.sFare.sPublishedFare) < ($1.sFare.sPublishedFare))} : self.flights[0].sorted{(($0.sFare.sPublishedFare) > ($1.sFare.sPublishedFare))}
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        dropDown.show()
    }
    @IBAction func actionFilter(_ sender: UIButton) {
        let airlineData = self.flights.first?.map{$0.sSegments.first?.first?.sAirline}
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
    //MARK: - Custom methods
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.tableView.ragisterNib(nibName: MultiCityFlightXIB().identifire)
        self.tableView.ragisterNib(nibName: NoDataFoundXIB().identifire)
    }
}
extension FlightMultiCityVC: isFilter {
 
    func filterFlight(nonStop: Bool, nonStop2: Bool, oneStop: Bool, oneStop2: Bool, isCheapestFirst: SortType, isCheapestFirst2: SortType, airlineCode: [String], airlineCode2: [String], isRefund: String, isRefund2: String, returnNonStop: Bool, returnNonStop2: Bool, returnOneStop: Bool, returnOneStop2: Bool) {

        self.nonStop = nonStop
        self.oneStop = oneStop
        self.isCheapest = isCheapestFirst
        self.airlineCode = airlineCode
        self.isRefund = isRefund
        self.selectedFilter = []
        self.flights = flightsFilter
        
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
        
        if self.isCheapest == .isEarlyDeparture {
            self.flights[0] = self.flights[0].sorted{(($0.sSegments.first?.first?.sOriginDeptTime ?? "") < ($1.sSegments.first?.first?.sOriginDeptTime ?? ""))}
        }
        
        if self.isCheapest == .isLateDeparture {
            
            self.flights[0] = self.flights[0].sorted{(($0.sSegments.first?.first?.sOriginDeptTime ?? "") > ($1.sSegments.first?.first?.sOriginDeptTime ?? ""))}
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
            self.flights[0] = self.flights[0].filter({$0.sSegments.first?.count == 1 || $0.sSegments.first?.count == 2})
            selectedFilter.append(2)
            selectedFilter.append(3)
        } else if nonStop == true {
            self.flights[0] = self.flights[0].filter({$0.sSegments.first?.count == 1})
            selectedFilter.append(2)
        } else if oneStop == true {
            self.flights[0] = self.flights[0].filter({$0.sSegments.first?.count == 2})
            selectedFilter.append(3)
        }
        if self.flights.count > 0 {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        self.tableView.reloadData()
        self.collVwBottomFilter.reloadData()
    }
}
extension FlightMultiCityVC:UITableViewDelegate,UITableViewDataSource{
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: MultiCityFlightXIB().identifire, for: indexPath) as! MultiCityFlightXIB
            
            let indexData = self.flights.first?[indexPath.row]
            DispatchQueue.main.async {
                cell.tableView.invalidateIntrinsicContentSize()
                cell.tableView.layoutIfNeeded()
                self.updateHeight(tableView: self.tableView)
            }
            
            cell.setupData(data: indexData?.sSegments ?? [])
            cell.lblPrice.text = "₹\(String(format: "%.0f", indexData?.sFare.sPublishedFare ?? 0.0))"
            cell.lblPaxCount.text = "For \(numberOfAdults+numberOfInfants+numberOfChildren) \(numberOfAdults+numberOfInfants+numberOfChildren == 1 ? "Pax" : "Paxes")"
            cell.logId = self.logId
            cell.tokenId = self.tokenId
            cell.traceId = self.traceId
            cell.markups = markups
            cell.numberOfAdults = self.numberOfAdults
            cell.numberOfChildren = self.numberOfChildren
            cell.numberOfInfants = self.numberOfInfants
            cell.view = self
            cell.flights = self.flights.first ?? []
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = flights.first?.filter {
            $0.sSegments[indexPath.row].first?.sAirline.sFlightNumber == flights.first?.first?.sSegments[indexPath.row].first?.sAirline.sFlightNumber ?? ""
        }
        
        if let vc = ViewControllerHelper.getViewController(ofType: .FareDetailsVC, StoryboardName: .Flight) as? FareDetailsVC {
            vc.dataFlight = data ?? []
            vc.couponData = couponData
            vc.logId = self.logId
            vc.tokenId = self.tokenId
            vc.traceId = self.traceId
            vc.markups = markups
            vc.numberOfAdults = self.numberOfAdults
            vc.numberOfChildren = self.numberOfChildren
            vc.numberOfInfants = self.numberOfInfants
            vc.isMultiCity = true
            vc.searchFlight = searchedFlight
            vc.selectedTab = selectedTab
            vc.searchParams = searchParams
            vc.calenderParam = calenderParam
            self.pushView(vc: vc)
        }
    }
}

extension FlightMultiCityVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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