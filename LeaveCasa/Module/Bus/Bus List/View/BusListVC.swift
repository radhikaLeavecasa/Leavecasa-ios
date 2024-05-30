//
//  BusListVC.swift
//  LeaveCasa
//
//  Created by acme on 26/09/22.
//

import UIKit
import SDWebImage
import IBAnimatable
import DropDown

class BusListVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var collVwBottomFilter: UICollectionView!
    @IBOutlet weak var imgUser: AnimatableImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTotalBus: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgBackDate: UIImageView!
    //MARK: - Variables
    var buses = [Bus]()
    var allData = [Bus]()
    var busesFilter = [Bus]()
    var markups : Markup?
    var dates = [Date]()
    var selectedDate = 0
    var couponsData: [CouponData]?
    var searchedParams = [String: Any] ()
    var souceName = ""
    var destinationName = ""
    var checkInDate = Date()
    
    var destinationCode = ""
    var souceCode = ""
    var selectedDateSting = ""
    var count = 0
    var logID = 0
    var viewModel = BusListViewModel()
    var sourceCityCode = Int()
    var destinationCityCode = Int()
    lazy var journyDate = Date()
    
    var isAC = false
    var isSleeper = false
    var isSeater = false
    
    var befor6 = false
    var after6to12 = false
    var after12To18 = false
    var after18To24 = false
    
    var cheapestFirst = false
    var earlyDeparture = false
    var lateDeparture = false
    var isNonAc = false
    let refreshControl = UIRefreshControl()
    var travelName = [String]()
    var arrBottom = ["Seater", "Sleeper", "AC", "Non AC", "Early Departure", "Late Departure"]
    var selectedFilter = [Int]()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.viewModel.delegate = self
        self.setupTableView()
        self.allData = self.buses
        self.busesFilter = self.buses
        let array = self.buses.filter({$0.sTravels != ""}).map({$0.sTravels})
        print(array.count)
        self.travelName = array
        LoaderClass.shared.stopAnimation()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.imgUser.isUserInteractionEnabled = true
        self.imgUser.addGestureRecognizer(tap)
    }
    //MARK: - Custom methods
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true {
            let vc = ViewControllerHelper.getViewController(ofType: .GuestLoginVC, StoryboardName: .Main) as! GuestLoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else  {
            if let vc = ViewControllerHelper.getViewController(ofType: .ProfileVC, StoryboardName: .Main) as? ProfileVC {
                self.pushView(vc: vc)
            }
        }
    }
    
    func setupTableView(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.ragisterNib(nibName: "BusListXIB")
        self.tableView.ragisterNib(nibName: "NoDataFoundXIB")
        
        self.lblDate.text = self.selectedDateSting
        self.lblTotalBus.text = "\(self.buses.count)"
        self.lblLocation.text = "\(self.souceName) to \(self.destinationName)"
        
        //MARK: Set Profile Image
        self.imgUser.sd_setImage(with: URL(string: Cookies.userInfo()?.profile_pic ?? ""), placeholderImage: .placeHolderProfile())
        
    }
    @objc func refresh(_ sender: AnyObject) {
        self.refreshControl.endRefreshing()
        self.buses = self.allData
        self.tableView.reloadData()
    }
    //MARK: - @IBActions
    @IBAction func backOnPress(_ sender: UIButton) {
        if LoaderClass.shared.isFareScreen {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: TabbarVC.self) {
                    if let vc = ViewControllerHelper.getViewController(ofType: .BusSearchVC, StoryboardName: .Bus) as? BusSearchVC {
                        vc.viewModel.couponsData = couponsData
                        self.pushView(vc: vc, animated: false)
                    }
                }
            }
        } else {
            self.popView()
        }
        
    }
    
    @IBAction func filterOnPress(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .BusFilterVC, StoryboardName: .Bus) as? BusFilterVC {
            vc.delegate = self
            vc.isAC = isAC
            vc.isSeater = isSeater
            vc.isSleeper = isSleeper
            vc.befor6 = befor6
            vc.after6to12 = after6to12
            vc.after12To18 = after12To18
            vc.after18To24 = after18To24
            vc.cheapestFirst = cheapestFirst
            vc.earlyDeparture = earlyDeparture
            vc.lateDeparture = lateDeparture
            vc.isNonAC = isNonAc
            self.pushView(vc: vc)
        }
    }
    
    @IBAction func backDate(_ sender: UIButton) {
        
        if self.count > 0{
            self.count -= 1
            if count == 0{
                self.imgBackDate.image = UIImage.init(named: "ic_light_gray_back")
            }else{
                self.imgBackDate.image = UIImage.init(named: "ic_dark_back")
            }
            let date = self.convertToNextDate(date: self.lblDate.text ?? "", value: -1)
            self.lblDate.text = date.dateString
            self.journyDate = date.date
            let params = [WSRequestParams.WS_REQS_PARAM_JOURNEY_DATE: self.lblDate.text ?? "",
                          WSRequestParams.WS_REQS_PARAM_BUS_FROM: self.sourceCityCode ,
                          WSRequestParams.WS_REQS_PARAM_BUS_TO: self.destinationCityCode] as [String : Any]
            self.viewModel.searchBus(param: params, souceName: self.souceName, destinationName: self.destinationName, checkinDate: self.journyDate, view: self)
            
        }
    }
    
    @IBAction func nextDate(_ sender: UIButton) {
        self.count += 1
        if self.count > 0{
            self.imgBackDate.image = UIImage.init(named: "ic_dark_back")
        }
        let date = self.convertToNextDate(date: self.lblDate.text ?? "", value: 1)
        print(date.dateString)
        self.lblDate.text = date.dateString
        self.journyDate = date.date
        let params = [WSRequestParams.WS_REQS_PARAM_JOURNEY_DATE: self.lblDate.text ?? "",
                      WSRequestParams.WS_REQS_PARAM_BUS_FROM: self.sourceCityCode ,
                      WSRequestParams.WS_REQS_PARAM_BUS_TO: self.destinationCityCode] as [String : Any]
        self.viewModel.searchBus(param: params, souceName: self.souceName, destinationName: self.destinationName, checkinDate: self.journyDate, view: self)
    }
    
    
    @IBAction func sortOnPress(_ sender: UIButton) {
        self.showShortDropDown(view: sender)
    }
}

extension BusListVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.buses.count == 0 ? 1 : self.buses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.buses.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataFoundXIB", for: indexPath) as! NoDataFoundXIB
            cell.img.image = .noBuses()
            cell.lblMsg.text = "Oops!\n\nNo Bus Found"
            cell.lblTitleMsg.text = ""
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BusListXIB",for: indexPath) as! BusListXIB
            let bus: Bus?
            bus = buses[indexPath.row]
            
            if let seats = bus?.sSeats {
                cell.lblSeats.text = "\(seats) seats available"
            }
            
            var ac = Strings.NO
            var sleeper = Strings.NO
            var seater = Strings.NO
            
            if !(bus?.sAC ?? false) {
                ac = Strings.NO
            }
            else {
                ac = Strings.YES
            }
            
            if !(bus?.sSeater ?? false) {
                seater = Strings.NO
            }
            else {
                seater = Strings.YES
            }
            
            if !(bus?.sSleeper ?? false) {
                sleeper = Strings.NO
            }
            else {
                sleeper = Strings.YES
            }
            
            cell.lblBusCondition.text = "Ac: \(ac) | Sleeper: \(sleeper) | Seater: \(seater)"
            cell.lblTotalTime.text = bus?.sDuration
            
            
            if var arrivalTime = bus?.sArrivalTime {
                if var departureTime = bus?.sDepartureTime {
                    arrivalTime = getTimeString(time:arrivalTime)
                    departureTime = getTimeString(time: departureTime)
                    cell.lblStartTime.text = departureTime
                    cell.lblEndTime.text = arrivalTime
                }
            }
            
            if let price = bus?.fareDetails {
                var farePrice = 0.0
                
                if let fare = price[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String {
                    farePrice = Double(fare) ?? 0
                }
                
              //  cell.lblPrice.text = "₹\(String(format: "%.2f", farePrice))"
                
                if let priceArray = bus?.fareDetailsArray {
                    for i in 0..<priceArray.count {
                        let dict = priceArray[i]
                        if let fare = dict[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String {
                            farePrice = Double(fare) ?? 0
                            break
                        }
                    }
                }
                
                cell.lblPrice.text = "₹\(String(format: "%.2f", farePrice))"
//                let fee = Double()
//                if let markup = markups {
//                    if markup.amountBy == Strings.PERCENT {
//                        farePrice = (farePrice * (markup.amount) / 100)
//
//
//                      // let price = (dataFlight[0].sPrice * markup.amount)/100
//                         fee = (farePrice * 18)/100
//                        //convenientFee = (price+fee).rounded()
//
//                        //price += (markup.amount)
//                        //let fee = (price * 18)/100
//
//                    } else {
//                        farePrice += (markup.amount)
//                         fee = (farePrice * 18)/100
//                    }
//                }
//                cell.lblPrice.text = "₹\(String(format: "%.2f", farePrice))"
            }
            
            if let travels = bus?.sTravels {
                cell.lblBusName.text = travels.capitalized
            }
            
            cell.lblSource.text = souceName.capitalized
            cell.lblDestination.text = destinationName.capitalized
            cell.imgPrimo.isHidden = bus?.sPrimo == false
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.buses.count > 0 {
            if let vc = ViewControllerHelper.getViewController(ofType: .BusSeatVC, StoryboardName: .Bus) as? BusSeatVC {
                vc.bus = self.buses[indexPath.row]
                vc.souceName = self.souceName
                vc.destinationName = self.destinationName
                vc.serviceDate  = self.lblDate.text ?? ""
                vc.logID = logID
                
                vc.searchedParams = searchedParams
                vc.checkInDate = checkInDate
                
                vc.markupDict = viewModel.markups
                self.pushView(vc: vc)
            }
        }
    }
}

extension BusListVC: ResponseProtocol, BusFilterData {
    func BusFilterData(isSleeper: Bool, isSeater: Bool, isAC: Bool, befor6: Bool, after6to12: Bool, after12To18: Bool, after18To24: Bool, cheapestFirst: Bool, earlyDeparture: Bool, lateDeparture: Bool, isNonAc: Bool) {
     
        var filterDeparture = [Bus]()
        
        self.isAC = isAC
        self.isSleeper = isSleeper
        self.isSeater = isSeater
        self.befor6 = befor6
        self.after6to12 = after6to12
        self.after12To18 = after12To18
        self.after18To24 = after18To24
        self.cheapestFirst = cheapestFirst
        self.earlyDeparture = earlyDeparture
        self.lateDeparture = lateDeparture
        self.isNonAc = isNonAc
        self.selectedFilter = []
        // Sort By Filters
        if cheapestFirst {
            self.busesFilter = self.busesFilter.sorted {
                Double($0.fareDetailsArray.first?[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? Double($0.fareDetails[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? 0.0 < Double($1.fareDetailsArray.first?[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? Double($1.fareDetails[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? 0.0
            }
        }
        
        if earlyDeparture {
            self.busesFilter = self.busesFilter.sorted {
                Int($0.sDepartureTime) ?? 0 < Int($1.sDepartureTime) ?? 0
            }
            selectedFilter.append(4)
        }
        
        if lateDeparture {
            self.busesFilter = self.busesFilter.sorted {
                Int($0.sDepartureTime) ?? 0 > Int($1.sDepartureTime) ?? 0
            }
            selectedFilter.append(5)
        }
        
        // Reset filter
        if isSeater == false && isSleeper == false && isAC == false && befor6 == false && after6to12 == false && after12To18 == false && after18To24 == false {
            self.buses = self.busesFilter
        }
        else {
            // Rest of the filters
            if befor6 {
                let bus = self.busesFilter.filter { (Int($0.sDepartureTime) ?? 0 >= 0 && Int($0.sDepartureTime) ?? 0 <= 360)}
                filterDeparture += bus
            }
            
            if after6to12 {
                let bus = self.busesFilter.filter{Int($0.sDepartureTime) ?? 0 > 360 && Int($0.sDepartureTime) ?? 0 <= 720}
                filterDeparture += bus
            }
            
            if after12To18 {
                let bus = self.busesFilter.filter{  Int($0.sDepartureTime) ?? 0 > 720 && Int($0.sDepartureTime) ?? 0 <= 1080}
                filterDeparture += bus
            }
            
            if after18To24 {
                let bus = self.busesFilter.filter{ Int($0.sDepartureTime) ?? 0 > 1080 && Int($0.sDepartureTime) ?? 0 <= 1440}
                filterDeparture += bus
            }
            
            if isSleeper == true || isSeater == true || isAC == true {
                if filterDeparture.count > 0 {
                    let bus = filterDeparture.filter{($0.sSleeper == isSleeper) || ($0.sSeater == isSeater) || ($0.sAC == isAC)}
                    filterDeparture.removeAll()
                    filterDeparture += bus
                } else {
                    let bus = self.busesFilter.filter{($0.sSleeper == isSleeper) || ($0.sSeater == isSeater) || ($0.sAC == isAC)}
                    filterDeparture += bus
                }
                if isSleeper == true {
                    selectedFilter.append(1)
                }
                if isSeater == true {
                    selectedFilter.append(0)
                }
                if isAC == true {
                    selectedFilter.append(2)
                }
            }
            if isNonAc == true {
                selectedFilter.append(3)
                let bus = self.busesFilter.filter{$0.sAC != isAC}
                filterDeparture += bus
            }
            
            self.buses = filterDeparture
        }
        
        self.lblTotalBus.text = "\(self.buses.count)"
        self.tableView.reloadData()
        self.collVwBottomFilter.reloadData()
        
    }
    
    func onSuccess() {
        self.buses.removeAll()
        self.buses = self.viewModel.buses
        self.busesFilter = self.buses
        self.lblTotalBus.text = "\(self.buses.count)"

        let array = self.buses.filter({$0.sTravels != ""}).map({$0.sTravels})
        self.travelName = array
        
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            LoaderClass.shared.stopAnimation()
        })
    }
    
    func showShortDropDown(view:UIView){
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.dataSource = GetData.share.getSortData()
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if index == 0{
                self.buses = self.buses.sorted{Double($0.fareDetailsArray.first?[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? Double($0.fareDetails[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? 0.0 < Double($1.fareDetailsArray.first?[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? Double($1.fareDetails[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? 0.0}
            }else{
                self.buses = self.buses.sorted{Double($0.fareDetailsArray.first?[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? Double($0.fareDetails[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? 0.0 > Double($1.fareDetailsArray.first?[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? Double($1.fareDetails[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String ?? "") ?? 0.0}
            }
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            self.tableView.reloadData()
        }
        dropDown.show()
    }
}

extension BusListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrBottom.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomFilterCVC", for: indexPath) as! BottomFilterCVC
        cell.lblText.text = self.arrBottom[indexPath.row]
        cell.vwBackgrd.backgroundColor = selectedFilter.contains(indexPath.row) ? .white : .lightGray
        cell.vwBackgrd.borderColor = selectedFilter.contains(where: {$0 == indexPath.row}) ? .lightBlue() : .clear
        cell.lblText.textColor = selectedFilter.contains(indexPath.row) ? .lightBlue() : .white
        cell.lblLine.isHidden = indexPath.row == self.arrBottom.count-1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = LoaderClass.shared.calculateWidthForCell(at: indexPath, arr: arrBottom)
        return CGSize(width: cellWidth+18, height: self.collVwBottomFilter.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 4 && self.selectedFilter.contains(indexPath.item+1) {
            let index = self.selectedFilter.firstIndex(of: indexPath.item+1) ?? 0
            self.selectedFilter.remove(at: index)
            self.selectedFilter.append(indexPath.item)
        } else if indexPath.item == 5 && self.selectedFilter.contains(indexPath.item-1) {
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
        
        BusFilterData(isSleeper: selectedFilter.contains(1) ? true : false, isSeater: selectedFilter.contains(0) ? true : false, isAC: selectedFilter.contains(2) ? true : false, befor6: befor6, after6to12: after6to12, after12To18: after12To18, after18To24: after18To24, cheapestFirst: cheapestFirst, earlyDeparture: selectedFilter.contains(4) ? true : false, lateDeparture: selectedFilter.contains(5) ? true : false, isNonAc: selectedFilter.contains(3))
        
        collVwBottomFilter.reloadData()
    }
}
