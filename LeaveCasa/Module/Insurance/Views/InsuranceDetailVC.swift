//
//  InsuranceDetailVC.swift
//  LeaveCasa
//
//  Created by acme on 20/05/24.
//

import UIKit

class InsuranceDetailVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var btnCancelInsurance: UIButton!
    @IBOutlet weak var lblAges: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var btnCoverageDetail: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblInsuranceName: UILabel!
    @IBOutlet weak var lblPremiumPrice: UILabel!
    @IBOutlet weak var lblCoverageType: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var lblTotalPax: UILabel!
    @IBOutlet weak var lblPlanType: UILabel!
    @IBOutlet weak var lblInsurnaceID: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    //MARK: - Variables
    var bookingId = Int()
    var status: String?
    var viewModel = InsuranceDetailVM()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 20, width: 200, height: 30)
        let attributedString = NSMutableAttributedString.init(string: "Coverage Details")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 2, range:
                                        NSRange.init(location: 0, length: attributedString.length));
        btnCoverageDetail.setAttributedTitle(attributedString, for: .normal)
        viewModel.delegate = self
    }
    //MARK: - @IBActions
    @IBAction func actionDownloadInvoice(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
            vc.bookingId = "\(viewModel.insuranceDetailModel?.bookingId ?? 0)"
            vc.type = 4
            vc.isDetailScreen = true
            self.pushView(vc: vc,title: AlertMessages.INVOICE)
        }
    }
    @IBAction func actionCancelInsurance(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .CommonPopupVC, StoryboardName: .Main) as? CommonPopupVC {
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.isNoHide = false
            vc.type = "Insurance Cancel"
            vc.titleStr = "Are you sure you want to cancel insurance?"
            vc.msg = AlertMessages.CANCELLATION_ALERT
            vc.noTitle = AlertKeys.NO
            vc.yesTitle = AlertKeys.YES
            vc.tapCallback = {
                let param = [WSRequestParams.WS_REQS_PARAM_BOOKING_ID: self.bookingId,
                             WSRequestParams.WS_REQS_PARAM_REQUEST_TYPE: "3",
                             WSRequestParams.WS_REQS_PARAM_REMARKS: "Test Remarks"] as [String : Any]
                LoaderClass.shared.loadAnimation()
                self.viewModel.cancelInsurance(param: param, view: self)
            }
            self.present(vc, animated: true)
        }
       
    }
    @IBAction func actionCoverageDetails(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .PlanCoveragePopVC, StoryboardName: .Main) as? PlanCoveragePopVC {
            vc.arrPlans = viewModel.insuranceDetailModel?.coverageDetails
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
 
    func setData() {
        var ages = [Int]()
        let data = viewModel.insuranceDetailModel
        lblInsurnaceID.text = "\(data?.bookingId ?? 0)"
        lblPlanType.text = data?.planType == 1 ? "Domestic" : "Annual Multi Trip"
        for i in data?.paxInfo ?? [] {
            let age =  LoaderClass.shared.calculateAge(from: i.dob ?? "") ?? 0
            ages.append(age)
        }
        lblAges.text = ages.map{String($0)}.joined(separator: ", ")
        let duration = LoaderClass.shared.calculateDaysBetweenDates(dateString1: data?.policyStartDate ?? "", dateString2: data?.policyEndDate ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss")
        lblDuration.text = data?.planType == 2 ? "1 year" : "\(duration ?? 1) \((duration == 1 ? "day" : "days"))"
        lblStartDate.text = convertDateFormat(date: data?.policyStartDate ?? "", getFormat: "dd-MMM-yyyy", dateFormat: "yyyy-MM-dd'T'HH:mm:ss")
        lblTotalPax.text = "\(data?.paxInfo?.count ?? 1)"
        lblDestination.text = data?.paxInfo?[0].majorDestination
        lblCoverageType.text = data?.planCoverage == 1 ? "USA" : data?.planCoverage == 2 ? "Non-US" : data?.planCoverage == 3 ? "Worldwide" : data?.planCoverage == 4 ? "India" : data?.planCoverage == 5 ? "Asia" : data?.planCoverage == 6 ? "Canada" : data?.planCoverage == 7 ? "Aus" : "SchengenCountries"
        let conFee = data?.planCoverage == 4 ? 59 : 118
        lblPremiumPrice.text = "₹\(((data?.paxInfo?[0].price?.publishedPrice ?? 0)+conFee)*(data?.paxInfo?.count ?? 1))"
        btnCancelInsurance.isHidden = self.status == "Cancelled" || self.status == "Completed"
    }
}

extension InsuranceDetailVC: ResponseProtocol{
    func onSuccess() {
        popView()
    }
}
