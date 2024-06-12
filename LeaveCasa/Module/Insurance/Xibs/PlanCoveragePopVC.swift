//
//  PlanCoveragePopVC.swift
//  LeaveCasa
//
//  Created by acme on 08/05/24.
//

import UIKit

class PlanCoveragePopVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet var lblOptions: [UILabel]!
    @IBOutlet var btnOptions: [UIButton]!
    @IBOutlet var vwOptions: [UIView]!
    @IBOutlet weak var tblVwCoverage: UITableView!
    //MARK: - Variables
    var arrPlans: [CoverageDetail]?
    var selectedTab = Int()
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        actionOptions(btnOptions[0])
    }
    
    @IBAction func actionOptions(_ sender: UIButton) {
        selectedTab = sender.tag
        for btn in btnOptions {
            if btn.tag == sender.tag {
                vwOptions[btn.tag].backgroundColor = .lightBlue()
                lblOptions[btn.tag].textColor = .white
            } else {
                vwOptions[btn.tag].backgroundColor = .systemGray5
                lblOptions[btn.tag].textColor = .darkGray
            }
        }
        tblVwCoverage.reloadData()
    }
    
    @IBAction func actionCross(_ sender: Any) {
        dismiss()
    }
}

extension PlanCoveragePopVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrPlans?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreInfoListTVC") as! MoreInfoListTVC
        cell.lblList.text = selectedTab == 0 ? arrPlans?[indexPath.row].coverage : arrPlans?[indexPath.row].excess == "" ? "-" : arrPlans?[indexPath.row].excess
        cell.lblPrice.text = selectedTab == 0 ? "\(arrPlans?[indexPath.row].sumInsured ?? "0")" : ""
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
