//
//  HotelListVC.swift
//  LeaveCasa
//
//  Created by acme on 09/09/22.
//

import UIKit
import IBAnimatable
import SDWebImage
import CoreLocation
import DropDown

class HotelListVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var collVwBottomFilter: UICollectionView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblHotelCount: UILabel!
    @IBOutlet weak var imgUser: AnimatableImageView!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Variables
    var selectedFilter = [Int]()
    var hotelData = [HotelRoomDetail]()
  //  let refreshControl = UIRefreshControl()
    var isRefundable = String()
    var isBreakfast = String()
    var results = [Results]()
    var hotels = [Hotels]()
    var hotels2 = [Hotels]()
    var hotelsCode = [String]()
    var markups = [Markup]()
    var checkInDate = ""
    var checkIn = ""
    var checkOut = ""
    var cityCodeStr = ""
    var finalRooms = [[String: AnyObject]]()
    var hotelCount = ""
    var logId = 0
    var currentRequest = 0
    var numberOfRooms = 1
    var numberOfAdults = 1
    var numberOfChild = 0
    var numberOfNights = 1
    var ageOfChildren: [Int] = []
    var selectedRatings: [Int] = []
    var totalRequest = ""
    
    var viewModel = HotelListViewModel()
    var locationManager:CLLocationManager?
    
    var isFilter = false
    var filterAmount = Double()
    var cityName = ""
    var arrBottom = ["Refundable", "Non-Refundable", "With Meal", "Without Meal"]
    var animationDuration: TimeInterval = 0.85
    var delay: TimeInterval = 0.05
    var fontSize: CGFloat = 26
    var days = Int()
    var currentTableAnimation: TableAnimation = .fadeIn(duration: 0.85, delay: 0.03) {
        didSet {
            self.lblLocation.text = currentTableAnimation.getTitle()
        }
    }
    var delegate : HotelListData?
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        //MARK: Show Hotel Count
        DispatchQueue.main.async {
            self.viewModel.fatchPropertyType(param: ["hotel_codes":self.hotelsCode],view: self)
        }
        self.lblHotelCount.text = "Hotel(s): \(hotelCount)" //"\(results.count > 0 ? results[0].numberOfHotels : 0)"
        
        //MARK: Set Location
        self.lblLocation.text = self.cityName
        
        //MARK: Set Profile Image
        self.imgUser.sd_setImage(with: URL(string: Cookies.userInfo()?.profile_pic ?? ""), placeholderImage: .placeHolderProfile())
        
        for i in self.results {
            self.hotels.append(contentsOf: i.hotels)
            self.tableView.reloadData()
        }
        hotels2 = hotels
        if let hotels = self.results.first?.request{
            if let hotel_codes = hotels["hotel_codes"] as? [String]{
                self.hotelsCode = hotel_codes
            }
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.locationManager?.delegate = self
        self.delegate = self
        self.tableView.ragisterNib(nibName: FIlterHeaderXIB().identifire)
        self.tableView.ragisterNib(nibName: HotelListXIB().identifire)
        self.tableView.ragisterNib(nibName: NoDataFoundXIB().identifire)

        //self.currentTableAnimation = TableAnimation.moveUp(rowHeight: 40, duration: animationDuration, delay: delay)
        
//        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//        self.tableView.addSubview(refreshControl) // not required when using UITableViewController
        
//        //MARK: Location Update
//        self.updateLocation()
//        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.imgUser.isUserInteractionEnabled = true
        self.imgUser.addGestureRecognizer(tap)
        self.tableView.reloadData()
    }
    
    //MARK: - Custom methods
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true {
            let vc = ViewControllerHelper.getViewController(ofType: .GuestLoginVC, StoryboardName: .Main) as! GuestLoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let profile = ViewControllerHelper.getViewController(ofType: .ProfileVC, StoryboardName: .Main) as! ProfileVC
            self.pushView(vc: profile)
        }
    }
    
    func updateLocation(){
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() == true {
            self.locationManager?.startUpdatingLocation()
        }
    }
    //MARK: - Custom Methods
    @objc func refresh(_ sender: AnyObject) {
       // self.refreshControl.endRefreshing()
        if let hotels = self.results.first?.hotels {
            self.hotels =  hotels
            
            //MARK: Show Hotel Count
            self.lblHotelCount.text = "\(results.count > 0 ? results[0].numberOfHotels : 0)"
            
            self.tableView.reloadData()
        }
    }
    
    @objc func filterOnPress(sender:UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .HotelFilterVC, StoryboardName: .Hotels) as? HotelFilterVC{
            vc.delegate = self
            vc.isRefundable = isRefundable
            vc.isBreakfast = isBreakfast
            vc.price = self.filterAmount
            LoaderClass.shared.loadAnimation()
            self.pushView(vc: vc)
        }
    }
    //MARK: - @IBActions
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
    
    @objc func sortOnPress(sender:UIButton){
        self.showShortDropDown(view: sender.plainView, arr: [" Price Low to High ", " Price High to Low "], selectedTag: 0)
    }
    @objc func actionStartRatingFilter(sender:UIButton){
        self.showShortDropDown(view: sender.plainView, arr: [" 5 Star ", " 4 Star ", " 3 Star "], selectedTag: 1)
    }
}

extension HotelListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hotels.count == 0 ? 1 : self.hotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.hotels.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundXIB().identifire, for: indexPath) as! NoDataFoundXIB
            cell.img.image = .noHotels()
            cell.lblMsg.text = "No Hotel Found"
            cell.lblTitleMsg.text = ""
            cell.lblSubTitleMsg.text = ""
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: HotelListXIB().identifire, for: indexPath) as! HotelListXIB
            
            let hotels = self.hotels[indexPath.row]
            
            let hotel: Hotels?
            hotel = hotels
            
            if let address = hotel?.sAddress {
                cell.lblHotelAddress.text = "Add: \(address)"
            }
            
            if let name = hotel?.sName {
                cell.lblHotelName.text = name
            }
            
            if let minRate = hotel?.iMinRate {
                if var price = minRate.sPrice as? Double {
                    for i in 0..<markups.count {
                        let markup: Markup?
                        markup = markups[i]
                        if markup?.starRating == hotel?.iCategory {
                            if markup?.amountBy == Strings.PERCENT {
                                
                                let tax = ((price * (markup?.amount ?? 0) / 100) * 18) / 100
                                price += (price * (markup?.amount ?? 0) / 100) + tax
                            } else {
                                let tax = ((markup?.amount ?? 0)  * 18) / 100
                                price += (markup?.amount ?? 0) + tax
                            }
                        }
                    }
                    cell.lblPrice.text = "\(String(format: "%.0f", price))"
                    var conviencefee = Int()
                    if price > 5000 {
                        conviencefee = 400
                    } else if price > 3000 {
                        conviencefee = 250
                    } else if price > 1200 {
                        conviencefee = 150
                    } else {
                        conviencefee = 100
                    }
                    cell.lblTax.text = "(Price for \(days) nights + ₹\(conviencefee) convenience fee"
                    
                    var arr = [String]()
                    if hotel?.iMinRate.sNonRefundable == false {
                        arr.append("Refundable")
                    }
                    if hotel?.iMinRate.sRateComments.sMealplan.contains("Breakfast") == true {
                        arr.append("Breakfast included")
                    }
                    
                    for i in minRate.sOtherInclusions {
                        arr.append(i)
                    }
                    
                    cell.lblNonRefundable.text = arr.count > 0 ? arr[0] : ""
                    cell.lblBreakfastIncluded.text = arr.count >= 2 ? arr[1] : ""
                    cell.lblPointThree.text = arr.count >= 3 ? arr[2] : ""
                }
            }
            cell.imgVwTick1.isHidden = cell.lblNonRefundable.text == ""
            cell.imgVwTick2.isHidden = cell.lblBreakfastIncluded.text == ""
            cell.imgVwTick3.isHidden = cell.lblPointThree.text == ""
            
            if let rating = hotel?.iCategory {
                cell.lblRate.text = "\(rating)"
            }
            
            if let image = hotel?.sImages {
                if let imageUrl = image[WSResponseParams.WS_RESP_PARAM_URL] as? String {
                    if let imageStr = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        if let url = URL(string: imageStr) {
                            cell.imgHotel.sd_setImage(with: url, placeholderImage: .placeHolder())
                        }
                    }
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.results[indexPath.section]
        
        if let vc = ViewControllerHelper.getViewController(ofType: .HotelDetailsVC,StoryboardName: .Hotels) as? HotelDetailsVC {
            if self.hotels.count > 0 {
                vc.hotels = self.hotels[indexPath.row]
                
                self.results.forEach { val in
                    (val.request["hotel_codes"] as? [String])?.forEach({ value in
                        if value == self.hotels[indexPath.row].sHotelCode {
                            vc.searchId = val.searchId
                        }
                    })
                }
                vc.hotelData = hotelData
                vc.days = days
                vc.logId = logId
                vc.markups = markups
                vc.checkIn = checkIn
                vc.checkOut = checkOut
                vc.finalRooms = finalRooms
                vc.numberOfRooms = self.numberOfRooms
                vc.numberOfAdults = self.numberOfAdults
                vc.numberOfChild = self.numberOfChild
                vc.numberOfNights = dict.sNoOfNights
                vc.ageOfChildren = self.ageOfChildren
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: FIlterHeaderXIB().identifire ) as! FIlterHeaderXIB
        
        cell.btnFilter.addTarget(self, action: #selector(self.filterOnPress(sender:)), for: .touchUpInside)
        cell.btnSort.addTarget(self, action: #selector(self.sortOnPress(sender:)), for: .touchUpInside)
        cell.btnExplore.addTarget(self, action: #selector(self.actionStartRatingFilter(sender:)), for: .touchUpInside)
       // cell.lblExplore.text = "Explore \(self.cityName)"
        return cell
    }
}

extension HotelListVC: HotelListData {
    func getData(data: [Results], rate: [Int], maxPrice: Double, minPrice: Double, refundable: String, breakfast: String, amenities: [String], propertyType: [String]) {
      
        hotels = []
        selectedFilter = []
        var hotels1 = [Hotels]()
        DispatchQueue.main.async {
            
            if minPrice != 0.0 {
                hotels1 = self.hotels2.filter{ $0.iMinRate.sPrice >= minPrice }
                for i in hotels1 {
                    self.hotels.append(i)
                }
            }
            
            if maxPrice != 0.0 {
                hotels1 = self.hotels2.filter{ $0.iMinRate.sPrice <= maxPrice }
                for i in hotels1 {
                    self.hotels.append(i)
                }
            }
            
            if rate.contains(3) {
                hotels1 = self.hotels2.filter{ $0.iCategory == 3}
                for i in hotels1 {
                    self.hotels.append(i)
                }
            }
            if rate.contains(4) {
                hotels1 = self.hotels2.filter{ $0.iCategory == 4}
                for i in hotels1 {
                    self.hotels.append(i)
                }
            }
            if rate.contains(5) {
                hotels1 = self.hotels2.filter{ $0.iCategory == 5}
                for i in hotels1 {
                    self.hotels.append(i)
                }
            }
            
            if refundable == "Refundable" {
                hotels1 = self.hotels2.filter{ $0.iMinRate.sNonRefundable == false }
                for i in hotels1 {
                    self.hotels.append(i)
                }
                self.selectedFilter.append(0)
            } else if refundable == "Non-Refundable" {
                hotels1 = self.hotels2.filter{ $0.iMinRate.sNonRefundable == true }
                for i in hotels1 {
                    self.hotels.append(i)
                }
                self.selectedFilter.append(1)
            } else if refundable == "Both" {
                self.selectedFilter.append(0)
                self.selectedFilter.append(1)
            }
            if breakfast == "Included" {
                hotels1 = self.hotels2.filter{ $0.iMinRate.sRateComments.sMealplan.contains("breakfast") }
                for i in hotels1 {
                    self.hotels.append(i)
                }
                self.selectedFilter.append(2)
            } else if breakfast == "Not-Included" {
                hotels1 = self.hotels2.filter{ $0.iMinRate.sRateComments.sMealplan.contains("breakfast") == false}
                for i in hotels1 {
                    self.hotels.append(i)
                }
                self.selectedFilter.append(3)
            } else if breakfast == "Both" {
                self.selectedFilter.append(2)
                self.selectedFilter.append(3)
            }
            
            if amenities.count > 0 {
                for i in amenities {
                    hotels1 = self.hotels2.filter{ $0.sFacilities.contains(i) }
                    for i in hotels1 {
                        self.hotels.append(i)
                    }
                }
            }
            
            
//            var filteredArray = [Hotels]()
//            // Create a set to keep track of unique Hotels
//            var uniqueFlightNumbers = Set<String>()
//            
//            // Iterate through each element in the array
//            for element in self.hotels {
//                // Check if the element is a dictionary and contains the "FlightNumber" key
//                let flightNumberString = String(element.sName)
//                    
//                    // Check if the FlightNumber is unique
//                    if !uniqueFlightNumbers.contains(flightNumberString) {
//                        // Add the element to the filtered array
//                        filteredArray.append(element)
//                        // Add the FlightNumber to the set of unique FlightNumbers
//                        uniqueFlightNumbers.insert(flightNumberString)
//                }
//            }
//            
//            self.hotels = filteredArray
            
            self.hotels = self.hotels.sorted(by: {($0.iMinRate.sPrice) < ($1.iMinRate.sPrice)})
                
            if HotelFilterData.share.isReset {
                self.hotels = self.hotels2
            }
            
            LoaderClass.shared.stopAnimation()
            self.lblHotelCount.text = "Hotel(s): \(self.hotels.count)"
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            self.tableView.reloadData()
            self.collVwBottomFilter.reloadData()
        }
    }
}

extension HotelListVC:CLLocationManagerDelegate{
    
    //MARK: - location delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            
            if (error != nil){
                print("error in reverseGeocode")
            }
            //        if let placemark = (placemarks ?? [CLPlacemark]) as [CLPlacemark]{
            if placemarks?.count ?? 0 > 0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                //                self.cityName = placemark.locality ?? ""
                //                self.lblLocation.text = "\(placemark.locality ?? ""),\(placemark.isoCountryCode?.uppercased() ?? "")"
                self.locationManager?.stopUpdatingLocation()
                self.tableView.reloadData()
            }
        }
    }
    
    private func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
}

extension HotelListVC:filterHotelList {
    func filterHotelList(rating: [Int], maxPrice: Double, minPrice: Double, propertyType: [String], amenities: [String], refundable: String, breakfast: String) {
        print(propertyType)
        isRefundable = refundable
        isBreakfast = breakfast
        currentRequest = 0
        LoaderClass.shared.loadAnimation()
        
        self.delegate?.getData(data: results, rate: rating, maxPrice: maxPrice, minPrice: minPrice, refundable: refundable, breakfast: breakfast, amenities: amenities, propertyType: propertyType)
        
//        self.results.removeAll()
//        self.viewModel.fetchHotels(cityCodeStr: cityCodeStr, txtCheckIn:checkIn, txtCheckOut: checkOut, finalRooms: finalRooms, numberOfRooms: numberOfRooms, numberOfAdults: numberOfAdults, ageOfChildren: ageOfChildren, rate: rating, price: price, amenities: amenities, propertyType: propertyType, view: self, refundable: refundable, breakfast: breakfast)
    }
    
}

extension HotelListVC{
    
    func showShortDropDown(view:UIView, arr: [String] = [], selectedTag: Int){
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = arr
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            if selectedTag == 0 {
                if index == 0{
                    self.hotels.sort{
                        (($0.iMinRate.sPrice) < ($1.iMinRate.sPrice))
                    }
                }else{
                    self.hotels.sort{
                        (($0.iMinRate.sPrice) > ($1.iMinRate.sPrice))
                    }
                }
            } else {
                if index == 2 {
                    hotels = self.hotels2.filter{ $0.iCategory == 3}
                } else if index == 1 {
                    hotels = self.hotels2.filter{ $0.iCategory == 4}
                } else if index == 0 {
                    hotels = self.hotels2.filter{ $0.iCategory == 5}
                }
            }
            self.lblHotelCount.text = "Hotel(s): \(self.hotels.count)"
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            self.tableView.reloadData()
        }
        
        dropDown.show()
    }
}
extension HotelListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        if self.selectedFilter.contains(indexPath.item) {
            let index = self.selectedFilter.firstIndex(of: indexPath.item) ?? 0
            self.selectedFilter.remove(at: index)
        } else {
            self.selectedFilter.append(indexPath.item)
        }
        
        if self.selectedFilter.contains(0) && self.selectedFilter.contains(1) {
            isRefundable = "Both"
        } else if self.selectedFilter.contains(0) {
            isRefundable = "Refundable"
        } else if self.selectedFilter.contains(1) {
            isRefundable = "Non-Refundable"
        } else if !self.selectedFilter.contains(0) || !self.selectedFilter.contains(1) {
            isRefundable = ""
        }
        
        if self.selectedFilter.contains(2) && self.selectedFilter.contains(3) {
            isBreakfast = "Both"
        } else if self.selectedFilter.contains(2) {
            isBreakfast = "Included"
        } else if self.selectedFilter.contains(3) {
            isBreakfast = "Not-Included"
        }  else if !self.selectedFilter.contains(2) || !self.selectedFilter.contains(3) {
            isBreakfast = ""
        }
        getData(data: results, rate: HotelFilterData.share.rate, maxPrice: HotelFilterData.share.price, minPrice: HotelFilterData.share.price2, refundable: isRefundable, breakfast: isBreakfast, amenities: HotelFilterData.share.amenities, propertyType: HotelFilterData.share.propertyType)
        collVwBottomFilter.reloadData()
    }
}
