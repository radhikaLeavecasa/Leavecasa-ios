//
//  CountryVisaDetailVC.swift
//  LeaveCasa
//
//  Created by acme on 25/06/24.
//

import UIKit
import SDWebImage
import IBAnimatable

class CountryVisaDetailVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet var vwDocumentTC: [AnimatableView]!
    @IBOutlet weak var lblBottomPrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblVisaDetails: UILabel!
    @IBOutlet weak var lblPassenegerCount: UILabel!
    @IBOutlet weak var lblProcessingTime: UILabel!
    @IBOutlet weak var imgVwCountry: UIImageView!
    @IBOutlet weak var tblVwDocumentsTC: UITableView!
    @IBOutlet var btnOptions: [UIButton]!
    //MARK: - Variables
    var param = [String: Any]()
    var visaDetails: VisaDetailModel?
    var selectedTab = Int()
    var arrDocuments = [String]()
    //MARK: - Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    @IBAction func actionNext(_ sender: Any) {
        
    }
    @IBAction func actionOptions(_ sender: UIButton) {
        selectedTab = sender.tag
        for btn in btnOptions {
            if btn.tag == sender.tag {
                vwDocumentTC[btn.tag].backgroundColor = .lightBlue()
            } else {
                vwDocumentTC[btn.tag].backgroundColor = .clear
            }
        }
        tblVwDocumentsTC.reloadData()
    }
    func setData() {
        self.tblVwDocumentsTC.ragisterNib(nibName: "HotelfacilityXIB")
        for i in visaDetails?.documents ?? [] {
            if !arrDocuments.contains(i.name!) {
                arrDocuments.append(i.name!)
            }
        }
        self.imgVwCountry.sd_setImage(with: URL(string: visaDetails?.images ?? ""), placeholderImage: .hotelplaceHolder())
        lblCountryName.text = visaDetails?.country
        lblDescription.text = "\(visaDetails?.visaType ?? "") | \(visaDetails?.validity ?? "")"
        lblVisaDetails.text = "Stay Period: \(visaDetails?.stayPeriod ?? "")"
        lblProcessingTime.text = visaDetails?.processingTime ?? ""
        let price = (Int(visaDetails?.landingFees ?? "0") ?? 0) * (Int(param["Passenger"] as? String ?? "0") ?? 0)
        lblBottomPrice.text = "\(visaDetails?.currency ?? "") \(price)"
        lblPrice.text = "\(visaDetails?.currency ?? "") \(visaDetails?.landingFees ?? "")"
    }
}

extension CountryVisaDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTab == 0 ? arrDocuments.count : visaDetails?.guidelines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HotelfacilityXIB().identifire, for: indexPath) as! HotelfacilityXIB
        cell.lblTitle.text = selectedTab == 0 ? arrDocuments[indexPath.row] : visaDetails?.guidelines?[indexPath.row]
        cell.imgVwTick.isHidden = false
        cell.dotView.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
