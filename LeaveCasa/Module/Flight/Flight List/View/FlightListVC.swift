//
//  FlightListVC.swift
//  LeaveCasa
//
//  Created by acme on 01/11/22.
//

import UIKit
import IBAnimatable
import DropDown

class FlightListVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblTimePassenger: UILabel!
    @IBOutlet weak var lblSourceDestination: UILabel!
    @IBOutlet weak var calenderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var calenderView: AnimatableView!
    @IBOutlet weak var imgUser: AnimatableImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collVwBottomFilter: UICollectionView!
    //MARK: - Variables
    var selectedFilter = [Int]()
    var searchedFlight = [FlightStruct]()
    var selectedDateIndex : Int? = nil
    var isCheapest : SortType? = .isNoSort
    var isRefund = ""
    var logId = 0
    var tokenId = ""
    var traceId = ""
    var flights = [[Flight]]()
    var arrWithoutFilter = [Flight]()
    var allData = [[Flight]]()
    var calenderParam : [String: Any] = [:]
    var searchParams: [String: Any] = [:]
    var couponData = [CouponData]()
    var numberOfAdults = 1
    var numberOfChildren = 0
    var numberOfInfants = 0
    var selectedTab = 0
    var viewModel = FlightListViewModel()
    let refreshControl = UIRefreshControl()
    var selectedFlightTab = 0
    var oneStop = false
    var nonStop = false
    var airlineCode = [String]()
    var markups = [Markup]()
    var selectedDate = String()
    var arrBottom = ["Refundable", "Non-Refundable", "Non-Stop", "1 Stop"]
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoaderClass.shared.loadAnimation()
        self.setupCollectionView()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        UserDefaults.standard.set(false, forKey: CommonParam.Ownword)
        self.setupTableView()
        //self.allData = self.flights
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.imgUser.addGestureRecognizer(tap)
        self.imgUser.sd_setImage(with: URL(string: Cookies.userInfo()?.profile_pic ?? ""), placeholderImage: .placeHolderProfile())
        lblSourceDestination.text = LoaderClass.shared.sourceSestination?.uppercased()
        //MARK: CALL API
        self.viewModel.delegate = self
        // DispatchQueue.main.async {
        if let segments = self.calenderParam["Segments"] as? [[String: Any]],
           let segment = segments.first,
           let preferredDepartureTime = segment["PreferredDepartureTime"] as? String {
            // Use the value of preferredDepartureTime here
            self.selectedDate = preferredDepartureTime
            self.lblTimePassenger.text = "\(self.convertStoredDate(self.selectedDate, DateFormat.monthDateYear)) | \(self.numberOfAdults) Adult, \(self.numberOfChildren) Children, \(self.numberOfInfants) Infant"
            self.collectionView.reloadData()
        }
        self.viewModel.getCalenderData(param: self.calenderParam, view: self)
        self.flights[0] = self.flights[0].sorted{(($0.sPrice) < ($1.sPrice))}
        self.arrWithoutFilter = self.flights[0]
        var filteredArray = [Flight]()
        // Create a set to keep track of unique FlightNumbers
        var uniqueFlightNumbers = Set<String>()
        
        // Iterate through each element in the array
        for element in self.flights[0] {
            // Check if the element is a dictionary and contains the "FlightNumber" key
            if let flightNumber = element.sSegments.first?.first?.sAirline.sFlightNumber {
                let flightNumberString = String(flightNumber)
                
                // Check if the FlightNumber is unique
                if !uniqueFlightNumbers.contains(flightNumberString) {
                    // Add the element to the filtered array
                    filteredArray.append(element)
                    // Add the FlightNumber to the set of unique FlightNumbers
                    uniqueFlightNumbers.insert(flightNumberString)
                }
            }
        }
        self.flights[0] = filteredArray
        self.allData = flights
    }
    
    func setFlightCalendarData(){
        DispatchQueue.main.async {
            if var segments = self.calenderParam["Segments"] as? [[String: Any]], !segments.isEmpty {
                // Update the values for the first segment
                segments[0]["PreferredDepartureTime"] = "\(self.selectedDate)T00:00:00"
                segments[0]["PreferredArrivalTime"] = "\(self.selectedDate)T00:00:00"
                
                // Update 'calenderParam' with the modified 'segments'
                self.calenderParam["Segments"] = segments
                LoaderClass.shared.loadAnimation()
                self.viewModel.getCalenderData(param: self.calenderParam, view: self)
            }
            
            self.flights[0] = self.flights[0].sorted{(($0.sPrice) < ($1.sPrice))}
            
            self.allData = self.flights
        }
    }
    //MARK: - @IBActions
    @IBAction func actionModifySearch(_ sender: Any) {
        if LoaderClass.shared.isFareScreen {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: TabbarVC.self) {
                    if let vc = ViewControllerHelper.getViewController(ofType: .SearchFlightVC, StoryboardName: .Flight) as? SearchFlightVC {
                        vc.couponsData = couponData
                      //  vc.sharedParam = searchParams
                        self.pushView(vc: vc, animated: false)
                    }
                }
            }
        } else {
            self.popView()
        }
    }
    @IBAction func calenderOnPress(_ sender: UIButton) {
        
        if let calendar = UIStoryboard.init(name: ViewControllerType.WWCalendarTimeSelector.rawValue, bundle: nil).instantiateInitialViewController() as? WWCalendarTimeSelector {
      
            calendar.delegate = self
            let segments = self.calenderParam["Segments"] as? [[String: Any]]
            
            calendar.optionCurrentDate = returnDate(segments?[0]["PreferredDepartureTime"] as! String, strFormat: "yyyy-MM-dd'T'HH:mm:ss")
            calendar.optionStyles.showDateMonth(true)
            calendar.optionStyles.showMonth(false)
            calendar.optionStyles.showYear(true)
            calendar.optionStyles.showTime(false)
            calendar.optionButtonShowCancel = true
            
            self.present(calendar, animated: true, completion: nil)
        }
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
    @IBAction func backOnPress(_ sender: UIButton) {
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
    
    @IBAction func sortOnPress(_ sender: UIButton) {
        self.showShortDropDown(view: sender)
    }
    
    @IBAction func filterOnPress(_ sender: UIButton) {
        self.flights = self.allData
        let airlineData = self.flights.first?.map{$0.sSegments.first?.first?.sAirline}
        
        var uniqueDictionary: [String: String] = [:]
        
        for dictionary in airlineData ?? [FlightAirline]() {
            if let name = dictionary?.sAirlineName as? String, let code = dictionary?.sAirlineCode as? String {
                // Check if the name is already present in the uniqueDictionary
                if uniqueDictionary[name] == nil {
                    // If not present, add the name and code to the uniqueDictionary
                    uniqueDictionary[name] = code
                }
            }
        }

        var uniqueArrayOfDictionaries: [[String: String]] = []
        for (name, code) in uniqueDictionary {
            uniqueArrayOfDictionaries.append(["name": name, "code": code])
        }
      
        if let vc = ViewControllerHelper.getViewController(ofType: .FlightFiltersVC, StoryboardName: .Flight) as? FlightFiltersVC {
            
            vc.flightsDict = uniqueArrayOfDictionaries
            vc.delegate = self
            vc.isRefund = isRefund
            vc.nonStop = nonStop
            vc.oneStop = oneStop
            vc.isCheapest = isCheapest
            vc.selectedAirline = airlineCode
            vc.flights = flights
            self.pushView(vc: vc)
        }
    }
    
    //MARK: - Custom methods
    func setupCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.ragisterNib(nibName: DateCollectionXIB().identifire)
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.ragisterNib(nibName: FlightListTableViewXIB().identifire)
        self.tableView.ragisterNib(nibName: NoDataFoundXIB().identifire)
        self.tableView.ragisterNib(nibName: FlightListCellXIB().identifire)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.refreshControl.endRefreshing()
        self.flights = self.allData
        self.tableView.reloadData()
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if let vc = ViewControllerHelper.getViewController(ofType: .ProfileVC, StoryboardName: .Main) as? ProfileVC {
            self.pushView(vc: vc)
        }
    }
    
    func showShortDropDown(view:UIView){
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.dataSource = GetData.share.getSortData()
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if self.selectedTab == 0{
                
                self.flights[0] = index == 0 ? self.flights[0].sorted{(($0.sPrice) < ($1.sPrice))} : self.flights[0].sorted{(($0.sPrice) > ($1.sPrice))}
                
            }else if self.selectedTab == 1{
                if self.selectedFlightTab == 0 {
                    
                    self.flights[0] = index == 0 ? self.flights[0].sorted{(($0.sPrice) < ($1.sPrice))} : self.flights[0].sorted{(($0.sPrice) > ($1.sPrice))}
                    
                }else{
                    
                    self.flights[1] = index == 0 ? self.flights[1].sorted{(($0.sPrice) < ($1.sPrice))} : self.flights[1].sorted{(($0.sPrice) > ($1.sPrice))}
                    
                }
            }
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            self.tableView.reloadData()
        }
        
        dropDown.show()
    }
    
    func scrollToSelectedDate() {
        
        for (i,val) in self.viewModel.dateModel.enumerated() {
            if self.convertStoredDate(val.DepartureDate ?? "", DateFormat.yearMonthDate) == self.selectedDate.components(separatedBy: "T")[0] {
                self.selectedDateIndex = i
                self.selectedDate = ""
                self.collectionView.scrollToItem(at: IndexPath(row: self.selectedDateIndex ?? 0, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
}
extension Array where Element: Hashable {
    func uniquelements() -> Array {
        var temp = Array()
        var s = Set<Element>()
        for i in self {
            if !s.contains(i) {
                temp.append(i)
                s.insert(i)
            }
        }
        return temp
    }
}
extension FlightListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwBottomFilter {
            return arrBottom.count
        } else {
            return self.viewModel.dateModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwBottomFilter {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomFilterCVC", for: indexPath) as! BottomFilterCVC
            cell.lblText.text = self.arrBottom[indexPath.row]
            cell.vwBackgrd.backgroundColor = selectedFilter.contains(where: {$0 == indexPath.row}) ? .white : .lightGray
            cell.lblText.textColor = selectedFilter.contains(where: {$0 == indexPath.row}) ? .lightBlue() : .white
            cell.vwBackgrd.borderColor = selectedFilter.contains(where: {$0 == indexPath.row}) ? .lightBlue() : .clear
            cell.lblLine.isHidden = indexPath.row == self.arrBottom.count-1
            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionXIB().identifire, for: indexPath) as! DateCollectionXIB
            
            let indexData = self.viewModel.dateModel[indexPath.item]
            cell.lblPrice.text = "₹ \(String(format: "%.2f", indexData.fare ?? 0.0))"
            cell.lblDate.text = self.convertStoredDate(indexData.DepartureDate ?? "", DateFormat.dateMonth)
            cell.lblDate.textColor = self.selectedDateIndex == indexPath.item ? .lightBlue() : .grayColor()
            cell.lblPrice.textColor = self.selectedDateIndex == indexPath.item ? .lightBlue() : .grayColor()
            cell.vwOuter.borderColor = self.selectedDateIndex == indexPath.item ? .lightBlue() : .clear
//            if FlightListVC.convertStoredDate(indexData.DepartureDate ?? "", DateFormat.yearMonthDate) == self.selectedDate.components(separatedBy: "T")[0] {
//                self.selectedDateIndex = indexPath.item
//                self.selectedDate = ""
//
//               self.collectionView.scrollToItem(at: IndexPath(row: self.selectedDateIndex ?? 0, section: 0), at: .centeredHorizontally, animated: true)
//                cell.lblDate.textColor = self.selectedDateIndex == indexPath.item ? .lightBlue() : .grayColor()
//                cell.lblPrice.textColor = self.selectedDateIndex == indexPath.item ? .lightBlue() : .grayColor()
//                cell.vwOuter.borderColor = self.selectedDateIndex == indexPath.item ? .lightBlue() : .clear
//            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwBottomFilter {
            let cellWidth = LoaderClass.shared.calculateWidthForCell(at: indexPath, arr: arrBottom)
            return CGSize(width: cellWidth+18, height: self.collVwBottomFilter.frame.size.height)
        } else {
            return CGSize(width: 100, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collVwBottomFilter {
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
            filterFlight(nonStop: nonStop, nonStop2: nonStop, oneStop: oneStop, oneStop2: oneStop, isCheapestFirst: isCheapest ?? .isNoSort, isCheapestFirst2: isCheapest ?? .isNoSort, airlineCode: airlineCode, airlineCode2: airlineCode, isRefund: isRefund, isRefund2: isRefund, returnNonStop: nonStop, returnNonStop2: nonStop, returnOneStop: oneStop, returnOneStop2: oneStop)
            collVwBottomFilter.reloadData()
        } else {
            self.selectedDateIndex = indexPath.item
            let indexData = self.viewModel.dateModel[indexPath.item]
            var segment = self.searchParams["Segments"] as? [[String:Any]] ?? []
            var firstIndex = segment.first ?? [:]
            firstIndex["PreferredDepartureTime"] = "\(self.convertStoredDate(indexData.DepartureDate ?? "", DateFormat.yearMonthDate))T00:00:00"
            firstIndex["PreferredArrivalTime"] = "\(self.convertStoredDate(indexData.DepartureDate ?? "", DateFormat.yearMonthDate))T00:00:00"
            self.selectedDate = self.convertStoredDate(indexData.DepartureDate ?? "", DateFormat.yearMonthDate)
            segment.removeAll()
            segment.insert(firstIndex, at: 0)
            self.searchParams["Segments"] = segment
            
            self.viewModel.searchFlight(param: self.searchParams,view: self)
            self.setFlightCalendarData()
            self.collectionView.reloadData()
        }
    }
}

extension FlightListVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.flights.first?.count ?? 0 == 0 ? 1 : self.flights.first?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.selectedTab == 0 && self.flights.first?.count ?? 0 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundXIB().identifire, for: indexPath) as! NoDataFoundXIB
            cell.img.image = .noFlight()
            cell.lblMsg.text = AlertMessages.NO_FLIGHT_FOUND
            cell.lblTitleMsg.text = ""
            cell.lblSubTitleMsg.text = ""
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FlightListCellXIB().identifire, for: indexPath) as! FlightListCellXIB
            let flight = self.flights.first?[indexPath.row]
            cell.setUp(indexPath: indexPath, flight: flight ?? Flight(), paxNumber: numberOfAdults+numberOfInfants+numberOfChildren)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.flights.count > 0 {
        let data = self.arrWithoutFilter.filter {
            $0.sSegments.first?.first?.sAirline.sFlightNumber == self.flights.first?[indexPath.row].sSegments[0].first?.sAirline.sFlightNumber ?? ""
        }
        
            if let vc = ViewControllerHelper.getViewController(ofType: .FareDetailsVC, StoryboardName: .Flight) as? FareDetailsVC {
                vc.dataFlight = data
                vc.couponData = couponData
                vc.arrFlightsWithoutFilter = self.arrWithoutFilter
                vc.logId = self.logId
                vc.tokenId = self.tokenId
                vc.traceId = self.traceId
                vc.markups = self.markups
                vc.searchFlight = searchedFlight
                vc.searchParams = searchParams
                vc.calenderParam = calenderParam
                vc.numberOfAdults = self.numberOfAdults
                vc.numberOfChildren = self.numberOfChildren
                vc.numberOfInfants = self.numberOfInfants
                vc.selectedTab = selectedTab
                self.pushView(vc: vc)
            }
        }
    }
}

extension FlightListVC:ResponseProtocol{
    
    func onSuccess() {
        self.collectionView.reloadData()
        self.scrollToSelectedDate()
    }
    
    func onFlightReload(){
        self.flights = self.viewModel.flights
//        DispatchQueue.main.async {
//            self.flights[0] = self.flights[0].sorted{(($0.sPrice) < ($1.sPrice))}
//            self.flights[1] = self.flights[1].sorted{(($0.sPrice) < ($1.sPrice))}
//        }
        self.logId = self.viewModel.logId
        self.tokenId = self.viewModel.tokenId
        self.traceId = self.viewModel.traceId
        
        if self.isCheapest == .isCheapest || self.isRefund != ""{
            if self.flights.count > 1 {
                self.flights[0] = self.flights[0].sorted{(($0.sPrice) < ($1.sPrice))}
                self.flights[1] = self.flights[1].sorted{(($0.sPrice) < ($1.sPrice))}
                
                if self.isRefund == "1"{
                    self.flights[0] = self.flights[0].filter{$0.sIsRefundable == true}
                    self.flights[1] = self.flights[1].filter{$0.sIsRefundable == true}
                }else if self.isRefund == "0"{
                    self.flights[0] = self.flights[0].filter{$0.sIsRefundable == false}
                    self.flights[1] = self.flights[1].filter{$0.sIsRefundable == false}
                }else{
                    
                }
            }else{
                self.flights[0] = self.flights[0].sorted{(($0.sPrice) < ($1.sPrice))}
                if self.isRefund == "1"{
                    self.flights[0] = self.flights[0].filter{$0.sIsRefundable == true}
                }else if self.isRefund == "0"{
                    self.flights[0] = self.flights[0].filter{$0.sIsRefundable == false}
                }else{
                    
                }
            }
        }
        self.tableView.reloadData()
    }
}

extension FlightListVC:isFilter{
    func filterFlight(nonStop: Bool, nonStop2: Bool, oneStop: Bool, oneStop2: Bool, isCheapestFirst: SortType, isCheapestFirst2: SortType, airlineCode: [String], airlineCode2: [String], isRefund: String, isRefund2: String, returnNonStop: Bool, returnNonStop2: Bool, returnOneStop: Bool, returnOneStop2: Bool) {
    
        self.isRefund = isRefund
        self.nonStop = nonStop
        self.oneStop = oneStop
        self.isCheapest = isCheapestFirst
        self.airlineCode = airlineCode
        self.selectedFilter = []
        
        LoaderClass.shared.loadAnimation()
        self.flights = self.allData
        if self.flights.count > 1 {
        } else {
            if isRefund == "1" {
                self.flights[0] = self.flights[0].filter{$0.sIsRefundable == true}
                selectedFilter.append(0) //Adding indexPath in array
            } else if isRefund == "0" {
                self.flights[0] = self.flights[0].filter{$0.sIsRefundable == false}
                selectedFilter.append(1)
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
            
            if airlineCode.count > 0{
                var flightsData = [Flight]()
                for code in airlineCode{
                    flightsData.append(contentsOf: self.flights[0].filter({ $0.sAirlineCode == code }))
                }
                self.flights[0] = flightsData
            }
            
            if isCheapestFirst == .isCheapest{
                self.flights[0] = self.flights[0].sorted{(($0.sPrice) < ($1.sPrice))}
            }
            
            if isCheapestFirst == .isDurationSort {
                
                
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
            
            if isCheapestFirst == .isEarlyDeparture {
                self.flights[0] = self.flights[0].sorted{(($0.sSegments.first?.first?.sOriginDeptTime ?? "") < ($1.sSegments.first?.first?.sOriginDeptTime ?? ""))}
            }
            
            if isCheapestFirst == .isLateDeparture{
                self.flights[0] = self.flights[0].sorted{(($0.sSegments.first?.first?.sOriginDeptTime ?? "") > ($1.sSegments.first?.first?.sOriginDeptTime ?? ""))}
            }
        }
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        self.tableView.reloadData()
        self.collVwBottomFilter.reloadData()
        self.tableView.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.10, execute: {
            LoaderClass.shared.stopAnimation()
        })
    }
}

// MARK: - WWCALENDARTIMESELECTOR DELEGATE
extension FlightListVC: WWCalendarTimeSelectorProtocol {
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        selectedDate = "\(convertDate(date))"
        var segment = self.searchParams["Segments"] as? [[String:Any]] ?? []
        var firstIndex = segment.first ?? [:]
        firstIndex["PreferredDepartureTime"] = "\(convertDate(date))T00:00:00"
        firstIndex["PreferredArrivalTime"] = "\(convertDate(date))T00:00:00"
        segment.removeAll()
        segment.insert(firstIndex, at: 0)
        self.searchParams["Segments"] = segment
        
        self.viewModel.searchFlight(param: self.searchParams,view: self)
        
        self.setFlightCalendarData()
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        if date < Date() {
            return false
        } else {
            return true
        }
    }
}
