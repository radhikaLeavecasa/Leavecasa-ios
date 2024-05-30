//
//  InsuranceListVC.swift
//  LeaveCasa
//
//  Created by acme on 07/05/24.
//

import UIKit

class InsuranceListVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var tblVwInsurance: UITableView!
    //MARK: - Variables
    var arrInsuranceList = [InsuranceResults]()
    var paxCount = Int()
    var traceId = String()
    var isDomesticType = false
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
}

extension InsuranceListVC: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrInsuranceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InsuranceTVC") as! InsuranceTVC
        cell.btnPlanCoverage.tag = indexPath.row
        cell.btnSelect.tag = indexPath.row
        cell.lblTax.text = "(+ ₹\(isDomesticType ? "50" : "100") Convenience fee + 18% GST)"
        cell.btnPlanCoverage.addTarget(self, action: #selector(actionPlanCoverage), for: .touchUpInside)
        cell.btnSelect.addTarget(self, action: #selector(btnSelect), for: .touchUpInside)
        cell.lblDescp.text = arrInsuranceList[indexPath.row].planDescription
        cell.lblPrice.text = isDomesticType ? "₹\((arrInsuranceList[indexPath.row].price?.publishedPrice ?? 0)+59)" : "₹\(arrInsuranceList[indexPath.row].price?.publishedPrice ?? 0)"
        cell.lblTitle.text = arrInsuranceList[indexPath.row].planName
        cell.lblPerPerson.text = "/\(paxCount) pax"
        return cell
    }
    
    @objc func actionPlanCoverage(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .PlanCoveragePopVC, StoryboardName: .Main) as? PlanCoveragePopVC {
            vc.arrPlans = arrInsuranceList[sender.tag].coverageDetails
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
    }
    
    @objc func btnSelect(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .FillInsuranceDetailsVC, StoryboardName: .Main) as? FillInsuranceDetailsVC {
            vc.resultIndex = "\(arrInsuranceList[sender.tag].resultIndex)"
            vc.traceId = traceId
            vc.noOfPax = paxCount
            vc.isDomesticType = isDomesticType
            vc.insuranceAmt = isDomesticType ? Double(paxCount*((arrInsuranceList[sender.tag].price?.publishedPrice ?? 0)+59)) : Double(paxCount*(arrInsuranceList[sender.tag].price?.publishedPrice ?? 0))
            self.pushView(vc: vc)
        }
    }
}
