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
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var tblVwHeight: NSLayoutConstraint!
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
    var price = Double()
    var termsText = String()
    //MARK: - Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is UITableView {
            if let newValue = change?[.newKey]{
                let newSize = newValue as! CGSize
                self.tblVwHeight.constant = newSize.height
            }
        }
    }
    
    //MARK: - @IBActions
    @IBAction func actionTermsCondition(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .VisaTermsConditionPopVC, StoryboardName: .Main) as? VisaTermsConditionPopVC {
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.termsCondText = termsText
            self.present(vc, animated: true)
        }
    }
    @IBAction func actionNext(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .UploadDocumentsVC, StoryboardName: .Visa) as? UploadDocumentsVC {
            vc.param = param
            vc.amount = price
            vc.visaDetails = visaDetails
            vc.termsText = termsText
            self.pushView(vc: vc)
        }
    }
    
    @IBAction func actionOptions(_ sender: UIButton) {
        selectedTab = sender.tag
        for btn in btnOptions {
            if btn.tag == sender.tag {
                vwDocumentTC[btn.tag].backgroundColor = UIColor(named: "LIGHT_BLUE_2")
            } else {
                vwDocumentTC[btn.tag].backgroundColor = .clear
            }
        }
        tblVwDocumentsTC.reloadData()
    }
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
    //MARK: - Custom methods
    func setData() {
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 20, width: 200, height: 30)
        let attributedString = NSMutableAttributedString.init(string: "Terms & Conditions")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 2, range:
                                        NSRange.init(location: 0, length: attributedString.length))
        lblTerms.attributedText = attributedString
        
        self.tblVwDocumentsTC.ragisterNib(nibName: "HotelfacilityXIB")
        for i in visaDetails?.documents ?? [] {
            if !arrDocuments.contains(i.name!) {
                arrDocuments.append(i.name!)
            }
        }
        self.imgVwCountry.sd_setImage(with: URL(string: visaDetails?.images ?? ""), placeholderImage: .hotelplaceHolder())
        lblCountryName.text = visaDetails?.country
        lblDescription.text = "\(visaDetails?.visaType ?? "") | \(param["validity"] as? String ?? "")"
        lblVisaDetails.text = "Stay Period: \(param["stay_period"] as? String ?? "")"
        lblProcessingTime.text = visaDetails?.processingTime ?? ""
        price = Double((Int(visaDetails?.landingFees ?? "0") ?? 0) * (Int(param["pax"] as? String ?? "0") ?? 0))
        lblBottomPrice.text = "\(visaDetails?.currency ?? "") \(price)"
        lblPrice.text = "\(visaDetails?.currency ?? "") \(visaDetails?.landingFees ?? "")"
        self.tblVwDocumentsTC.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

    }
}

extension CountryVisaDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTab == 0 ? arrDocuments.count : visaDetails?.guidelines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HotelfacilityXIB().identifire, for: indexPath) as! HotelfacilityXIB
        cell.lblTitle.text = selectedTab == 0 ? arrDocuments[indexPath.row] : visaDetails?.guidelines?[indexPath.row]
        cell.lblTitle.font = UIFont.regularFont(size: 12)
        cell.imgVwTick.isHidden = false
        cell.dotView.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
