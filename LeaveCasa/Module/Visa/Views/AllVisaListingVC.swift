//
//  AllVisaListingVC.swift
//  LeaveCasa
//
//  Created by acme on 05/07/24.
//

import UIKit
import SDWebImage

class AllVisaListingVC: UIViewController, ResponseProtocol {
    //MARK: - @IBOutlets
    @IBOutlet weak var cnstHeightCollVw: NSLayoutConstraint!
    @IBOutlet weak var collVwList: UICollectionView!
    @IBOutlet weak var txtFldSearchCountry: UITextField!
    //MARK: - Variables
    var viewModel = AllVisaListingVM()
    var arrFilteredVisa: [VisaDetailModel]?
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        viewModel.delegate = self
        viewModel.getNewVisaList(view: self)
        self.collVwList.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new,context: nil)
        collVwList.reloadData()
    }
    //MARK: Add Observer For Tableview Height
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newValue = change?[.newKey]{
                let newSize = newValue as! CGSize
                self.cnstHeightCollVw.constant = newSize.height
            }
        }
    }
    //MARK: - @IBActions
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
    //MARK: - Delegate Methods
    func onSuccess() {
        if arrFilteredVisa == nil {
            arrFilteredVisa = []
        }
        for i in viewModel.arrVisa ?? [] {
            if let filteredVisa = arrFilteredVisa, filteredVisa.contains(where: { $0.country == i.country }) {
            } else {
                arrFilteredVisa?.append(i)
            }
        }
     
        
        let arr1 = arrFilteredVisa?.filter({$0.currency == "INR"})
        let arr2 = arrFilteredVisa?.filter({$0.currency != "INR"})
        arrFilteredVisa = arr1
        arrFilteredVisa?.append(contentsOf: arr2 ?? [])
        collVwList.reloadData()
    }
}

extension AllVisaListingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrFilteredVisa?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllVisaCVC", for: indexPath) as! AllVisaCVC
        cell.lblDescrp.text = "\(arrFilteredVisa?[indexPath.row].currency ?? "") \(arrFilteredVisa?[indexPath.row].landingFees ?? "")/Per Pax"
        cell.lblVisaCountry.text = arrFilteredVisa?[indexPath.row].country
        cell.imgVwDestination.sd_setImage(with: URL(string: arrFilteredVisa?[indexPath.row].images ?? ""), placeholderImage: UIImage(named: "ic_visa_new"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collVwList.frame.size.width/2, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = ViewControllerHelper.getViewController(ofType: .SelectVisaVC, StoryboardName: .Visa) as? SelectVisaVC {
            vc.arrVisa = viewModel.arrVisa
            vc.visaDetail = arrFilteredVisa?[indexPath.row]
            vc.terms = viewModel.termsData
            self.pushView(vc: vc)
        }
    }
}
