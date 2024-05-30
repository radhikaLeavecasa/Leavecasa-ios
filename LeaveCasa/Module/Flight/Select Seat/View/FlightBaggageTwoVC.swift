
//  FlightBaggageVC.swift
//  LeaveCasa
//
//  Created by acme on 21/02/24.


import UIKit

class FlightBaggageTwoVC: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var lblOriginSource: UILabel!
    @IBOutlet weak var tblVwBaggages: UITableView!
    //MARK: - Variables
    var baggageDetails = [[Baggage]]()
    var baggageDetailsNonLCC = [BaggageNonLCC]()
    var ssrModel : SsrFlightModel?
    var stopNumber = 0
    var delegate : BaggageAndMealDetails?
    var mealCode = String()
    var mealDescription = String()
    var baggageCode = String()
    var baggageDescription = String()
    var numberOfSeat = 0
    var selectedBaggage = 0
    var selectedSection = [Int]()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblOriginSource.text = "\(ssrModel?.fare_rule?.response?.fareRules?[stopNumber].origin ?? "") - \(ssrModel?.fare_rule?.response?.fareRules?[stopNumber].destination ?? "")"
        if self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
            if self.ssrModel?.ssr?.response?.baggage?.first?.count ?? 0 == 0 {
                Alert.showSimple("No Baggage is included in this flight")
            }
        }else{
            if self.ssrModel?.ssr?.response?.baggage?.first?.count ?? 0 == 0{
                Alert.showSimple("No Baggage is included in this flight")
            }
        }
    }
}

extension FlightBaggageTwoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true{
            return self.baggageDetails.first?.count ?? 0
        }else{
            return self.baggageDetailsNonLCC.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BaggageTVC") as! BaggageTVC
        
        cell.lblPriceWeight.text = self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true ? "\(baggageDetails.first?[indexPath.row].weight ?? 0)kg" : "\(baggageDetailsNonLCC[indexPath.row].description ?? "No Meal")"
        cell.lblPrice.text = self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true ? "₹\(baggageDetails.first?[indexPath.row].price ?? 0)" : ""
        cell.btnDec.tag = indexPath.row
        cell.btnInc.tag = indexPath.row
        cell.btnDec.addTarget(self, action: #selector(actionDecrease(_ :)), for: .touchUpInside)
        cell.btnInc.addTarget(self, action: #selector(actionIncrease(_ :)), for: .touchUpInside)
        cell.vwOuter.borderColor = selectedSection.contains(indexPath.row) ? .lightBlue() : .clear
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    @objc func actionIncrease(_ sender: UIButton){
        if selectedBaggage < numberOfSeat {
            selectedBaggage = selectedBaggage + 1
            let cell = tblVwBaggages.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BaggageTVC
            cell.lblQuatity.text = "\(Int(cell.lblQuatity.text ?? "0")! + 1)"
            if !selectedSection.contains(sender.tag) {
                selectedSection.append(sender.tag)
            }
        } else {
            LoaderClass.shared.showSnackBar(message: "Maximum \(selectedBaggage) meal can be selected")
        }
    }
    
    @objc func actionDecrease(_ sender: UIButton){
        if selectedBaggage > 0 {
            selectedBaggage = selectedBaggage - 1
            let cell = tblVwBaggages.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BaggageTVC
            cell.lblQuatity.text = "\(Int(cell.lblQuatity.text ?? "0")! - 1)"
            if selectedSection.contains(sender.tag) {
                if cell.lblQuatity.text == "0" {
                    cell.vwOuter.borderColor = .clear
                    selectedSection = selectedSection.filter{$0 != sender.tag}
                }
            }
        }
    }
}
