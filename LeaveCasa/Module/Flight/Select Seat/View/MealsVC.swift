//
//  MealsVC.swift
//  LeaveCasa
//
//  Created by acme on 22/02/24.
//

import UIKit

class MealsVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblSouurceDst: UILabel!
    @IBOutlet weak var tblVwMeals: UITableView!
    //MARK: - Variable
    var selectedSection = [Int]()
    var stopNumber = 0
    var mealData = [[MealDynamic]]()
    var mealDataNonLCC = [Meal]()
    var ssrModel : SsrFlightModel?
    var numberOfSeat = 0
    var selectedMeal = 0
    var arrSelectedMeal = [[String:Any]]()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSouurceDst.text = "\(ssrModel?.fare_rule?.response?.fareRules?[stopNumber].origin ?? "") - \(ssrModel?.fare_rule?.response?.fareRules?[stopNumber].destination ?? "")"
        if self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
            if self.ssrModel?.ssr?.response?.mealDynamic?.first?.count ?? 0 == 0 {
                Alert.showSimple("No meal is included in this flight")
            }
        }else{
            if self.ssrModel?.ssr?.response?.meal?.count ?? 0 == 0{
                Alert.showSimple("No meal is included in this flight")
            }
        }
        
        //        if self.mealDaynamic.count == 0 && self.mealDataNonLCC.count == 0{
        //            self.mealView.isHidden = true
        //        }else{
        //            self.mealView.isHidden = false
        //        }
    }
}

extension MealsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
            return self.mealData.first?.count ?? 0
        }else{
            return self.mealDataNonLCC.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BaggageTVC") as! BaggageTVC
        if self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
            cell.lblPriceWeight.text = "\(mealData.first?[indexPath.row].airlineDescription?.count ?? 0 == 0  ? "No Meal" : mealData.first?[indexPath.row].airlineDescription ?? "")"
            cell.lblPrice.text = "\(mealData.first?[indexPath.row].airlineDescription?.count ?? 0 == 0  ? "" : "₹\(mealData.first?[indexPath.row].price ?? 0)")"
            cell.btnDec.tag = indexPath.row
            cell.btnInc.tag = indexPath.row
            cell.btnDec.addTarget(self, action: #selector(actionDecrease(_ :)), for: .touchUpInside)
            cell.btnInc.addTarget(self, action: #selector(actionIncrease(_ :)), for: .touchUpInside)
            cell.vwOuter.borderColor = selectedSection.contains(indexPath.row) ? .lightBlue() : .clear
        }else{
            cell.lblPriceWeight.text = mealDataNonLCC[indexPath.row].description ?? ""
            cell.lblPrice.text = ""
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if mealData.first?[indexPath.row].airlineDescription?.count ?? 0 == 0 {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    @objc func actionIncrease(_ sender: UIButton){
        if selectedMeal < numberOfSeat {
            selectedMeal = selectedMeal + 1
            let cell = tblVwMeals.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BaggageTVC
            cell.vwOuter.borderColor = .lightBlue()
            cell.lblQuatity.text = "\(Int(cell.lblQuatity.text ?? "0")! + 1)"
            
            if !selectedSection.contains(sender.tag) {
                selectedSection.append(sender.tag)
            }
        } else {
            LoaderClass.shared.showSnackBar(message: "Maximum \(selectedMeal) meal can be selected")
        }
    }
    
    @objc func actionDecrease(_ sender: UIButton){
        let cell = tblVwMeals.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BaggageTVC
        if Int(cell.lblQuatity.text ?? "0")! > 0 && selectedMeal > 0 {
            selectedMeal = selectedMeal - 1
            let cell = tblVwMeals.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BaggageTVC
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
