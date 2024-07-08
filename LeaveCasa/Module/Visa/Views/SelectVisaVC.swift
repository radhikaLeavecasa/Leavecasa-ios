//
//  SelectVisaVC.swift
//  LeaveCasa
//
//  Created by acme on 08/07/24.
//

import UIKit

class SelectVisaVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var collVwVIsaType: UICollectionView!
    @IBOutlet weak var collVwProcess: UICollectionView!
    
    //MARK: - Variables
    var terms: String?
    var arrTitle = ["1. Verify Documents", "2. Complete Payment", "3. Download Approved Visa"]
    var arrDescription = ["Upload your scanned documents for verification.","Pay for your application securely online.", "Access and download your approved visa."]
    var arrImg = ["ic_process1","ic_process2","ic_process3"]
    var arrVisa: [VisaDetailModel]?
    var visaDetail: VisaDetailModel?
    var arrFilterdArr: [VisaDetailModel]? = []
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
       
        for i in arrVisa ?? [] {
            if i.country == visaDetail?.country {
                arrFilterdArr?.append(i)
            }
        }
        collVwVIsaType.reloadData()
    }
    //MARK: - @IBActions
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
}

extension SelectVisaVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == collVwProcess ? arrTitle.count : arrFilterdArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwProcess {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllVisaCVC", for: indexPath) as! AllVisaCVC
            cell.lblVisaCountry.text = arrTitle[indexPath.row]
            cell.lblDescrp.text = arrDescription[indexPath.row]
            cell.imgVwDestination.image = UIImage(named: arrImg[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VisaTypeCVC", for: indexPath) as! VisaTypeCVC
            cell.lblCountry.text = "\(arrFilterdArr?[indexPath.row].country ?? "") \(arrFilterdArr?[indexPath.row].visaType ?? "")"
            cell.imgVwVisaCountry.sd_setImage(with: URL(string: arrFilterdArr?[indexPath.row].images ?? ""), placeholderImage: UIImage(named: "ic_visa_new"))
            cell.lblProcessTime.text = arrFilterdArr?[indexPath.row].processingTime
            cell.lblStayPeriod.text = arrFilterdArr?[indexPath.row].stayPeriod?[0]
            cell.lblVisaValidity.text = arrFilterdArr?[indexPath.row].validity?[0]
            cell.lblPrice.text = "\(arrFilterdArr?[indexPath.row].currency ?? "") \(arrFilterdArr?[indexPath.row].landingFees ?? "")/Per Pax"
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwProcess {
            return CGSize(width: CGFloat(Int(collVwProcess.frame.size.width))/3, height: collVwProcess.frame.size.height)
        } else {
            return CGSize(width: CGFloat(Int(collVwVIsaType.frame.size.width))/1.2, height: collVwVIsaType.frame.size.height)

        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collVwVIsaType {
            if let vc = ViewControllerHelper.getViewController(ofType: .PaxPopUpVC, StoryboardName: .Visa) as? PaxPopUpVC {
                vc.doneCompletion = {
                    val in
                    let param = ["visa_id": self.arrFilterdArr?[indexPath.row].id ?? 0,
                                 "validity": self.arrFilterdArr?[indexPath.row].validity?[0] ?? "",
                                 "stay_period": self.arrFilterdArr?[indexPath.row].stayPeriod?[0] ?? "",
                                 "pax": val,
                                 "user_id": UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false ? "\(Cookies.userInfo()?.id ?? 0)" : ""] as [String : Any]
                    
                    if let vc = ViewControllerHelper.getViewController(ofType: .CountryVisaDetailVC, StoryboardName: .Visa) as? CountryVisaDetailVC {
                        vc.param = param
                        vc.termsText = self.terms ?? ""
                        vc.visaDetails = self.arrFilterdArr?[indexPath.row]
                        self.pushView(vc: vc)
                    }
                }
                self.present(vc, animated: true)
            }
            
        }
    }
}
