//
//  BusTripDetailVC.swift
//  LeaveCasa
//
//  Created by acme on 19/09/23.
//

import UIKit
import IBAnimatable

class BusTripDetailVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var cnstTblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var lblPaymentMode: UILabel!
    @IBOutlet weak var lblTransactionID: UILabel!
    @IBOutlet weak var lblSeatNumber: UILabel!
    @IBOutlet weak var lblPnrNumber: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDeparture: UILabel!
    @IBOutlet weak var lblAccountDetail: UILabel!
    @IBOutlet weak var btnInvoice: AnimatableButton!
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblBusNumber: UILabel!
    @IBOutlet weak var lblFarePrice: UILabel!
    @IBOutlet weak var btnCancellationPolicy: AnimatableButton!
    @IBOutlet weak var vwCancelTicket: UIView!
    //MARK: - Variables
    var busDetail: TripBus?
    typealias completion = (_ tag: Int) -> Void
    var doneCompletion: completion? = nil
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentDate = convertDate(Date())
        vwCancelTicket.isHidden = busDetail?.booking_status == Strings.CONFIRMED && busDetail?.journey_date ?? "" > currentDate
        cnstTblVwHeight.constant = CGFloat(busDetail?.bus_details?.arrInventoryItems?.count == 0 ? 35 : (busDetail?.bus_details?.arrInventoryItems?.count ?? 1)*35)
        lblFarePrice.text = "₹\(busDetail?.bus_details?.inventoryItems?.fare ?? "")"
        lblTransactionID.text = busDetail?.bus_details?.inventoryId
        lblPnrNumber.text = busDetail?.bus_details?.pnr
        lblDeparture.text = convertDateFormat(date: busDetail?.journey_date ?? "", getFormat: DateFormat.dayDateMonth, dateFormat: DateFormat.fullDateTime)
        lblTime.text = getTimeString(time: busDetail?.bus_details?.pickupTime ?? "")
        lblTo.text = busDetail?.bus_details?.destinationCity
        lblFrom.text = busDetail?.bus_details?.sourceCity
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 20, width: 200, height: 30)
        let attributedString = NSMutableAttributedString.init(string: AlertMessages.CANCELLATION_POLICY)
        
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 2, range:
                                        NSRange.init(location: 0, length: attributedString.length));
        btnCancellationPolicy.setAttributedTitle(attributedString, for: .normal)
    }
    
    @IBAction func actionCancelInvoice(_ sender: UIButton) {
        self.dismiss(animated: true) {
            guard let doneButton = self.doneCompletion else { return }
            doneButton(sender.tag)
        }
    }
    @IBAction func actionCancellationPolicy(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .BusCancellationPolicyVC, StoryboardName: .Bus) as? BusCancellationPolicyVC {
            vc.busDetail = busDetail
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
}

extension BusTripDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busDetail?.bus_details?.arrInventoryItems?.count == nil ? 1 : busDetail?.bus_details?.arrInventoryItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripDetailPassengerTVC") as! TripDetailPassengerTVC
        if busDetail?.bus_details?.arrInventoryItems?.count != nil {
            cell.lblAge.text = busDetail?.bus_details?.arrInventoryItems?[indexPath.row].passenger?.age
            cell.lblName.text = busDetail?.bus_details?.arrInventoryItems?[indexPath.row].passenger?.name
        } else {
            cell.lblAge.text = busDetail?.bus_details?.inventoryItems?.passenger?.age
            cell.lblName.text = busDetail?.bus_details?.inventoryItems?.passenger?.name
        }
        return cell
    }
}
