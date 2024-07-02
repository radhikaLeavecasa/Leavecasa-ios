//
//  VisaViewDetailVC.swift
//  LeaveCasa
//
//  Created by acme on 01/07/24.
//

import UIKit

class VisaViewDetailVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var imgVwLoading: UIImageView!
    @IBOutlet weak var lblProcessingTime: UILabel!
    @IBOutlet weak var lblTraceId: UILabel!
    @IBOutlet weak var lblStayPeriod: UILabel!
    @IBOutlet weak var lblValidity: UILabel!
    @IBOutlet weak var lblPaxCountry: UILabel!
    @IBOutlet weak var collVwProfilePics: UICollectionView!
    @IBOutlet weak var lblApplyDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblVisaType: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    //MARK: - Variables
    var visaDetail: VisaApplicationModel?
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        lblPrice.text = "\(visaDetail?.amountInfo?.currency ?? "") \(Int((visaDetail?.amountInfo?.amount ?? 0) + (visaDetail?.amountInfo?.leavecasaPrice ?? 0)))"
        lblCountry.text = visaDetail?.country
        lblVisaType.text = visaDetail?.visaType
        lblPaxCountry.text = "\(visaDetail?.pax ?? 0) pax"
        lblValidity.text = visaDetail?.validity
        lblStayPeriod.text = visaDetail?.stayPeriod
        lblTraceId.text = "\(visaDetail?.traceId ?? 0)"
        lblProcessingTime.text = visaDetail?.processingTime
        lblApplyDate.text = convertDateFormat(date: visaDetail?.createdAt ?? "", getFormat: "dd-MMM-yyyy", dateFormat: "yyyy-MM-dd'T'HH:mm:ss")
    }
    
    //MARK: - @IBActions
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
    
    @IBAction func actionInvoice(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
            vc.bookingId = "\(visaDetail?.traceId ?? 0)"
            vc.type = 5
            self.pushView(vc: vc,title: AlertMessages.INVOICE)
        }
    }
    
}

extension VisaViewDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visaDetail?.stats?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VisaCVC", for: indexPath) as! VisaCVC
        cell.imgVwProfile.sd_setImage(with: URL(string: visaDetail?.stats?[indexPath.row].photograph ?? ""))
        switch visaDetail?.stats?[indexPath.row].status {
        case "in-progress":
            cell.vwInProgress.isHidden = false
            cell.vwApproved.isHidden = true
            cell.vwRejected.isHidden = true
        case "approved":
            cell.vwInProgress.isHidden = true
            cell.vwApproved.isHidden = false
            cell.vwRejected.isHidden = true
        default:
            cell.vwInProgress.isHidden = true
            cell.vwApproved.isHidden = true
            cell.vwRejected.isHidden = false
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collVwProfilePics.frame.size.height, height: collVwProfilePics.frame.size.height)
    }
}
