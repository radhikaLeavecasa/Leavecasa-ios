//
//  TripsVC.swift
//  LeaveCasa
//
//  Created by acme on 27/09/22.
//

import UIKit
import IBAnimatable
import DropDown

class TripsVC: UIViewController {
    //MARK: - @IBOutlets

    @IBOutlet weak var collvwHeader: UICollectionView!
    @IBOutlet weak var tableVIew: UITableView!
    //MARK: - Variables
    var indexCount = 1
    var viewModel = TripViewModel()
    var flight_booking: [TripFlightBooking]?
    var hotel: [TripHotel]?
    var bus: [TripBus]?
    var insurance: [InsuranceBookingResponse]?
    var filteredFlight_booking: [TripFlightBooking]?
    var filteredHotel: [TripHotel]?
    var filteredBus: [TripBus]?
    let refreshControl = UIRefreshControl()
    var selectedIndex = Int()
    var selectedHeaderTab = 0
    var arrHeader = ["Hotel", "Bus", "Flight", "Insurance"]
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.setupUpCommingView()
        self.viewModel.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false {
            self.viewModel.callBookingList(view: self)
        }
    }
    //MARK: - @IBActions
    @IBAction func filterOnPress(_ sender: UIButton) {
        self.showShortDropDown(view: sender)
    }
    
    @IBAction func upcomingOnPress(_ sender: UIButton) {
        self.indexCount = 1
       // self.setupUpCommingView()
    }
    
    @IBAction func cancelOnPress(_ sender: UIButton) {
        self.indexCount = 2
       // self.setupCancelledView()
    }
    
    @IBAction func compeleOnPress(_ sender: UIButton) {
        self.indexCount = 3
        //self.setupCompletedView()
    }
    
    //MARK: - Custom methods
    func setupTableView() {
        self.tableVIew.delegate = self
        self.tableVIew.dataSource = self
        self.tableVIew.ragisterNib(nibName: TripXIB().identifire)
        self.tableVIew.ragisterNib(nibName: NoDataFoundXIB().identifire)
        self.tableVIew.ragisterNib(nibName: BusBookingTripXIB().identifire)
        self.tableVIew.ragisterNib(nibName: FlightBookingTripXIB().identifire)
        self.tableVIew.ragisterNib(nibName: "InsurancePurchasedListTVC")
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableVIew.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.viewModel.callBookingList(view: self)
    }
    @objc func cancelHotelBooking(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .CommonPopupVC, StoryboardName: .Main) as? CommonPopupVC {
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.isNoHide = false
            vc.type = "Hotel Cancel"
            vc.titleStr = "Are you sure you want to cancel booking?"
            vc.msg = AlertMessages.CANCELLATION_ALERT
            vc.noTitle = AlertKeys.NO
            vc.yesTitle = AlertKeys.YES
            vc.tapCallback = {
                self.viewModel.callCancelHotelBooking(bookingId: self.hotel?[sender.tag].booking_id ?? "", view: self)
            }
            self.present(vc, animated: true)
        }
    }
    
    @objc func cancelBusBooking(_ sender: UIButton) {
        if indexCount == 2 {
            if let vc = ViewControllerHelper.getViewController(ofType: .CommonPopupVC, StoryboardName: .Main) as? CommonPopupVC {
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.isNoHide = false
                vc.type = "Bus Cancel"
                vc.titleStr = "Are you sure you want to cancel booking?"
                vc.msg = AlertMessages.CANCELLATION_ALERT
                vc.noTitle = AlertKeys.NO
                vc.yesTitle = AlertKeys.YES
                vc.tapCallback = {
                    let param = [WSRequestParams.WS_REQS_PARAM_TIN: self.bus?[sender.tag].bus_details?.tin as AnyObject,
                                 WSRequestParams.WS_REQS_PARAM_SEATS_TO_CANCEL: self.bus?[sender.tag].bus_details?.inventoryItems?.seatName
                                 as AnyObject,
                                 WSRequestParams.WS_REQS_PARAM_BOOKING_ID: self.bus?[sender.tag].booking_id as AnyObject]
                    self.viewModel.callCancelBusBooking(param, view: self)
                }
                self.present(vc, animated: true)
            }
        }
    }
    
    @objc func cancelFlightBooking(_ sender: UIButton) {
        if indexCount == 3 {
            let requestType = "2"
            if let vc = ViewControllerHelper.getViewController(ofType: .CommonPopupVC, StoryboardName: .Main) as? CommonPopupVC {
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.isNoHide = false
                vc.type = "Flight Cancel"
                vc.titleStr = "Are you sure you want to cancel booking?"
                vc.msg = AlertMessages.CANCELLATION_ALERT
                vc.noTitle = AlertKeys.NO
                vc.yesTitle = AlertKeys.YES
                vc.tapCallback = {
                    let param = [WSRequestParams.WS_REQS_PARAM_BOOKING_ID: self.flight_booking?[sender.tag].flight_details?.bookingId as AnyObject,
                                 WSRequestParams.WS_REQS_PARAM_REQUEST_TYPE: "3" as AnyObject,
                                 WSRequestParams.WS_REQS_PARAM_REMARKS: "Test Remarks" as AnyObject]
                    
                    if requestType == "2" {
                      //  param[WSRequestParams.WS_REQS_PARAM_TICKET_ID] = "" as AnyObject
                    }
                    
                    self.viewModel.callCancelFlightBooking(param, view: self)
                }
                self.present(vc, animated: true)
            }
        }
    }
    
    //MARK: Setup All Buttion Action
//    func setupUpCommingView() {
//        self.btnUpComing.backgroundColor = .lightBlue()
//        self.btnUpComing.setTitleColor(.white, for: .normal)
//        self.btnUpComing.titleLabel?.font = .boldFont(size: 16)
//        
//        self.btnCancelled.backgroundColor = .white
//        self.btnCancelled.setTitleColor(.theamColor(), for: .normal)
//        self.btnCancelled.titleLabel?.font = .regularFont(size: 14)
//        
//        self.btnComplete.backgroundColor = .white
//        self.btnComplete.setTitleColor(.theamColor(), for: .normal)
//        self.btnComplete.titleLabel?.font = .regularFont(size: 14)
//        
//        self.tableVIew.reloadData()
//    }
    
//    func setupCancelledView() {
//        self.btnCancelled.backgroundColor = .lightBlue()
//        self.btnCancelled.setTitleColor(.white, for: .normal)
//        self.btnCancelled.titleLabel?.font = .boldFont(size: 16)
//        
//        self.btnUpComing.backgroundColor = .white
//        self.btnUpComing.setTitleColor(.theamColor(), for: .normal)
//        self.btnUpComing.titleLabel?.font = .regularFont(size: 14)
//        
//        self.btnComplete.backgroundColor = .white
//        self.btnComplete.setTitleColor(.theamColor(), for: .normal)
//        self.btnComplete.titleLabel?.font = .regularFont(size: 14)
//        
//        self.tableVIew.reloadData()
//    }
    
//    func setupCompletedView() {
//        self.btnComplete.backgroundColor = .lightBlue()
//        self.btnComplete.setTitleColor(.white, for: .normal)
//        self.btnComplete.titleLabel?.font = .boldFont(size: 16)
//        
//        self.btnUpComing.backgroundColor = .white
//        self.btnUpComing.setTitleColor(.theamColor(), for: .normal)
//        self.btnUpComing.titleLabel?.font = .regularFont(size: 14)
//        
//        self.btnCancelled.backgroundColor = .white
//        self.btnCancelled.setTitleColor(.theamColor(), for: .normal)
//        self.btnCancelled.titleLabel?.font = .regularFont(size: 14)
//        
//        self.tableVIew.reloadData()
//    }
    
    func showShortDropDown(view: UIView) {
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.width = 130
        dropDown.textFont = .regularFont(size: 16)
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = ["All","Upcoming","Cancelled","Completed"]
        
        let currentDate = convertDate(Date())
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            debugPrint("Selected item: \(item) at index: \(index)")
            
            hotel = filteredHotel
            bus = filteredBus
            flight_booking = filteredFlight_booking
            selectedIndex = index
            if index == 1 {
                hotel = hotel?.filter{ $0.booking_status == Strings.CONFIRMED && $0.from_date ?? "" > currentDate }
                bus = bus?.filter{ $0.booking_status == Strings.CONFIRMED &&  $0.journey_date ?? "" > currentDate }
                flight_booking = flight_booking?.filter{ $0.booking_status == Strings.CONFIRMED && $0.flight_details?.flightItinerary?.segments.first?.origin?.depTime ?? "" > currentDate }
            }
            else if index == 2 {
                hotel = hotel?.filter{$0.booking_status?.lowercased() == item.lowercased() }
                bus = bus?.filter{$0.booking_status?.lowercased() == item.lowercased() }
                flight_booking = flight_booking?.filter{$0.booking_status?.lowercased() == item.lowercased() }
            }
            else if index == 3 {
                hotel = hotel?.filter{ $0.booking_status == Strings.CONFIRMED && $0.from_date ?? "" < currentDate }
                bus = bus?.filter{ $0.booking_status == Strings.CONFIRMED && $0.journey_date ?? "" < currentDate }
                flight_booking = flight_booking?.filter{ $0.booking_status == Strings.CONFIRMED && $0.flight_details?.flightItinerary?.segments.first?.origin?.depTime ?? "" < currentDate }
            }
            self.tableVIew.reloadData()
        }
     dropDown.show()
    }
}

// MARK: - UITABLEVIEW METHODS
extension TripsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.indexCount == 1 {
            if hotel?.count ?? 0 == 0 || WebService.isConnectedToInternet() == false {
                return 1
            }
            else {
                return hotel?.count ?? 0
            }
        }else if self.indexCount == 2 {
            if bus?.count ?? 0 == 0 || WebService.isConnectedToInternet() == false {
                return 1
            }
            else {
                return bus?.count ?? 0
            }
        } else if self.indexCount == 3 {
            if flight_booking?.count ?? 0 == 0 || WebService.isConnectedToInternet() == false {
                return 1
            }
            else {
                return flight_booking?.count ?? 0
            }
        } else {
            if insurance?.count ?? 0 == 0 || WebService.isConnectedToInternet() == false {
                return 1
            }
            else {
                return insurance?.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentDate = convertDate(Date())
        
        if WebService.isConnectedToInternet() == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundXIB().identifire, for: indexPath) as! NoDataFoundXIB
            if WebService.isConnectedToInternet() == false {
                cell.img.image = .internetConnection()
                cell.lblTitleMsg.text = AlertMessages.NOT_CONNECTED_TO_INTERNET
                cell.lblMsg.text = AlertMessages.DISCONNECTED
                cell.lblSubTitleMsg.text = ""
            }
            return cell
        } else {
            if self.indexCount == 1 {
                if hotel?.count ?? 0 == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundXIB().identifire, for: indexPath) as! NoDataFoundXIB
                    cell.img.image = .noHotels()
                    cell.lblMsg.text = selectedIndex == 1 ? AlertMessages.NO_UPCOMING_BOOKINGS : selectedIndex == 2 ? AlertMessages.NO_CANCELLED_BOOKINGS : selectedIndex == 3 ? AlertMessages.NO_BOOKINGS_HISTORY : AlertMessages.NO_BOOKINGS
                    cell.lblTitleMsg.text = ""
                    cell.lblSubTitleMsg.text = ""
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: FlightBookingTripXIB().identifire, for: indexPath) as! FlightBookingTripXIB
                    let indexdata = hotel?[indexPath.row].tripHotel
                    let fromDate = hotel?[indexPath.row].from_date?.hotelDate() ?? ""
                    let toDate = hotel?[indexPath.row].to_date?.hotelDate() ?? ""
                    
                    cell.lblHotelName.text = indexdata?.name?.capitalized ?? ""
                    cell.lblLocation.text = "\(indexdata?.address?.capitalized ?? ""), \(indexdata?.city_name?.capitalized ?? "")"
                    cell.lblDate.text = "\(fromDate) - \(toDate)"
                    
                    cell.imgHotel.contentMode = self.viewModel.tripModel?.data?.hotel?[indexPath.row].hotelImages?.first?.image_url != nil ? .scaleAspectFill : .scaleAspectFit
                    cell.imgHotel.sd_setImage(with: URL(string: "https://images.grnconnect.com/\(self.viewModel.tripModel?.data?.hotel?[indexPath.row].hotelImages?.first?.image_url ?? "")"), placeholderImage: .hotelplaceHolder())
                    
                    if hotel?[indexPath.row].booking_status == Strings.CONFIRMED && hotel?[indexPath.row].from_date ?? "" > currentDate {
                        cell.btnCancel.isHidden = false
                        cell.stackViewHeightConstraint.constant = 34
                    } else {
                        cell.btnCancel.isHidden = true
                        cell.stackViewHeightConstraint.constant = 0
                    }
                    
                    cell.btnCancel.tag = indexPath.row
                    cell.btnCancel.addTarget(self, action: #selector(cancelHotelBooking(_:)), for: .touchUpInside)
                    
                    return cell
                }
            }
            else if self.indexCount == 2 {
                if bus?.count ?? 0 == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundXIB().identifire, for: indexPath) as! NoDataFoundXIB
                    
                    cell.img.image = .noBuses()
                    cell.lblMsg.text = selectedIndex == 1 ? AlertMessages.NO_UPCOMING_BOOKINGS : selectedIndex == 2 ? AlertMessages.NO_CANCELLED_BOOKINGS : selectedIndex == 3 ? AlertMessages.NO_BOOKINGS_HISTORY : AlertMessages.NO_BOOKINGS
                    cell.lblTitleMsg.text = ""
                    cell.lblSubTitleMsg.text = ""
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: BusBookingTripXIB().identifire, for: indexPath) as! BusBookingTripXIB
                    let indexdata = bus?[indexPath.row]
                    
                    cell.lblTitle.text = indexdata?.bus_details?.travels?.capitalized ?? ""
                    cell.lblDate.text = "\(indexdata?.journey_date?.busDate() ?? "") | \(getTimeString(time: indexdata?.bus_details?.pickupTime ?? ""))"
                    cell.lblBoarding.text = "Boarding: \(indexdata?.bus_details?.pickupLocation ?? "")"
                    cell.lblLocation.text = "\(indexdata?.bus_details?.sourceCity?.capitalized ?? "") - \(indexdata?.bus_details?.destinationCity?.capitalized ?? "")"
                    cell.imgBus.image = .bus()
                    
                    if indexdata?.booking_status == Strings.CONFIRMED && indexdata?.journey_date ?? "" > currentDate {
                        cell.btnCancel.isHidden = false
                        cell.cnstCancelHeight.constant = 34
                    }
                    else {
                        cell.btnCancel.isHidden = true
                        cell.cnstCancelHeight.constant = 10
                    }
                    
                    cell.btnCancel.tag = indexPath.row
                    cell.btnCancel.addTarget(self, action: #selector(cancelBusBooking(_:)), for: .touchUpInside)
                    
                    return cell
                }
            } else if self.indexCount == 3 {
                if flight_booking?.count ?? 0 == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundXIB().identifire, for: indexPath) as! NoDataFoundXIB
                    cell.img.image = .noFlight()
                    cell.lblMsg.text = selectedIndex == 1 ? AlertMessages.NO_UPCOMING_BOOKINGS : selectedIndex == 2 ? AlertMessages.NO_CANCELLED_BOOKINGS : selectedIndex == 3 ? AlertMessages.NO_BOOKINGS_HISTORY : AlertMessages.NO_BOOKINGS
                    cell.lblTitleMsg.text = ""
                    cell.lblSubTitleMsg.text = ""
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: BusBookingTripXIB().identifire, for: indexPath) as! BusBookingTripXIB
                    let indexdata = flight_booking?[indexPath.row]
                    
                    cell.lblTitle.text = indexdata?.flight_details?.flightItinerary?.segments.first?.airline?.airlineName?.capitalized ?? ""
                    cell.lblDate.text = indexdata?.flight_details?.flightItinerary?.segments.first?.origin?.depTime?.convertDate() ?? ""
                    cell.lblBoarding.text = "Boarding: \(indexdata?.flight_details?.flightItinerary?.segments.first?.origin?.airport?.airportName ?? "")"
                    cell.lblLocation.text = "\(indexdata?.flight_details?.flightItinerary?.segments.first?.origin?.airport?.cityName ?? "".capitalized ) - \(indexdata?.flight_details?.flightItinerary?.segments.last?.destination?.airport?.cityName ?? "".capitalized )"
                    cell.imgBus.image = .flight()
                    
                    if indexdata?.booking_status == Strings.CONFIRMED && indexdata?.flight_details?.flightItinerary?.segments.first?.origin?.depTime ?? "" > currentDate {
                        cell.btnCancel.isHidden = false
                        cell.cnstCancelHeight.constant = 34
                    }
                    else {
                        cell.btnCancel.isHidden = true
                        cell.cnstCancelHeight.constant = 10
                    }
                    
                    cell.btnCancel.tag = indexPath.row
                    cell.btnCancel.addTarget(self, action: #selector(cancelFlightBooking(_:)), for: .touchUpInside)
                    
                    return cell
                }
            } else {
                if insurance?.count ?? 0 == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundXIB().identifire, for: indexPath) as! NoDataFoundXIB
                    cell.img.image = UIImage(named: ("ic_insurance_notfound"))
                    cell.lblMsg.text = "No Insurance Found!"
                    cell.lblTitleMsg.text = ""
                    cell.lblSubTitleMsg.text = ""
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "InsurancePurchasedListTVC", for: indexPath) as! InsurancePurchasedListTVC
                    cell.lblInsuranceName.text = insurance?[indexPath.row].details?.response?.itinerary?.planName
                    cell.lblInsuranceDescription.text = insurance?[indexPath.row].details?.response?.itinerary?.planDescription
                    cell.lblPaxCount.text = "/\(insurance?[indexPath.row].details?.response?.itinerary?.paxInfo?.count ?? 1) pax"
                    cell.btnViewDetails.addTarget(self, action: #selector(insuranceDetail), for: .touchUpInside)
                    let conFee = insurance?[indexPath.row].details?.response?.itinerary?.planCoverage == 4 ? 59 : 118
                    let data = insurance?[indexPath.row].details?.response?.itinerary
                    cell.lblPrice.text = "₹\(((data?.paxInfo?[0].price?.publishedPrice ?? 0)+conFee)*(data?.paxInfo?.count ?? 1))"
                    cell.btnViewDetails.tag = indexPath.row
                    return cell
                }
            }
        }
    }
    
    @objc func insuranceDetail(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .InsuranceDetailVC, StoryboardName: .Main) as? InsuranceDetailVC {
            vc.bookingId = insurance?[sender.tag].details?.response?.itinerary?.bookingId ?? 0
            vc.viewModel.insuranceDetailModel = insurance?[sender.tag].details?.response?.itinerary
            vc.status = insurance?[sender.tag].status ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexCount == 1 {
            if let vc = ViewControllerHelper.getViewController(ofType: .HotelTripDetailVC, StoryboardName: .Main) as? HotelTripDetailVC {
                if hotel?.count ?? 0 > 0 {
                    vc.hotelDetail = hotel?[indexPath.row]
                }
                    self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if indexCount == 2 {
            if let vc = ViewControllerHelper.getViewController(ofType: .BusTripDetailVC, StoryboardName: .Main) as? BusTripDetailVC {
                vc.busDetail = bus?[indexPath.row]
                vc.doneCompletion = {
                    val in
                    if val == 0 {
                        if let vc = ViewControllerHelper.getViewController(ofType: .CommonPopupVC, StoryboardName: .Main) as? CommonPopupVC {
                            vc.modalPresentationStyle = .overFullScreen
                            vc.modalTransitionStyle = .crossDissolve
                            vc.isNoHide = true
                            vc.titleStr = "Are you sure you want to cancel booking?"
                            vc.msg = AlertMessages.CANCELLATION_ALERT
                            vc.noTitle = AlertKeys.NO
                            vc.yesTitle = AlertKeys.YES
                            vc.tapCallback = {
                                let param = [WSRequestParams.WS_REQS_PARAM_TIN: self.bus?[indexPath.row].bus_details?.tin as AnyObject,
                                             WSRequestParams.WS_REQS_PARAM_SEATS_TO_CANCEL: self.bus?[indexPath.row].bus_details?.inventoryItems?.seatName
                                             as AnyObject,
                                             WSRequestParams.WS_REQS_PARAM_BOOKING_ID: self.bus?[indexPath.row].booking_id as AnyObject]
                                
                                self.viewModel.callCancelBusBooking(param, view: self)
                            }
                            self.present(vc, animated: true)
                        }
                    } else {
                        if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
                            vc.bookingId = "\(self.flight_booking?[indexPath.row].id ?? 0)"
                            vc.type = self.indexCount
                            self.pushView(vc: vc,title: AlertMessages.INVOICE)
                        }
                    }
                }
                self.present(vc, animated: true)
            }
        } else if indexCount == 3 {
            if let vc = ViewControllerHelper.getViewController(ofType: .FlightTripDetailVC, StoryboardName: .Main) as? FlightTripDetailVC {
                if flight_booking?.count ?? 0 > 0 {
                    vc.flightDetail = flight_booking?[indexPath.row]
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
extension TripsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrHeader.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyTripsCVC", for: indexPath) as! MyTripsCVC
        cell.btnHeader.setTitle(arrHeader[indexPath.row], for: .normal)
        cell.vwBackground.backgroundColor = selectedHeaderTab == indexPath.row ? .lightBlue() : .white
        cell.btnHeader.setTitleColor(selectedHeaderTab == indexPath.row ? .white : .theamColor(), for: .normal)
        cell.btnHeader.titleLabel?.font = selectedHeaderTab == indexPath.row ? .boldFont(size: 16) : .regularFont(size: 14)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MyTripsCVC
        selectedHeaderTab = indexPath.row
        indexCount = indexPath.row + 1
        tableVIew.reloadData()
        collvwHeader.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let label = UILabel(frame: CGRect.zero)
//        label.text = arrHeader[indexPath.item]
//        label.sizeToFit()
        return CGSize(width: self.collvwHeader.frame.width/4, height: self.collvwHeader.frame.size.height)
    }
}
// MARK: - API RESPONSE METHODS
extension TripsVC: ResponseProtocol {
    func onSuccess() {
        self.refreshControl.endRefreshing()
        self.setupTableView()
        
        hotel = self.viewModel.tripModel?.data?.hotel
        flight_booking = self.viewModel.tripModel?.data?.flight_booking
        bus = self.viewModel.tripModel?.data?.bus
        insurance = self.viewModel.tripModel?.data?.insurance
        
        filteredHotel = hotel
        filteredFlight_booking = flight_booking
        filteredBus = bus
        
        self.tableVIew.reloadData()
    }
    
    func onFail(msg: String) {
        self.setupTableView()
        self.refreshControl.endRefreshing()
        self.tableVIew.reloadData()
    }
}
