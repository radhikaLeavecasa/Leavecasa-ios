//
//  FlightTripDetailVC.swift
//  LeaveCasa
//
//  Created by acme on 25/09/23.
//

import UIKit
import IBAnimatable

class FlightTripDetailVC: UIViewController, ResponseProtocol {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var btnCancellationPolicy: UIButton!
    @IBOutlet weak var lblStatusTitle: UILabel!
    @IBOutlet weak var lblEndDateTime: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var tblVwTraveller: UITableView!
    @IBOutlet weak var vwCancellation: AnimatableView!
    @IBOutlet weak var lblTotalPaid: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var lblStartDateTime: UILabel!
    @IBOutlet weak var lblFlightName: UILabel!
    @IBOutlet weak var imgVwFlight: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCities: UILabel!
    @IBOutlet weak var tblVwPriceBreakUp: UITableView!
    @IBOutlet weak var btnInvoice: AnimatableButton!
    @IBOutlet weak var lblBookingId: UILabel!
    @IBOutlet weak var cnstPassTblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var cnstTblVwPriceBreakupHeight: NSLayoutConstraint!
    //MARK: - Variables
    var flightDetail: TripFlightBooking?
    var viewModel = TripViewModel()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        viewModel.delegate = self
        let currentDate = convertDate(Date())
        lblStatusTitle.text = flightDetail?.booking_status == "cancelled" ? "YOUR BOOKING HAS BEEN CANCELLED!" : flightDetail?.booking_status == "completed" ? "HOPE YOU ENJOYED THE JOURNEY!" : "HOPE YOU WILL ENJOY THE JOURNEY!"
        vwCancellation.isHidden = flightDetail?.booking_status == Strings.CONFIRMED && flightDetail?.flight_details?.flightItinerary?.segments.first?.origin?.depTime ?? "" > currentDate
        
        lblFlightName.text = flightDetail?.flightInnerDetail?.flightItinerary?.segments[0].airline?.airlineName
        lblDate.text = flightDetail?.flight_details?.flightItinerary?.segments.first?.origin?.depTime?.convertDate() ?? ""
        lblBookingId.text = "BOOKING ID \(flightDetail?.booking_id ?? 0)"
        lblCities.text = "\(flightDetail?.flight_details?.flightItinerary?.segments[0].origin?.airport?.cityName ?? "") -> \(flightDetail?.flight_details?.flightItinerary?.segments[0].destination?.airport?.cityName ?? "")"
        lblCities.text = "\(flightDetail?.flight_details?.flightItinerary?.segments[0].origin?.airport?.cityName ?? "") -> \(flightDetail?.flight_details?.flightItinerary?.segments[0].destination?.airport?.cityName ?? "")"
        lblTotalPaid.text = "₹\(flightDetail?.payment_data?.total_amount ?? "")"
        self.imgVwFlight.image = UIImage.init(named: flightDetail?.flight_details?.flightItinerary?.airlineCode ?? "")
        lblEndDateTime.text = flightDetail?.flight_details?.flightItinerary?.segments.first?.destination?.arrTime?.convertDate() ?? ""
        lblStartDateTime.text = flightDetail?.flight_details?.flightItinerary?.segments.first?.origin?.depTime?.convertDate() ?? ""
        lblSource.text = flightDetail?.flight_details?.flightItinerary?.segments[0].origin?.airport?.cityName ?? ""
        lblDestination.text = flightDetail?.flight_details?.flightItinerary?.segments[0].destination?.airport?.cityName ?? ""
        lblDuration.text = flightDetail?.flight_details?.flightItinerary?.segments[0].duration?.getDuration()
        
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 20, width: 200, height: 30)
        let attributedString = NSMutableAttributedString.init(string: AlertMessages.CANCELLATION_POLICY)
        
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 2, range:
                                        NSRange.init(location: 0, length: attributedString.length));
        btnCancellationPolicy.setAttributedTitle(attributedString, for: .normal)
        
        tblVwTraveller.reloadData()
    }
    //MARK: - @IBActions
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
    @IBAction func actionReissueTicket(_ sender: Any) {
    }
    @IBAction func actionCancellationPolicy(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .MoreInfoVC, StoryboardName: .Hotels) as? MoreInfoVC {
            vc.moreInfoText = (flightDetail?.flight_details?.flightItinerary?.fareRules[0].fareRuleDetail ?? "").html2String
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
    }
    @IBAction func actionInvoice(_ sender: UIButton) {
        if sender.tag == 0 {
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
                    let param = ["type": "1",
                                 "email": "\(self.flightDetail?.flight_details?.flightItinerary?.passenger[0].email2 ?? "")",
                                 "pnr": "\(self.flightDetail?.flight_details?.flightItinerary?.pNR ?? "")"]
                    self.viewModel.callCancelFlightTicket(param, view: self)
                }
                self.present(vc, animated: true)
            }
        } else {
            if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
                vc.bookingId = "\(self.flightDetail?.id ?? 0)"
                vc.type = 1
                self.pushView(vc: vc,title: AlertMessages.INVOICE)
            }
        }
    }
}

extension FlightTripDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flightDetail?.flight_details?.flightItinerary?.passenger.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripDetailPassengerTVC") as! TripDetailPassengerTVC
        if tableView == tblVwTraveller {
            cell.lblName.text = flightDetail?.flight_details?.flightItinerary?.passenger[indexPath.row].name
            cell.lblAge.text = flightDetail?.flight_details?.flightItinerary?.passenger[indexPath.row].age
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        45
    }
    func onSuccess() {
        self.popView()
    }
}
