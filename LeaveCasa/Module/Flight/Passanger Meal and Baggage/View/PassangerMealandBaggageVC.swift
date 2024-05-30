//
//  PassangerMealandBaggageVC.swift
//  LeaveCasa
//
//  Created by acme on 20/12/22.
//

import UIKit
import IBAnimatable
import DropDown

protocol BaggageAndMealDetails{
    func baggageAndMealDetails(index:Int,mealCode:String,mealDesecription:String,baggageCode:String,baggageDescription:String,baggage:Any,meal:Any,mealPrice: Double,baggagePrice: Double)
}

class PassangerMealandBaggageVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblMealPrice: UILabel!
    @IBOutlet weak var lblMealQty: UILabel!
    @IBOutlet weak var txtMeal: UITextField!
    
    @IBOutlet weak var lblTxtBaggage: UILabel!
    @IBOutlet weak var lblBaggagePrice: UILabel!
    @IBOutlet weak var lblBaggageWeight: UILabel!
    @IBOutlet weak var txtBaggage: UITextField!
    
    @IBOutlet weak var lblTxtMeal: UILabel!
    @IBOutlet weak var lblDestinationAndSource: UILabel!
    @IBOutlet weak var mealView: AnimatableView!
    @IBOutlet weak var baggageView: AnimatableView!
    //MARK: - Variables
    let dropDown = DropDown()
    var baggageDetails = [[Baggage]]()
    var baggageDetailsNonLCC = [BaggageNonLCC]()
    var mealData = [[MealDynamic]]()
    var mealDataNonLCC = [Meal]()
    var mealDaynamic = [String]()
    var baggageDayamic = [String]()
    var selectedIndex :Int?
    var delegate : BaggageAndMealDetails?
    var mealCode = String()
    var mealDescription = String()
    var baggageCode = String()
    var baggageDescription = String()
    var meal : MealDynamic?
    var mealNonLCC : Meal?
    var baggage : Baggage?
    var nonLCCBaggage : BaggageNonLCC?
    var ssrData : SsrFlightModel?
    var mealPrice = Double()
    var baggagePrice = Double()
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblDestinationAndSource.text = "\(self.ssrData?.fare_rule?.response?.fareRules?[0].origin ?? "") - \(self.ssrData?.fare_rule?.response?.fareRules?[0].destination ?? "")"
//        self.txtMeal.delegate = self
//        self.txtBaggage.delegate = self
//        txtMeal.sizeToFit()
//        txtBaggage.sizeToFit()
        if self.ssrData?.fare_quote?.response?.fareQuoteResult?.isLCC == true{
            lblTxtMeal.text = "\(self.meal?.airlineDescription?.count ?? 0 == 0  ? "No Meal" : self.meal?.airlineDescription ?? "") - Rs \(self.meal?.price ?? 0)"
            //self.txtMeal.text = "\(self.meal?.airlineDescription?.count ?? 0 == 0  ? "No Meal" : self.meal?.airlineDescription ?? "") - Rs \(self.meal?.price ?? 0)"
            self.lblMealQty.text =  "\(self.meal?.quantity ?? 0)"
            self.lblMealPrice.text =  "₹\(self.meal?.price ?? 0)"
            self.mealPrice += Double(self.meal?.price ?? 0)
            
            lblTxtBaggage.text = "\(self.baggage?.weight ?? 0) KG - ₹\(self.baggage?.price ?? 0)"
          //  self.txtBaggage.text = "\(self.baggage?.weight ?? 0) KG - Rs \(self.baggage?.price ?? 0)"
            self.lblBaggageWeight.text =  "\(self.baggage?.weight ?? 0) KG"
            self.lblBaggagePrice.text =  "₹\(self.baggage?.price ?? 0)"
            self.baggagePrice += Double(self.baggage?.price ?? 0)
        }else{
            lblTxtMeal.text = "\(self.mealNonLCC?.description ?? "No Meal")"
            //self.txtMeal.text = "\(self.mealNonLCC?.description ?? "No Meal")"
            self.lblMealQty.text =  self.mealNonLCC?.description?.count ?? 0 > 0 ? "1":"0"
            self.lblMealPrice.text =  "₹0"
            self.mealPrice += 0.0
            lblTxtBaggage.text = "\(self.nonLCCBaggage?.description ?? "")"
           // self.txtBaggage.text = "\(self.nonLCCBaggage?.description ?? "")"
            self.lblBaggageWeight.text =  "₹KG"
            self.lblBaggagePrice.text =  "₹0"
            self.baggagePrice += 0.0
        }
        
        self.mealDaynamic.removeAll()
        
        DispatchQueue.main.async {
            if self.ssrData?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
                for index in self.mealData.first ?? []{
                    let meal = "\(index.airlineDescription?.count ?? 0 == 0  ? "No Meal" : index.airlineDescription ?? "") - Rs \(index.price ?? 0)"
                    self.mealDaynamic.append(meal)
                }
            }else{
                for index in self.mealDataNonLCC{
                    let meal = index.description ?? ""
                    self.mealDaynamic.append(meal)
                }
            }
            
            if self.ssrData?.fare_quote?.response?.fareQuoteResult?.isLCC == true{
                for index in self.baggageDetails.first ?? []{
                    let meal = "\(index.weight ?? 0) KG - ₹\(index.price ?? 0)"
                    self.baggageDayamic.append(meal)
                }
            }else{
                for index in self.baggageDetailsNonLCC{
                    let meal = index.description
                    self.baggageDayamic.append(meal ?? "")
                }
            }
        }
        
        DispatchQueue.main.async {
            if self.mealDaynamic.count == 0 && self.mealDataNonLCC.count == 0{
                self.mealView.isHidden = true
            }else{
                self.mealView.isHidden = false
            }
            
            if self.baggageDayamic.count == 0 && self.baggageDetailsNonLCC.count == 0{
                self.baggageView.isHidden = true
            }else{
                self.baggageView.isHidden = false
            }
        }
    }
    //MARK: - @IBActions
    @IBAction func doneOnPress(_ sender: UIButton) {
        self.dismiss()
        if let del = self.delegate {
            let meal = self.meal
            let baggage = self.baggage
            del.baggageAndMealDetails(index: self.selectedIndex ?? 0, mealCode: self.mealCode, mealDesecription: self.mealDescription, baggageCode: self.baggageCode, baggageDescription: self.baggageDescription,baggage: self.ssrData?.fare_quote?.response?.fareQuoteResult?.isLCC == true ? baggage as Any : self.nonLCCBaggage as Any ,meal: self.ssrData?.fare_quote?.response?.fareQuoteResult?.isLCC == true ? meal as Any : self.mealNonLCC as Any,mealPrice: mealPrice,baggagePrice: baggagePrice)
        }
    }
    
    @IBAction func clossOnPress(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let del = self.delegate {
                let meal = self.meal
                let baggage = self.baggage
                del.baggageAndMealDetails(index: self.selectedIndex ?? 0, mealCode: self.mealCode, mealDesecription: self.mealDescription, baggageCode: self.baggageCode, baggageDescription: self.baggageDescription,baggage: self.ssrData?.fare_quote?.response?.fareQuoteResult?.isLCC == true ? baggage as Any : self.nonLCCBaggage as Any ,meal: self.ssrData?.fare_quote?.response?.fareQuoteResult?.isLCC == true ? meal as Any : self.mealNonLCC as Any,mealPrice: self.mealPrice,baggagePrice: self.baggagePrice)
            }
        }
    }
    //MARK: - Custom methods
    func showShortDropDown(textFeild:UITextField? = nil,data:[String]){
        let dropDown = DropDown()
        textFeild?.resignFirstResponder()
        
        dropDown.anchorView = textFeild?.plainView
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.cellHeight = 55
        dropDown.dataSource = data
        dropDown.show()
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if textFeild == self.txtMeal{
                lblTxtMeal.text = item
                //self.txtMeal.text = item
                self.lblMealQty.text =  "\(self.mealData.first?[index].quantity ?? 0)"
                self.lblMealPrice.text =  "₹\(self.mealData.first?[index].price ?? 0)"
                self.mealPrice += Double(self.mealData.first?[index].price ?? 0)
                self.mealCode = self.mealData.first?[index].code ?? ""
                self.mealDescription = self.mealData.first?[index].airlineDescription ?? ""
                if self.ssrData?.fare_quote?.response?.fareQuoteResult?.isLCC == true{
                    self.meal = self.mealData.first?[index]
                }else{
                    self.mealNonLCC = self.mealDataNonLCC[index]
                }
                
            }else if textFeild == self.txtBaggage{
                lblTxtBaggage.text = item
                //self.txtBaggage.text = item
                self.lblBaggageWeight.text =  "\(self.baggageDetails.first?[index].weight ?? 0) KG"
                self.lblBaggagePrice.text =  "₹\(self.baggageDetails.first?[index].price ?? 0)"
                self.baggagePrice += Double(self.baggageDetails.first?[index].price ?? 0)

                self.baggageCode = self.baggageDetails.first?[index].code ?? ""
                self.baggageDescription = "\(self.baggageDetails.first?[index].description ?? 0)"
                if self.ssrData?.fare_quote?.response?.fareQuoteResult?.isLCC == true{
                    self.baggage = self.baggageDetails.first?[index]
                }else{
                    self.nonLCCBaggage = self.baggageDetailsNonLCC[index]
                }
            }
        }
    }
    
}

extension PassangerMealandBaggageVC:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtMeal{
            self.showShortDropDown(textFeild: textField, data: self.mealDaynamic)
        } else if textField == self.txtBaggage {
            self.showShortDropDown(textFeild: textField, data: self.baggageDayamic)
        }
    }
}
