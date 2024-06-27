//
//  HotelDetailsVC.swift
//  LeaveCasa
//
//  Created by acme on 09/09/22.
//

import UIKit
import IBAnimatable
import AdvancedPageControl
import SDWebImage
import ImageViewer_swift

class HotelDetailsVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var overViewTableHeight: NSLayoutConstraint!
    @IBOutlet weak var overViewTableView: UITableView!
    @IBOutlet weak var facilityCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var facilityCollection: UICollectionView!
    @IBOutlet weak var btnViewAll: AnimatableButton!
    @IBOutlet weak var lblTitleFacility: UILabel!
    @IBOutlet weak var lblTitleFacilityBottomView: UIView!
    @IBOutlet weak var lblTitleOverviewBottomView: UIView!
    @IBOutlet weak var lblTitleOverView: UILabel!
    @IBOutlet weak var lblTotalGuestAndRoom: UILabel!
    @IBOutlet weak var lblTraveDate: UILabel!
    @IBOutlet weak var lblIncludeBreakFast: UILabel!
    @IBOutlet weak var lblNoRefund: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblHotelAddress: UILabel!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var lblNameHotel: UILabel!
    @IBOutlet weak var lblOverView: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var pageControle: AdvancedPageControlView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSelectRoom: AnimatableButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tblViewFacilities: UITableView!
    @IBOutlet weak var lblNoHotel: UILabel!
    @IBOutlet weak var hotelNotAvlableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var hotelNotAvlable: UIView!
    @IBOutlet weak var priceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var cnstTblVwFacilityHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTaxText: UILabel!
    //MARK: - Variables
    var hotelData = [HotelRoomDetail]()
    var isGuest: Bool?
    var hotels: Hotels?
    var hotelDetail: HotelDetail?
    var markups = [Markup]()
    var facilities = [String]()
    var jsonResponse = [[String: AnyObject]]()
    var searchId = ""
    var logId = 0
    var checkIn = ""
    var checkOut = ""
    var finalRooms = [[String: AnyObject]]()
    var selectedTab = 0 // 0 - Overview, 1 - Facilities, 2 - TermsAndCondn
    var numberOfRooms = 1
    var numberOfAdults = 1
    var numberOfChild = 0
    var numberOfNights = 1
    var ageOfChildren: [Int] = []
    var selectedIndex = IndexPath()
    var viewModel = HotelDetailsViewModel()
    let imageView = UIImageView()
    var imagesUrl = [URL]()
    var selectedtab = 0
    var facilitiesData = [String]()
    var overViewData = [String]()
    var hotel: Hotels?
    var conviencefee = Int()
    var days = Int()
    var basePrice = Double()
    var bottomPrice = Double()
    var taxes = Double()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        hotel = self.hotels
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.pageControle.numberOfPages = self.viewModel.imageData.count
        
        //MARK: Setup PageIndicater
        self.pageControle.drawer = ScaleDrawer(numberOfPages: self.viewModel.imageData.count, height: 10, width: 10, space: 10, raduis: 10, currentItem: 0, indicatorColor: .white, dotsColor: .clear, isBordered: true, borderColor: .white, borderWidth: 1.0, indicatorBorderColor: .white, indicatorBorderWidth: 1.0)
        
        self.viewModel.delegate = self
        self.setupTableView()
        self.setupCollectionView()
        
        LoaderClass.shared.loadAnimation()
        self.viewModel.fatchImages(code: hotels?.sHotelCode ?? "",view: self)
        
        let params: [String: AnyObject] = [WSResponseParams.WS_RESP_PARAM_SEARCH_ID: searchId as AnyObject,
                                           WSResponseParams.WS_RESP_PARAM_HOTEL_CODE: hotels?.sHotelCode as AnyObject,
                                           WSResponseParams.WS_RESP_PARAM_LOGID: logId as AnyObject,
                                           WSRequestParams.WS_REQS_PARAM_CHECKIN: checkIn as AnyObject,
                                           WSRequestParams.WS_REQS_PARAM_CHECKOUT: checkOut as AnyObject,
                                           WSRequestParams.WS_REQS_PARAM_ROOMS: finalRooms as AnyObject]
        self.viewModel.fatchHotelDetails(param: params,view: self)
        self.setupData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = self.facilityCollection.collectionViewLayout.collectionViewContentSize.height
        self.facilityCollectionHeight.constant = height
    }
    //MARK: - Custom methods
    func setupCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.ragisterNib(nibName: HotelImagesXIB().identifire)
        self.scrollView.delegate = self
        
        self.facilityCollection.delegate = self
        self.facilityCollection.dataSource = self
        self.facilityCollection.ragisterNib(nibName: FacilityCollectionXIB().identifire)
    }
    
    func setupTableView(){
        self.overViewTableView.delegate = self
        self.overViewTableView.dataSource = self
        self.tblViewFacilities.delegate = self
        self.tblViewFacilities.dataSource = self
        self.overViewTableView.ragisterNib(nibName: OverViewXIB().identifire)
        self.overViewTableView.tableFooterView = UIView()
        self.tblViewFacilities.ragisterNib(nibName: HotelfacilityXIB().identifire)
        self.overViewTableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
    }
    
    //MARK: Add Observer For Tableview Height
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Strings.CONTENT_SIZE {
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                DispatchQueue.main.async {
                    self.overViewTableHeight.constant = newsize.height
                }
            }
        }
    }
    //MARK: - @IBActions
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
    @IBAction func actionTaxInfo(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .TaxBifurcationVC, StoryboardName: .Flight) as? TaxBifurcationVC {
            vc.otherChagerOrOT = "Base Price: ₹\(basePrice.rounded())"
           // "Taxes & Fee: ₹\(String(format: "%.0f", (bottomPrice - basePrice)))"
            vc.tax = "Taxes & Fee: ₹\(String(format: "%.0f", (bottomPrice - basePrice)))"
                vc.titleStr = ""
            LoaderClass.shared.presentPopover(self, vc, sender: sender, size: CGSize(width: 200, height: 65),arrowDirection: .any)
        }
    }
    
    @IBAction func viewAllOnPress(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            let vc = WithURLsViewController()
            vc.images = self.imagesUrl
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func dateOnPress(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .CalendarPopUpVC, StoryboardName: .Hotels) as? CalendarPopUpVC{
            vc.firstDate = returnDate(viewModel.checkIN,strFormat: "yyyy-MM-dd")
            vc.lastDate = returnDate(viewModel.checkOut,strFormat: "yyyy-MM-dd")
            vc.doneCompletion = {
                firstDate, lastDate in
                
                let param = [WSResponseParams.WS_RESP_PARAM_SEARCH_ID: self.searchId as AnyObject,
                             WSResponseParams.WS_RESP_PARAM_HOTEL_CODE: self.hotels?.sHotelCode as AnyObject,
                             WSResponseParams.WS_RESP_PARAM_LOGID: self.logId as AnyObject,
                             WSRequestParams.WS_REQS_PARAM_CHECKIN: firstDate as AnyObject,
                             WSRequestParams.WS_REQS_PARAM_CHECKOUT: lastDate as AnyObject,
                             WSRequestParams.WS_REQS_PARAM_ROOMS: self.finalRooms as AnyObject]
                self.viewModel.checkHotelavAilablity(param: param,view: self)
                self.isGuest = false
            }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func guestOnPress(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .SelectGuestsPopUpVC, StoryboardName: .Hotels) as? SelectGuestsPopUpVC{
            vc.hotelData = hotelData
            vc.tblVwCount = numberOfRooms
            vc.doneCompletion = {
                finalRoom, hotelData, tblCount in
                
                let param = [WSResponseParams.WS_RESP_PARAM_SEARCH_ID: self.searchId as AnyObject,
                             WSResponseParams.WS_RESP_PARAM_HOTEL_CODE: self.hotels?.sHotelCode as AnyObject,
                             WSResponseParams.WS_RESP_PARAM_LOGID: self.logId as AnyObject,
                             WSRequestParams.WS_REQS_PARAM_CHECKIN: self.convertTraveDate(date: self.viewModel.checkIN) as AnyObject,
                             WSRequestParams.WS_REQS_PARAM_CHECKOUT: self.convertTraveDate(date: self.viewModel.checkOut) as AnyObject,
                             WSRequestParams.WS_REQS_PARAM_ROOMS: finalRoom as AnyObject]
                self.viewModel.checkHotelavAilablity(param: param,view: self)
                self.isGuest = true
                self.hotelData = hotelData
                self.numberOfRooms = tblCount
            }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func overViewOnPress(_ sender: UIButton) {
        self.lblTitleOverView.font = .boldFont(size: 14)
        self.lblTitleFacility.font = .regularFont(size: 14)
        self.lblTitleOverView.textColor = .customPink()
        self.lblTitleFacility.textColor = .grayColor()
        self.lblTitleFacilityBottomView.isHidden = true
        self.lblTitleOverviewBottomView.isHidden = false
        
        self.lblOverView.isHidden = true
        self.overViewTableView.isHidden = false
        self.facilityCollection.isHidden = true
        self.selectedtab = 0
        
        if ((self.hotelDetail?.sDescription.isValidHtmlString()) != nil) {
            let newString = self.hotelDetail?.sDescription.html2String.replacingOccurrences(of: ".  ", with: ". ", options: .literal, range: nil)
            self.overViewData = newString?.components(separatedBy: ". ") ?? []
        }else{
            let newString = self.hotelDetail?.sDescription.replacingOccurrences(of: ".  ", with: ". ", options: .literal, range: nil)
            self.overViewData = newString?.components(separatedBy: ". ") ?? []
        }
        
        self.overViewTableView.reloadData()
        self.facilityCollection.reloadData()
    }
    
    @IBAction func facilityOnPress(_ sender: UIButton) {
        self.lblTitleFacility.font = .boldFont(size: 14)
        self.lblTitleOverView.font = .regularFont(size: 14)
        self.lblTitleFacility.textColor = .customPink()
        self.lblTitleOverView.textColor = .grayColor()
        self.lblTitleFacilityBottomView.isHidden = false
        self.lblTitleOverviewBottomView.isHidden = true
        //        self.lblOverView.text = self.hotelDetail?.sFacilities
        self.lblOverView.isHidden = true
        self.overViewTableView.isHidden = true
        self.facilityCollection.isHidden = false
        self.selectedtab = 1
        self.facilitiesData = self.hotelDetail?.sFacilities.components(separatedBy: ";") ?? []
        
        self.overViewTableView.reloadData()
        self.facilityCollection.reloadData()
    }
    
    @IBAction func openGoogleMap(_ sender: UIButton) {
        self.openGoogleMap(latDouble: 30.5887, longDouble: 76.8471)
    }
    
    @IBAction func selectRoomOnPress(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .HotelRoomsVC, StoryboardName: .Hotels) as? HotelRoomsVC{
            vc.hotelDetail = self.hotelDetail
            vc.markups = self.markups
            vc.hotels = self.hotels
            vc.totalGuest = "\(self.viewModel.no_of_adults)"
            vc.totalRooms = "\(self.viewModel.no_of_rooms)"
            vc.checkInDate = self.convertTraveDate(date: self.viewModel.checkIN)
            vc.checkOutDate = self.convertTraveDate(date: self.viewModel.checkOut)
            vc.logId = self.logId
            vc.taxes = taxes.rounded()
            vc.searchId = self.searchId
            vc.checkIn = self.viewModel.checkIN
            vc.checkOut = self.viewModel.checkOut
            vc.no_of_adults = self.viewModel.no_of_adults
            vc.no_of_nights = self.viewModel.no_of_nights
            vc.finalRooms = finalRooms
            self.pushView(vc: vc)
        }
    }
    
    private func setupData() {
        if let address = hotel?.sAddress {
            self.lblHotelAddress.text = address
        }
        if let name = hotel?.sName {
            self.lblHotelName.text = name
        }
        self.lblTotalGuestAndRoom.text = "\(self.viewModel.no_of_adults) Guests/\(self.viewModel.no_of_rooms) Room"
        
        if let minRate = hotel?.iMinRate {
            if let nonRefundable = minRate.sNonRefundable as? Bool {
                if nonRefundable {
                    self.lblNoRefund.text = Strings.NON_REFUNDABLE
                } else {
                    self.lblNoRefund.text = Strings.REFUNDABLE
                }
            }
            if var price = minRate.sPrice as? Double {
                basePrice = price-((minRate.sGSTPrice)+(minRate.sServiceFee))
                for i in 0..<markups.count {
                    let markup: Markup?
                    markup = markups[i]
                    if markup?.starRating == hotel?.iCategory {
                        if markup?.amountBy == Strings.PERCENT {

                            print("base price \(price)")
                            let tax = ((price * (markup?.amount ?? 0) / 100) * 18) / 100
                            print("tax amount \(tax)")
                            price += (price * (markup?.amount ?? 0) / 100) + tax
                            print("total price \(price)")
                        } else {
                            print("base price \(price)")

                            let tax = ((markup?.amount ?? 0)  * 18) / 100
                            price += (markup?.amount ?? 0) + tax
                        }
                    }
                }
                if price > 5000 {
                    conviencefee = 400
                } else if price > 3000 {
                    conviencefee = 250
                } else if price > 1200 {
                    conviencefee = 150
                } else {
                    conviencefee = 100
                }
                
                self.lblTaxText.text = "+ ₹\(conviencefee) convenience fee + 18% GST"
                self.lblPrice.text = "₹\(String(format: "%.0f", price))"
                bottomPrice = price
            }
        }
        if let rating = hotel?.iCategory {
            self.lblRate.text = "\(rating)/5"
        }
        self.cnstTblVwFacilityHeight.constant = hotel?.iMinRate.sNonRefundable == true ?  CGFloat((self.hotel?.iMinRate.sBoardingDetails.count ?? 0)*25)+30 : CGFloat((self.hotel?.iMinRate.sBoardingDetails.count ?? 0)*25)
        self.tblViewFacilities.reloadData()
        taxes = bottomPrice-basePrice
    }
}

extension HotelDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.facilityCollection {
            return self.selectedtab == 0 ? 0 : self.facilitiesData.count
        } else {
            return self.viewModel.imageData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.facilityCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FacilityCollectionXIB().identifire, for: indexPath) as! FacilityCollectionXIB
            
            cell.lblTitle.text = self.facilitiesData[indexPath.item]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelImagesXIB().identifire, for: indexPath) as! HotelImagesXIB
            let dict = self.viewModel.imageData[indexPath.row]
            
            cell.imgHotel.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
            cell.imgHotel.sd_setImage(with: URL(string: dict[WSResponseParams.WS_RESP_PARAM_URL] as? String ?? ""), placeholderImage: .hotelplaceHolder())
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.facilityCollection{
            return CGSize(width: self.facilityCollection.frame.size.width / 2 , height: 30)
        }else{
            return CGSize(width: self.collectionView.frame.size.width, height: (self.collectionView.frame.size.height))
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView{
            
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            
            let index = Int(round(offSet/width))
            print(index)
            self.pageControle.setPage(index)
            
        }
    }
}

//MARK: Setup Data

extension HotelDetailsVC:ResponseProtocol{
    
    func onFail(msg: String) {
        if msg == CommonError.INTERNET {
            if let vc = ViewControllerHelper.getViewController(ofType: .NoInternetVC, StoryboardName: .Main ) as? NoInternetVC {
                self.present(vc, animated: true)
            }
        } else if msg == "Something went wrong" {
            popView()
        } else {
            self.view.layoutIfNeeded()
            self.priceViewHeight.constant = 0
            self.hotelNotAvlableViewHeight.constant = 80
            self.lblNoHotel.numberOfLines = 0
            self.hotelNotAvlable.isHidden = false
            self.lblNoHotel.text = msg
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                self.priceViewHeight.constant = 80
                self.hotelNotAvlableViewHeight.constant = 0
                self.hotelNotAvlable.isHidden = true
            })
        }
    }
    
    func onSuccess() {
        
        self.collectionView.reloadData()
        self.setData(self.viewModel.hotelDetails)
        
        DispatchQueue.main.async {
            self.imagesUrl.removeAll()
            for index in self.viewModel.imageData{
                if let url = URL(string: index[WSResponseParams.WS_RESP_PARAM_URL] as? String ?? "") {
                    self.imagesUrl.append(url)
                }
            }
        }
        self.pageControle.numberOfPages = self.viewModel.imageData.count
        self.view.layoutIfNeeded()
        self.priceViewHeight.constant = 80
        self.hotelNotAvlableViewHeight.constant = 0
        self.hotelNotAvlable.isHidden = true
        
        if isGuest ?? false {
            self.lblTotalGuestAndRoom.text = "\(self.viewModel.no_of_adults) Guests/\(self.viewModel.no_of_rooms) Room"
        } else {
            self.lblTraveDate.text = "\(self.convertTraveDate(date: self.viewModel.checkIN)) - \(self.convertTraveDate(date: self.viewModel.checkOut))"
        }
    }
    
    func setData(_ response: HotelDetail) {
        self.hotelDetail = response
        
        if let address = hotelDetail?.sAddress {
            self.lblHotelAddress.text = address
        }
        
        if let name = hotelDetail?.sName {
            self.lblHotelName.text = name
            //self.lblNameHotel.text = "About \(name)"
        }
        
        if let rating = hotelDetail?.iCategory {
            self.lblRate.text = "\(rating)/5"
        }
        
        if let overView = hotelDetail?.sDescription {
            // self.lblOverView.text = overView
            self.lblOverView.isHidden = true
            self.overViewTableView.isHidden = false
            self.facilityCollection.isHidden = true
            self.selectedtab = 0
            
            if overView.isValidHtmlString() {
                let newString = overView.html2String.replacingOccurrences(of: ".  ", with: ". ", options: .literal, range: nil)
                
                self.overViewData = newString.components(separatedBy: ". ")
            }else{
                let newString = overView.replacingOccurrences(of: ".  ", with: ". ", options: .literal, range: nil)
                
                self.overViewData = newString.components(separatedBy: ". ")
            }
            
            self.overViewTableView.reloadData()
            self.facilityCollection.reloadData()
        }
        
        if let facility = hotelDetail?.sFacilities {
            self.facilities = facility.components(separatedBy: "; ")
        }
        
        for index in self.hotelDetail?.rates ?? []{
            if index.sNonRefundable == true{
                self.lblNoRefund.text = Strings.NON_REFUNDABLE
                self.lblNoRefund.textColor = .customPink()
                break
            }else{
                self.lblNoRefund.text = Strings.REFUNDABLE
                self.lblNoRefund.textColor = .customBlueColor()
            }
        }
        
        self.lblTraveDate.text = "\(self.convertTraveDate(date: self.viewModel.checkIN)) - \(self.convertTraveDate(date: self.viewModel.checkOut))"
        self.lblTotalGuestAndRoom.text = "\(self.viewModel.no_of_adults) Guests/\(self.viewModel.no_of_rooms) Room"
        
        if let minRate = self.hotelDetail?.rates {
            if minRate.count > 0{
                let dict = minRate[0]
                if var price = dict.sPrice as? Double {
                    for i in 0..<markups.count {
                        let markup: Markup?
                        markup = markups[i]
                        if markup?.starRating ?? 0 == Double(hotelDetail?.iCategory ?? 0) {
                            if markup?.amountBy == Strings.PERCENT {
                                print("base price \(price)")
                                let tax = ((price * (markup?.amount ?? 0) / 100) * 18) / 100
                                print("tax amount \(tax)")
                                price += (price * (markup?.amount ?? 0) / 100) + tax
                                print("total price \(price)")
                            } else {
                                print("base price \(price)")
                                let tax = ((markup?.amount ?? 0)  * 18) / 100
                                price += (markup?.amount ?? 0) + tax
                            }
                        }
                    }
                    self.lblPrice.text = "₹\(String(format: "%.0f", price))"
                }
            }
        }
    }
}

//extension HotelDetailsVC:HotelDetails{
//
//    func getHotelDetails(checkIn: String, checkInDate: String, checkOut: String, finalRooms: [[String : AnyObject]], numberOfRooms: Int, numberOfAdults: Int, ageOfChildren: [Int], selectedIndex: Int, section: Int, paramCheckHotel: [[String : Any]]) {
//
//        let param = [WSResponseParams.WS_RESP_PARAM_SEARCH_ID: searchId as AnyObject,
//                     WSResponseParams.WS_RESP_PARAM_HOTEL_CODE: hotels?.sHotelCode as AnyObject,
//                     WSResponseParams.WS_RESP_PARAM_LOGID: logId as AnyObject,
//                     WSRequestParams.WS_REQS_PARAM_CHECKIN: checkIn as AnyObject,
//                     WSRequestParams.WS_REQS_PARAM_CHECKOUT: checkOut as AnyObject,
//                     WSRequestParams.WS_REQS_PARAM_ROOMS: finalRooms as AnyObject]
//        self.viewModel.checkHotelavAilablity(param: param,view: self)
//    }
//}

extension HotelDetailsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblViewFacilities {
            
            if let boardingDetail = hotel?.iMinRate.sBoardingDetails {
                return hotel?.iMinRate.sNonRefundable == true ? boardingDetail.count+1 : boardingDetail.count
            } else {
                return 0
            }
        } else {
            return self.selectedtab == 0 ? self.overViewData.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblViewFacilities {
            let cell = tableView.dequeueReusableCell(withIdentifier: HotelfacilityXIB().identifire, for: indexPath) as! HotelfacilityXIB
            
            if indexPath.row == (hotel?.iMinRate.sBoardingDetails.count ?? 0)-1 {
                cell.lblTitle.text = hotel?.iMinRate.sBoardingDetails[indexPath.row]
            } else {
                cell.lblTitle.text = "Non-Refundable"
            }
            
            cell.imgVwTick.isHidden = false
            cell.dotView.isHidden = true
            cell.lblTitle.textColor = hotel?.iMinRate.sNonRefundable == true ? ((hotel?.iMinRate.sBoardingDetails.count ?? 0) - 1) == indexPath.row ? .cutomRedColor() : .theamColor() : .theamColor()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: OverViewXIB().identifire, for: indexPath) as! OverViewXIB
            cell.lblTitle.text = self.overViewData[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == tblViewFacilities ? 30 : UITableView.automaticDimension
    }
}
extension HotelDetailsVC: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
