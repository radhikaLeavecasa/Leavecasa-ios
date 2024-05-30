//
//  MoreInfoBottomCVC.swift
//  LeaveCasa
//
//  Created by acme on 29/06/23.
//

import UIKit

class MoreInfoBottomCVC: UICollectionViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var tblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var tblVwList: UITableView!
    @IBOutlet weak var lblNotFound: UILabel!

    //MARK: - Variables
    var arr = ["Room Price", "Discount", "Taxes & Fee", "Total Price"]
    var arrPrice = [String]()
    var index = Int()
    var roomAmenities = [String]()
    var cancellationText = String()
    var isInsurance = false
    var arrCoverage:[CoverageDetail]?
    //MARK: - Custom methods
    func collViewReload(_ arrPrice: [String], index: Int, roomAmenities:[String], cancellationText: String){
        self.arrPrice = arrPrice
        tblVwList.delegate = self
        tblVwList.dataSource = self
        self.cancellationText = cancellationText
        self.roomAmenities = roomAmenities
        self.index = index
        lblNotFound.isHidden = self.roomAmenities.count > 0 && index == 1 || index == 0 || index == 2
        tblVwList.separatorColor = index == 2 ? .clear : .lightGreyColor()
        tblVwList.reloadData()
    }
    
    func collViewInsuranceReload(_ arrCoverage: [CoverageDetail],index:Int){
        isInsurance = true
        self.index = index
        self.arrCoverage = arrCoverage
        tblVwList.delegate = self
        tblVwList.dataSource = self
        tblVwList.reloadData()
        updateTableViewHeight()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTableViewHeight()
    }
    
    func updateTableViewHeight() {
        tblVwHeight.constant = tblVwList.contentSize.height+20
        tblVwList.layoutIfNeeded()
    
    }
}

extension MoreInfoBottomCVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInsurance {
            return arrCoverage?.count ?? 0
        } else {
            return index == 0 ? arrPrice.count : index == 1 ? roomAmenities.count : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreInfoListTVC") as! MoreInfoListTVC
        if isInsurance {
            cell.lblList.text = index == 0 ? arrCoverage?[indexPath.row].coverage : arrCoverage?[indexPath.row].excess == "" ? "-" : arrCoverage?[indexPath.row].excess
            cell.lblPrice.text = index == 0 ? "\(arrCoverage?[indexPath.row].sumInsured ?? "0")" : ""
        } else {
            cell.cnstWidthPrice.constant = index == 0 ? 60 : 0
            cell.lblPrice.text = index == 0 ? arrPrice[indexPath.row] : ""
            cell.lblList.text = index == 0 ? arr[indexPath.row] : index == 1 ? roomAmenities[indexPath.row] : cancellationText
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
