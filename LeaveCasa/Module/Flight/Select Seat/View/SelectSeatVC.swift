//
//  SelectSeatVC.swift
//  LeaveCasa
//
//  Created by acme on 13/12/22.
//

import UIKit
import AMPopTip
import ObjectMapper

class SelectSeatVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var tblVwSeatHeight: NSLayoutConstraint!
    @IBOutlet weak var tblVwSeats: UITableView!
    @IBOutlet weak var collVwCityCodes: UICollectionView!
    @IBOutlet weak var tblVwMealBaggage: UITableView!
    @IBOutlet weak var collVwHeader: UICollectionView!
    // @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSkip: UIButton!
    //  @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var lblNoMealBaggage: UILabel!
    //MARK: - Variables
    var arr = [SegmentSeat]()
    //var selectedCityCode = 0
    var arrHeader = ["Seats", "Meals", "Baggages"]
    var arrSeatTypes = [String]()
    var seatType = ""
    var ssrModel : SsrFlightModel?
    var seletedSeatIndex = [Seats]()
    var seletedSeats = [String]()
    var seatSelectionPassengers = [[Seats]]()
    var finalSeletedSeatIndex = [Seats]()
    var finalSeletedSeats = [String]()
    
    let popTip = PopTip()
    var logId = 0
    var tokenId = ""
    var traceId = ""
    var param = [String:Any]()
    var viewModel = PassangerDetailsViewModel()
    var dataFlight = Flight()
    var numberOfSeat = 0
    
    var stopNumber = 0
    var seatPrice = Double()
    var discount = Double()
    var basePrice = Double()
    var convenientFee = Double()
    var taxes = Double()
    var mealPrice = Double()
    var baggagePrice = Double()
    var taxesK3 = Double()
    var conBirfurcation = Double()
    var passengerEmail = String()
    var passengerPhone = String()
    var passengerName = String()
    var returnResultIndex: String?
    var resultIndex: String?
    var selectedHeader = Int()
    //Meal
    var selectedMeal = 0
    var arrSelectedMeal = [[String:Any]]()
    //var selectedSectionMeal = [Int]()
    var selectedSectionBaggage = [Int]()
    var selectedMealTotalPrice = Int()
    var selectedBaggageTotalPrice = Int()
    //Baggage
    var selectedBaggage = 0
    
    //Meal and baggage
    var baggageDetails = [[Baggage]]()
    var baggageDetailsNonLCC = [BaggageNonLCC]()
    var mealData = [[MealDynamic]]()
    var mealDataNonLCC = [Meal]()
    
    var selectedMealData = [MealDynamic]()
    var selectedBaggageData = [Baggage]()
    var selectedMealDataNonLCC = [Meal]()
    
    var finalSelectedMealData = [[MealDynamic]]()
    var finalelectedBaggageData = [[Baggage]]()
    //Seat
    var arrMealDynamic = [[MealDynamic]]()
    
    var arrMeal2 = [[Meal]]()
    
    var arrSelectedSeat = [[Seats]]()
    
    var seatIndex = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"]
    var missingIndex = [Int]()
    
    var bottomPriceMeal = Int()
    var bottomPriceBaggage = Int()
    
    var maxSeats = [Seats]()
    var totalNumberofSeatsWithMissingChar = Int()
    
    var priceData = Double()
    var allSeatsPrice = Int()
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleSeatList()
        vwBackground.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        self.setupCollectionView()
        
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 20, width: 200, height: 30)
        let attributedString = NSMutableAttributedString.init(string: "Skip to payment")
        
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 2, range:
                                        NSRange.init(location: 0, length: attributedString.length));
        btnSkip.setAttributedTitle(attributedString, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrSelectedSeat = []
        // seatSelectionPassengers = []
        finalSeletedSeatIndex = []
        finalSeletedSeats = []
        stopNumber = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
        //        self.collectionViewHeight.constant = height
    }
    
    //MARK: - Custom methods
    func handleSeatList() {
        arrSeatTypes.append("Not set")
        arrSeatTypes.append("Window")
        arrSeatTypes.append("Aisle")
        arrSeatTypes.append("Middle")
        arrSeatTypes.append("WindowRecline")
        arrSeatTypes.append("WindowWing")
        arrSeatTypes.append("WindowExitRow")
        arrSeatTypes.append("WindowReclineWing")
        arrSeatTypes.append("WindowReclineExitRow")
        arrSeatTypes.append("WindowWingExitRow")
        arrSeatTypes.append("AisleRecline")
        arrSeatTypes.append("AisleWing")
        arrSeatTypes.append("AisleExitRow")
        arrSeatTypes.append("AisleReclineWing")
        arrSeatTypes.append("AisleReclineExitRow")
        arrSeatTypes.append("AisleWingExitRow")
        arrSeatTypes.append("MiddleRecline")
        arrSeatTypes.append("MiddleWing")
        arrSeatTypes.append("MiddleExitRow")
        arrSeatTypes.append("MiddleReclineWing")
        arrSeatTypes.append("MiddleReclineExitRow")
        arrSeatTypes.append("MiddleWingExitRow")
        arrSeatTypes.append("WindowReclineWingExitRow")
        arrSeatTypes.append("AisleReclineWingExitRow")
        arrSeatTypes.append("MiddleReclineWingExitRow")
        arrSeatTypes.append("WindowBulkhead")
        arrSeatTypes.append("WindowQuiet")
        arrSeatTypes.append("WindowBulkheadQuiet")
        arrSeatTypes.append("MiddleBulkhead")
        arrSeatTypes.append("MiddleQuiet")
        arrSeatTypes.append("MiddleBulkheadQuiet")
        arrSeatTypes.append("AisleBulkhead")
        arrSeatTypes.append("AisleQuiet")
        arrSeatTypes.append("AisleBulkheadQuiet")
        arrSeatTypes.append("CentreAisle")
        arrSeatTypes.append("CentreMiddle")
        arrSeatTypes.append("CentreAisleBulkHead")
        arrSeatTypes.append("CentreAisleQuiet")
        arrSeatTypes.append("CentreAisleBulkHeadQuiet")
        arrSeatTypes.append("CentreMiddleBulkHead")
        arrSeatTypes.append("CentreMiddleQuiet")
        arrSeatTypes.append("CentreMiddleBulkHeadQuiet")
        arrSeatTypes.append("WindowBulkHeadWing")
        arrSeatTypes.append("WindowBulkHeadExitRow")
        arrSeatTypes.append("MiddleBulkHeadWing")
        arrSeatTypes.append("MiddleBulkHeadExitRow")
        arrSeatTypes.append("AisleBulkHeadWing")
        arrSeatTypes.append("AisleBulkHeadExitRow")
        arrSeatTypes.append("NoSeatAtThisLocation")
        arrSeatTypes.append("WindowAisle")
        arrSeatTypes.append("NoSeatRow")
        arrSeatTypes.append("NoSeatRowExit")
        arrSeatTypes.append("NoSeatRowWing")
        arrSeatTypes.append("NoSeatRowWingExit")
        arrSeatTypes.append("WindowAisleRecline")
        arrSeatTypes.append("WindowAisleWing")
        arrSeatTypes.append("WindowAisleExitRow")
        arrSeatTypes.append("WindowAisleReclineWing")
        arrSeatTypes.append("WindowAisleReclineExitRow")
        arrSeatTypes.append("WindowAisleWingExitRow")
        arrSeatTypes.append("WindowAisleBulkhead")
        arrSeatTypes.append("WindowAisleBulkheadWing")
    }
    func setupCollectionView() {
        
        //self.collVwHeader.ragisterNib(nibName: "SeatHeaderCVC")
        //  self.collectionView.ragisterNib(nibName: FlightSeatXIB().identifier)
        //  self.collectionView.register(UINib(nibName: "HCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HCollectionReusableView")
        
        self.lblPrice.text = "₹\(LoaderClass.shared.commaSeparatedPrice(val: Int(priceData+Double(allSeatsPrice)+Double(selectedMealTotalPrice)+Double(selectedBaggageTotalPrice).rounded())))"
        
        if ssrModel?.ssr?.response?.mealDynamic?.count ?? 0 > 0 {
            for i in 0..<(ssrModel?.ssr?.response?.mealDynamic?.count ?? 0) {
                if ssrModel?.ssr?.response?.mealDynamic?[i].first?.origin == ssrModel?.ssr?.response?.mealDynamic?[i].last?.origin {
                    arrMealDynamic.append(contentsOf: (ssrModel?.ssr?.response?.mealDynamic)!)
                } else {
                    var arrMealDynamic1 = [MealDynamic]()
                    var arrMealDynamic2 = [MealDynamic]()
                    for j in 0..<(ssrModel?.ssr?.response?.mealDynamic?[i].count ?? 0) {
                        if ssrModel?.ssr?.response?.mealDynamic?[i][0].origin == ssrModel?.ssr?.response?.mealDynamic?[i][j].origin {
                            arrMealDynamic1.append((ssrModel?.ssr?.response?.mealDynamic?[i][j])!)
                        } else if ssrModel?.ssr?.response?.mealDynamic?[i][0].origin != ssrModel?.ssr?.response?.mealDynamic?[i][j].origin {
                            arrMealDynamic2.append((ssrModel?.ssr?.response?.mealDynamic?[i][j])!)
                        }
                    }
                    arrMealDynamic.append(arrMealDynamic1)
                    arrMealDynamic.append(arrMealDynamic2)
                }
            }
        } else if ssrModel?.ssr?.response?.meal?.count ?? 0 > 0 {
            arrMeal2.append((ssrModel?.ssr?.response?.meal)!)
        }
    }
    
    
    //MARK: - @IBActions
    @IBAction func actionSkipToPayment(_ sender: UIButton) {
        let vc = ViewControllerHelper.getViewController(ofType: .WalletPaymentVC, StoryboardName: .Main) as! WalletPaymentVC
        vc.baseAmt = basePrice
        vc.couponAmt = self.discount
        //            vc.seatAmt =
        //            vc.bagaggeAmt =
        //            vc.mealAmt =
        vc.payblePayment = "\(lblPrice.text?.replacingOccurrences(of: "₹", with: "").replacingOccurrences(of: ",", with: "") ?? "")"
        vc.param = self.param
        vc.amount = Double(lblPrice.text?.replacingOccurrences(of: "₹", with: "").replacingOccurrences(of: ",", with: "") ?? "0") ?? 0.0
        vc.screenFrom = .flight
        vc.tracID = self.traceId
        vc.logId = self.logId
        vc.token = self.tokenId
        vc.ssrModel = self.ssrModel
        vc.passengerEmail = passengerEmail
        vc.passengerPhone = passengerPhone
        vc.passengerName = passengerName
        vc.dataFlight = dataFlight
        if GetData.share.isOnwordBook() == true {
            vc.returnResultIndex = returnResultIndex
        }
        vc.publishedFare = basePrice + taxes
        self.pushView(vc: vc)
        
    }
    @IBAction func backOnPress(_ sender: UIButton) {
        LoaderClass.shared.arrSelectedSeat = []
        LoaderClass.shared.arrSelectedMealDynamic = []
        LoaderClass.shared.arrSelectedBaggageDynamic = []
        LoaderClass.shared.arrSelectedMeal = []
        self.popView()
    }
    @IBAction func fareBreakupOnPress(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .FareBrakeupVC, StoryboardName: .Flight) as? FareBrakeupVC {
            
            vc.discount = self.discount
            vc.basePrice = basePrice
            vc.convenientFee = convenientFee
            vc.baggagePrice = Double(selectedBaggageTotalPrice)
            vc.mealPrice = Double(selectedMealTotalPrice)
            vc.seatPrice = Double(allSeatsPrice)
            vc.taxes = self.taxes
            vc.taxesK3 = self.taxesK3
            vc.conBirfurcation = conBirfurcation
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func continueOnPress(_ sender: UIButton) {
        var Passengers = self.param["Passengers"] as? [[String:Any]] ?? []
        self.seletedSeatIndex = []
        self.seletedSeats = []
        _ = [[String:Any]]()
        
        //Seat Param
        var arr = [Seats]()
        for (i,_) in LoaderClass.shared.arrSelectedSeat.enumerated() {
            for j in 0..<LoaderClass.shared.arrSelectedSeat[i].count {
                
                if LoaderClass.shared.arrSelectedSeat[i].count > 0 {
                    arr.append(LoaderClass.shared.arrSelectedSeat[i][j])
                }
            
            let convertedArray = arr.map { seat in
                return (airlineCode: seat.airlineCode, flightNumber: seat.flightNumber, craftType: seat.craftType, origin: seat.origin, destination: seat.destination, availablityType: seat.availablityType, description: seat.description, code: seat.code, rowNo: seat.rowNo, seatNo: seat.seatNo, seatType: seat.seatType, seatWayType: seat.seatWayType, compartment: seat.compartment, deck: seat.deck, currency: seat.currency, price: seat.price)
            }
                Passengers[j][WSResponseParams.WS_RESP_PARAM_SEAT_DYNAMIC] = convertedArray
            }
        }
        
        //Meal Param
        var arrMeal = [MealDynamic]()
        var arrMeal2 = [Meal]()
        if self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
            for (i,_) in LoaderClass.shared.arrSelectedMealDynamic.enumerated() {
                for j in 0..<LoaderClass.shared.arrSelectedMealDynamic[i].count {
                    
                    if LoaderClass.shared.arrSelectedMealDynamic[i].count > 0 {
                        arrMeal.append(LoaderClass.shared.arrSelectedMealDynamic[i][j])
                    }
                    
                    let convertedArray = arrMeal.map { meal in
                        return (airlineCode: meal.airlineCode, flightNumber: meal.flightNumber, wayType: meal.wayType, code: meal.code, description: meal.description, airlineDescription: meal.airlineDescription, quantity: meal.quantity, currency: meal.currency, price: meal.price, origin: meal.origin, destination: meal.destination)
                    }
                    Passengers[j][WSResponseParams.WS_RESP_PARAM_MEAL_DYNAMIC] = convertedArray
                }
            }
        } else {
            
            for (i,_) in LoaderClass.shared.arrSelectedMeal.enumerated() {
                for j in 0..<LoaderClass.shared.arrSelectedMeal[i].count {
                    
                    if LoaderClass.shared.arrSelectedMeal[i].count > 0 {
                        arrMeal2.append(LoaderClass.shared.arrSelectedMeal[i][j])
                    }
                    
                    let convertedArray = arrMeal2.map { meal in
                        return (code: meal.code, description: meal.description)
                    }
                    Passengers[j][WSResponseParams.WS_RESP_PARAM_MEAL] = convertedArray
                }
            }
            
        }
        
        //Baggage Param
        var arrBaggage = [Baggage]()
        for (i,_) in LoaderClass.shared.arrSelectedBaggageDynamic.enumerated() {
            for j in 0..<LoaderClass.shared.arrSelectedBaggageDynamic[i].count {
                
                if LoaderClass.shared.arrSelectedBaggageDynamic[i].count > 0 {
                    arrBaggage.append(LoaderClass.shared.arrSelectedBaggageDynamic[i][j])
                }
            
            let convertedArray = arrBaggage.map { baggage in
                return (airlineCode: baggage.airlineCode, flightNumber: baggage.flightNumber, wayType: baggage.wayType, code: baggage.code, text: baggage.text, description: baggage.description, weight: baggage.weight, currency: baggage.currency, price: baggage.price, origin: baggage.origin, destination: baggage.destination)
            }
                Passengers[j][WSResponseParams.WS_RESP_PARAM_BAGGAGE] = convertedArray
            }
        }
        
//        for i in 0..<numberOfSeat {
//            if selectedBaggageData.count == 0 {
//                Passengers[i].removeValue(forKey: WSResponseParams.WS_RESP_PARAM_BAGGAGE)
//            }else{
//               // Passengers[i][WSResponseParams.WS_RESP_PARAM_BAGGAGE] = selectedBaggageData[i]
//                Passengers[i].removeValue(forKey: WSResponseParams.WS_RESP_PARAM_BAGGAGE)
//            }
//            if self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
//                
//                if selectedMealData.count == 0 {
//                    Passengers[i].removeValue(forKey: WSResponseParams.WS_RESP_PARAM_MEAL_DYNAMIC)
//                }else{
//                    Passengers[i][WSResponseParams.WS_RESP_PARAM_MEAL_DYNAMIC] = selectedMealData[i]
//                }
//            }  else {
//                if selectedMealDataNonLCC.count == 0 {
//                    Passengers[i].removeValue(forKey: WSResponseParams.WS_RESP_PARAM_MEAL)
//                }else{
//                    Passengers[i][WSResponseParams.WS_RESP_PARAM_MEAL] = selectedMealDataNonLCC[i]
//                }
//            }
//        }
        
        self.param["Passengers"] = Passengers
        //debugPrint(self.param)
        
        if let vc = ViewControllerHelper.getViewController(ofType: .WalletPaymentVC, StoryboardName: .Main) as? WalletPaymentVC {
            vc.payblePayment = "\(lblPrice.text?.replacingOccurrences(of: "₹", with: "").replacingOccurrences(of: ",", with: "") ?? "")"
            vc.param = self.param
            vc.amount = Double(lblPrice.text?.replacingOccurrences(of: "₹", with: "").replacingOccurrences(of: ",", with: "") ?? "0") ?? 0.0
            vc.screenFrom = .flight
            vc.tracID = self.traceId
            vc.logId = self.logId
            vc.token = self.tokenId
            vc.ssrModel = self.ssrModel
            vc.passengerEmail = passengerEmail
            vc.passengerPhone = passengerPhone
            vc.passengerName = passengerName
            vc.dataFlight = dataFlight
            vc.baseAmt = basePrice
            vc.couponAmt = self.discount
//            vc.seatAmt =
//            vc.bagaggeAmt =
//            vc.mealAmt =
            
            if GetData.share.isOnwordBook() == true {
                vc.returnResultIndex = returnResultIndex
            }
            vc.publishedFare = basePrice + taxes
           // self.vwBackground.removeFromSuperview()
            self.pushView(vc: vc)
        }
        //  }
        //   }
        //   }
    }
    func getSeatType(seat:Int) -> String{
        if seat == 1{
            return "Window"
        }else if seat == 2{
            return "Aisle"
        }else if seat == 3{
            return "Middle"
        }else{
            return ""
        }
    }
}

extension SelectSeatVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == collVwHeader {
            return 1
        } else { //  if collectionView == collVwCityCodes
            return 1
        }
        //        else {
        //            arr = []
        //            for count in (ssrModel?.ssr?.response?.seatDynamic ?? []) {
        //                for j in count.segmentSeat ?? [] {
        //                    arr.append(j)
        //                }
        //            }
        //          //  arrMealDynamic[stopNumber].
        //            return arr[stopNumber].rowSeats?.count ?? 0
        //            //self.ssrModel?.ssr?.response?.seatDynamic?.first?.segmentSeat?[stopNumber].rowSeats?.count ?? 0
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwHeader {
            return arrHeader.count
        } else { // if collectionView == collVwCityCodes
            switch selectedHeader {
            case 0:
                return arr.count //ssrModel?.fare_quote?.response?.seatDynamic?.count ?? 0
            case 1:
                if self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
                    for _ in 0..<arrMealDynamic.count {
                        LoaderClass.shared.arrSelectedMealDynamic.append([])
                    }
                    return arrMealDynamic.count != 0 ? arrMealDynamic.count : 0
                } else {
                    for _ in 0..<arrMeal2.count {
                        LoaderClass.shared.arrSelectedMeal.append([])
                    }
                    return arrMeal2.count != 0 ? arrMeal2.count : 0
                }
            default:
                for _ in 0..<(ssrModel?.ssr?.response?.baggage?.count ?? 0) {
                    LoaderClass.shared.arrSelectedBaggageDynamic.append([])
                }
                return ssrModel?.ssr?.response?.baggage?.count ?? 0
            }
        }
        /*
         else {
         let sectionCount = arr[stopNumber].rowSeats?[section].seats
         return sectionCount?.count ?? 0
         }
         */
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwHeader {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatHeaderCVC", for: indexPath) as! SeatHeaderCVC
            cell.btnHeader.setTitle(arrHeader[indexPath.row], for: .normal)
            cell.btnHeader.backgroundColor = selectedHeader == indexPath.row ? .lightBlue() : .clear
            cell.btnHeader.setTitleColor(selectedHeader == indexPath.row ? .white : .black, for: .normal)
            cell.btnHeader.titleLabel?.font = .boldFont(size: 16)
            return cell
        } else if collectionView == collVwCityCodes {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlightCityCodeCVC", for: indexPath) as! FlightCityCodeCVC
            switch selectedHeader {
            case 0:
                
                cell.lblSourceDestination.text = "\(arr[indexPath.row].rowSeats?[0].seats?[0].origin ?? "") - \(arr[indexPath.row].rowSeats?[0].seats?[0].destination ?? "")"
                cell.vwBackground.borderColor = stopNumber == indexPath.row ? .lightBlue() : .clear
                cell.lblSourceDestination.textColor = stopNumber == indexPath.row ? .lightBlue() : .grayColor()
            case 1:
                cell.lblSourceDestination.text = "\(arrMealDynamic[indexPath.row][0].origin ?? "") - \(arrMealDynamic[indexPath.row][0].destination ?? "")"
                cell.vwBackground.borderColor = stopNumber == indexPath.row ? .lightBlue() : .clear
                cell.lblSourceDestination.textColor = stopNumber == indexPath.row ? .lightBlue() : .grayColor()
            default:
                cell.lblSourceDestination.text = "\(ssrModel?.ssr?.response?.baggage?[indexPath.row].first?.origin ?? "") - \(ssrModel?.ssr?.response?.baggage?[indexPath.row].first?.destination ?? "")"
                cell.vwBackground.borderColor = stopNumber == indexPath.row ? .lightBlue() : .clear
                cell.lblSourceDestination.textColor = stopNumber == indexPath.row ? .lightBlue() : .grayColor()
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlightSeatXIB().identifier, for: indexPath) as! FlightSeatXIB
            
            let indexData = arr[stopNumber].rowSeats?[indexPath.section].seats?[indexPath.row]
            if indexData?.availablityType == 1 {
                cell.lblSeatNumber.isHidden = false
                cell.lblSeatNumber.text = indexData?.code ?? ""
                cell.imgSeat.image = .busUnSelectSeat()
                //                if self.arrSelectedSeat.count > 0 {
                //                    self.arrSelectedSeat[selectedCityCode].forEach { val in
                //                        if val.code == indexData?.code {
                //                            cell.imgSeat.image = .flightSelectSeat()
                //                        }else{
                //                            cell.imgSeat.image = .busUnSelectSeat()
                //                        }
                //                    }
                //                }
                //                cell.imgSeat.image = self.arrSelectedSeat[selectedCityCode].contains(indexData?.code ?? "") ? .flightSelectSeat() : .busUnSelectSeat()
            }else{
                cell.lblSeatNumber.isHidden = false
                // cell.lblSeatNumber.isHidden = true
                cell.imgSeat.image = .flightBookSeat()
            }
            
            if self.arrSelectedSeat.count > 0 {
                self.arrSelectedSeat[stopNumber].forEach { val in
                    if val.code == indexData?.code {
                        cell.imgSeat.image = .flightSelectSeat()
                    }else{
                        cell.imgSeat.image = .busUnSelectSeat()
                    }
                }
            }
            
            if indexPath.row <= arrSeatTypes.count-1 {
                if indexPath.row == arr[stopNumber].rowSeats?[indexPath.section].seats?[0].seatType {
                    seatType = arrSeatTypes[indexPath.row]
                    // break
                }
            }
            
            if (seatType.contains("not set") || seatType.contains("Not set") || seatType.contains("NoSeat")) && (arr[stopNumber].rowSeats?[indexPath.section].seats?.count == 1) {
                cell.imgSeat.isHidden = true
                cell.lblSeatNumber.isHidden = true
            } else {
                cell.imgSeat.isHidden = false
                cell.lblSeatNumber.isHidden = false
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwHeader {
            return CGSize(width: (collVwHeader.frame.width/3) - 5, height: collVwHeader.frame.height)
        } else {
            return CGSize(width: 130, height: collVwHeader.frame.height)
        }
        //        else {
        //            let sectionCount = arr[stopNumber].rowSeats?[indexPath.section].seats
        //            return self.returnCGSize(collectionView: collectionView, indexPath: indexPath, seatCount: sectionCount?.count ?? 0)
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        LoaderClass.shared.loadAnimation()
        if collectionView == collVwHeader {
            stopNumber = 0
            selectedHeader = indexPath.row
            if indexPath.row == 0 {
                vwBackground.isHidden = true
            } else if indexPath.row == 1 {
                vwBackground.isHidden = false
                tblVwMealBaggage.reloadData()
                DispatchQueue.main.async {
                    if self.arrMealDynamic.count == 0 {
                        self.tblVwMealBaggage.isHidden = true
                        self.lblNoMealBaggage.isHidden = false
                        self.lblNoMealBaggage.text = "No meal is available in this flight"
                    }else{
                        self.tblVwMealBaggage.isHidden = false
                        self.lblNoMealBaggage.isHidden = true
                    }
                }
                LoaderClass.shared.stopAnimation()
            } else {
                self.tblVwMealBaggage.isHidden = false
                self.lblNoMealBaggage.isHidden = true
                //                if self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true  {
                //                    if self.ssrModel?.ssr?.response?.baggage?.first?.count ?? 0 == 0 {
                //                        self.tblVwMealBaggage.isHidden = true
                //                        self.lblNoMealBaggage.isHidden = false
                //                        self.lblNoMealBaggage.text = "No Baggage is available in this flight"
                //                    } else if (self.baggageDetails.first?.count == 1 && self.mealData.first?.first?.price == 0) {
                //                        self.tblVwMealBaggage.isHidden = true
                //                        self.lblNoMealBaggage.isHidden = false
                //                        self.lblNoMealBaggage.text = "No Baggage is available in this flight"
                //                    }
                //                }else{
                if self.ssrModel?.ssr?.response?.baggage?[stopNumber].count ?? 0 == 0{
                    self.tblVwMealBaggage.isHidden = true
                    self.lblNoMealBaggage.isHidden = false
                    self.lblNoMealBaggage.text = "No Baggage is available in this flight"
                }
                //  }
                vwBackground.isHidden = false
                tblVwMealBaggage.reloadData()
            }
            collVwHeader.reloadData()
            collVwCityCodes.reloadData()
            tblVwMealBaggage.reloadData()
            LoaderClass.shared.stopAnimation()
        } else if collectionView == collVwCityCodes {
            stopNumber = indexPath.row
            if selectedHeader == 2 {
                selectedBaggage = 0
                selectedBaggageData = LoaderClass.shared.arrSelectedBaggageDynamic[stopNumber]
            } else if selectedHeader == 1 {
                selectedMeal = 0
                selectedMealData = LoaderClass.shared.arrSelectedMealDynamic[stopNumber]
                //selectedMealDataNonLCC = LoaderClass.shared.arrSelectedMeal[stopNumber]
            }
            
           // selectedCityCode = indexPath.row
            LoaderClass.shared.seletedSeatIndex = []
            //Seats
            if selectedHeader == 0 {
                totalNumberofSeatsWithMissingChar = 0
                LoaderClass.shared.loadAnimation()
                seletedSeats = []
                if arrSelectedSeat.count != arr.count {
                    arrSelectedSeat = Array(repeating: [Seats](), count: arr.count)
                    print(arrSelectedSeat)
                    
                } else {
                    for i in 0..<numberOfSeat {
                        seletedSeatIndex = arrSelectedSeat[indexPath.row]
                        if arrSelectedSeat[indexPath.row].count > 0 {
                            if arrSelectedSeat[indexPath.row][i].code != "" {
                                finalSeletedSeats[i] = arrSelectedSeat[indexPath.row][i].code
                                //seletedSeats[i] =
                            }
                        }
                    }
                }
                
                self.tblVwSeats.reloadData()
            } else {
                tblVwMealBaggage.reloadData()
            }
            
            self.collVwCityCodes.reloadData()
            LoaderClass.shared.stopAnimation()
        } else {
            if arrSelectedSeat.count != arr.count {
                arrSelectedSeat = Array(repeating: [Seats](), count: arr.count)
                print(arrSelectedSeat)
            }
            //selectedCityCode
            let indexData = arr[stopNumber].rowSeats?[indexPath.section].seats?[indexPath.row]
            
            if indexData?.availablityType == 1 {
                let cell = collectionView.cellForItem(at: indexPath) as! FlightSeatXIB
                if self.seletedSeats.contains(indexData?.code ?? ""){
                    let index = self.seletedSeats.firstIndex(of: indexData?.code ?? "") ?? 0
                    self.seatPrice = 0
                    self.lblPrice.text = "₹\(Int(priceData+Double(allSeatsPrice)+Double(selectedMealTotalPrice)+Double(selectedBaggageTotalPrice).rounded())-Int(indexData?.price ?? 0))"
                   
                    cell.imgSeat.image = .busUnSelectSeat()
                    //for i in 0...numberOfSeat-1{
                    self.seletedSeatIndex.remove(at: index)
                    self.seletedSeats.remove(at: index)
                    self.finalSeletedSeats.remove(at: index)
                    
                }
                arrSelectedSeat[stopNumber] = seletedSeatIndex
            }
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if collectionView != collVwHeader {
//            if kind == UICollectionView.elementKindSectionHeader {
//                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HCollectionReusableView", for: indexPath) as! HCollectionReusableView
//                
//                for i in 0...arrSeatTypes.count {
//                    if i == arr[stopNumber].rowSeats?[indexPath.section].seats?[0].seatType {
//                        seatType = arrSeatTypes[i]
//                        break
//                    }
//                }
//                if seatType.contains("Exit") {
//                    headerView.lblExit.isHidden = false
//                    headerView.lblExitTwo.isHidden = false
//                }
//                
//                if (seatType.contains("not set") || seatType.contains("Not Set") || seatType.contains("NoSeat")) && (arr[stopNumber].rowSeats?[indexPath.section].seats?.count == 1) {
//                    headerView.lblExit.isHidden = true
//                    headerView.lblExitTwo.isHidden = true
//                }
//                return headerView
//            }
//        }
//        return UICollectionReusableView()
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if collectionView != collVwHeader {
//            for i in 0...arrSeatTypes.count {
//                if i == arr[stopNumber].rowSeats?[section].seats?[0].seatType {
//                    seatType = arrSeatTypes[i]
//                    break
//                }
//            }
//            if seatType.contains("Exit") {
//                return CGSize(width: collectionView.frame.width, height: 30)
//            } else {
//                return CGSize(width: 0, height: 0)
//            }
//        }
//        return CGSize(width: 0, height: 0)
//    }
}

extension SelectSeatVC: UITableViewDelegate, UITableViewDataSource, CollectionViewCellDelegate {

    func collectionViewCellDidClick(_ seatPrice: Double, cell1: UICollectionViewCell, indexPath: IndexPath, isDeselected: Bool) {
        allSeatsPrice = 0
        for (i,_) in LoaderClass.shared.arrSelectedSeat.enumerated() {
            for j in 0..<LoaderClass.shared.arrSelectedSeat[i].count {
                
                if LoaderClass.shared.arrSelectedSeat[i].count > 0 {
                    allSeatsPrice += LoaderClass.shared.arrSelectedSeat[i][j].price
                }
            }
        }
        
        self.seatPrice = seatPrice
        
            //self.priceData = self.priceData+Double(seatPrice)
        self.lblPrice.text = "₹\(Int(priceData+Double(allSeatsPrice)+Double(selectedMealTotalPrice)+Double(selectedBaggageTotalPrice).rounded()))"
        LoaderClass.shared.loadAnimation()
        tblVwSeats.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedHeader == 0 {
            //  if tableView == tblVwSeats {
            arr = []
            for count in (ssrModel?.ssr?.response?.seatDynamic ?? []) {
                for j in count.segmentSeat ?? [] {
                    arr.append(j)
                }
            }
            tblVwSeatHeight.constant = CGFloat((arr[stopNumber].rowSeats?.count ?? 0)*65)
            return arr[stopNumber].rowSeats?.count ?? 0
        } else {
            if selectedHeader == 1 {
                if self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
                    if arrMealDynamic.count > 0 {
                        return arrMealDynamic[stopNumber].count
                    }
                } else {
                    if arrMeal2.count > 0 {
                        return arrMeal2[stopNumber].count
                    }
                }
                return 0
            } else {
                return self.ssrModel?.ssr?.response?.baggage?[stopNumber].count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedHeader == 0 && tableView == tblVwSeats {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlightSeatsTVC") as! FlightSeatsTVC
            cell.delegate = self
          
            let sectionCount = arr[stopNumber].rowSeats?.max{$0.seats?.count ?? 0 < $1.seats?.count ?? 0}?.seats?.count ?? 0
            maxSeats = (arr[stopNumber].rowSeats?.max{$0.seats?.count ?? 0 < $1.seats?.count ?? 0}?.seats ?? [])
            
            switch sectionCount {
            case 9:
                findMissingElement("I")
            case 10:
                findMissingElement("J")
            case 11:
                findMissingElement("K")
            case 12:
                findMissingElement("L")
            default:
                break
            }
            cell.reloadData(sectionCount, arrSeatSegment: arr, section: indexPath.row, arrSeatTypes: arrSeatTypes, vc: self, missingSeatIndex: missingIndex, numberOfSeat: numberOfSeat, selectedCityCode: stopNumber, totalNumberofSeatsWithMissingChar: totalNumberofSeatsWithMissingChar, indexPath: indexPath)
            
            // let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HCollectionReusableView", for: indexPath) as! HCollectionReusableView
            
            // for i in 0...arrSeatTypes.count {
            if indexPath.row < arrSeatTypes.count {
                if indexPath.row == arr[stopNumber].rowSeats?[indexPath.row].seats?[0].seatType ?? 0 {
                    seatType = arrSeatTypes[indexPath.row]
                    // break
                }
            }
            if seatType.contains("Exit") {
            }
            
            if seatType.contains("not set") || seatType.contains("Not Set") || seatType.contains("NoSeat") && (arr[stopNumber].rowSeats?[indexPath.section].seats?.count == 1) {
                
            }
            
            return cell
        } else if selectedHeader == 1 || selectedHeader ==  2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BaggageTVC") as! BaggageTVC
            cell.btnDec.tag = indexPath.row
            cell.btnInc.tag = indexPath.row
            cell.btnDec.addTarget(self, action: #selector(actionDecrease(_ :)), for: .touchUpInside)
            cell.btnInc.addTarget(self, action: #selector(actionIncrease(_ :)), for: .touchUpInside)
            
            if selectedHeader == 1 {
                
                cell.vwOuter.borderColor = .clear
                if self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
                    var count = 0
                    if LoaderClass.shared.arrSelectedMealDynamic.count > 0 && LoaderClass.shared.arrSelectedMealDynamic.count >= stopNumber {
                        if LoaderClass.shared.arrSelectedMealDynamic[stopNumber].count > 0 {
                            
                            if LoaderClass.shared.arrSelectedMealDynamic[stopNumber].contains(where: {$0.airlineDescription == arrMealDynamic[stopNumber][indexPath.row].airlineDescription}) {
                                
                                let count2 = LoaderClass.shared.arrSelectedMealDynamic[stopNumber].filter { $0.airlineDescription == arrMealDynamic[stopNumber][indexPath.row].airlineDescription}.count
                                
                                count = count2
                                cell.vwOuter.borderColor = .lightBlue()
                            } else {
                                count = 0
                                cell.vwOuter.borderColor = .clear
                            }
                        }
                    }
                    cell.lblQuatity.text = "\(count)"
                    
                    if arrMealDynamic[stopNumber][indexPath.row].description == 1 {
                        cell.lblPrice.text = "₹0"
                    } else {
                        cell.lblPrice.text = "₹\(arrMealDynamic[stopNumber][indexPath.row].price ?? 0)"
                    }
                    cell.lblPriceWeight.text = "\(arrMealDynamic[stopNumber][indexPath.row].airlineDescription ?? "")"
                } else {
                    var count = 0
                    if LoaderClass.shared.arrSelectedMeal.count > 0 && LoaderClass.shared.arrSelectedMeal.count >= stopNumber {
                        if LoaderClass.shared.arrSelectedMeal[stopNumber].count > 0 {
                            if LoaderClass.shared.arrSelectedMeal[stopNumber].contains(where: {$0.code == arrMeal2[stopNumber][indexPath.row].code && $0.description == arrMeal2[stopNumber][indexPath.row].description}) {
                                
                                let count2 = LoaderClass.shared.arrSelectedMeal[stopNumber].filter {$0.code == arrMeal2[stopNumber][indexPath.row].code && $0.description == arrMeal2[stopNumber][indexPath.row].description}.count
                                
                                count = count2
                                
                               // count += 1
                                cell.vwOuter.borderColor = .lightBlue()
                            } else {
                                count = 0
                                cell.vwOuter.borderColor = .clear
                            }
                        }
                    }
                    cell.lblQuatity.text = "\(count)"
                    
                    //if arrMeal[stopNumber][indexPath.row].description == 1 {
                    cell.lblPrice.text = "₹0"
                    //                    } else {
                    //                        cell.lblPrice.text = "₹\(arrMealDynamic[stopNumber][indexPath.row].price ?? 0)"
                    //                    }
                    cell.lblPriceWeight.text = "\(arrMeal2[stopNumber][indexPath.row].description ?? "")"
                }
            } else {
                cell.vwOuter.borderColor = .clear
                var count = 0

                if LoaderClass.shared.arrSelectedBaggageDynamic.count > 0 && LoaderClass.shared.arrSelectedBaggageDynamic.count >= stopNumber {
                    if LoaderClass.shared.arrSelectedBaggageDynamic[stopNumber].count > 0 {
                        if LoaderClass.shared.arrSelectedBaggageDynamic[stopNumber].contains(where: {($0.weight == self.ssrModel?.ssr?.response?.baggage?[stopNumber][indexPath.row].weight) && ($0.text == self.ssrModel?.ssr?.response?.baggage?[stopNumber][indexPath.row].text)}) {
                            
                            let count2 = LoaderClass.shared.arrSelectedBaggageDynamic[stopNumber].filter {($0.weight == self.ssrModel?.ssr?.response?.baggage?[stopNumber][indexPath.row].weight) && ($0.text == self.ssrModel?.ssr?.response?.baggage?[stopNumber][indexPath.row].text)}.count
                            
                            count = count2
                            cell.vwOuter.borderColor = .lightBlue()
                        } else {
                            count = 0
                            cell.vwOuter.borderColor = .clear
                        }
                    }
                }
                
                cell.lblQuatity.text = "\(count)"
                
                cell.lblPriceWeight.text = self.ssrModel?.ssr?.response?.baggage?[stopNumber][indexPath.row].text != "" ? "\(self.ssrModel?.ssr?.response?.baggage?[stopNumber][indexPath.row].weight ?? 0)kg\n\(self.ssrModel?.ssr?.response?.baggage?[stopNumber][indexPath.row].text ?? "")" : "\(self.ssrModel?.ssr?.response?.baggage?[stopNumber][indexPath.row].weight ?? 0)kg"
                
                cell.lblPrice.text = "₹\(self.ssrModel?.ssr?.response?.baggage?[stopNumber][indexPath.row].price ?? 0)"
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedHeader == 0 {
            for i in 0...arrSeatTypes.count {
                if i == arr[stopNumber].rowSeats?[indexPath.row].seats?[0].seatType {
                    seatType = arrSeatTypes[i]
                    break
                }
            }
            if seatType.contains("Exit") {
                return 90
            } else if (seatType.contains("not set") || seatType.contains("Not set") || seatType.contains("NoSeat")) && (arr[stopNumber].rowSeats?[indexPath.row].seats?.count == 1) {
                return 0
            } else {
                return 65
            }
        } else {
            if selectedHeader == 1 {
                if arrMealDynamic[stopNumber].count-1 >= indexPath.row {
                    if arrMealDynamic[stopNumber][indexPath.row].airlineDescription?.count ?? 0 == 0 {
                        return 0
                    } else {
                        return UITableView.automaticDimension
                    }
                } else {
                    return UITableView.automaticDimension
                }
            } else {
                if self.ssrModel?.ssr?.response?.baggage?[stopNumber][indexPath.row].weight == 0 {
                    return 0
                } else {
                    return UITableView.automaticDimension
                }
            }
        }
    }
    
    @objc func actionIncrease(_ sender: UIButton){
        if selectedHeader == 1 {
            if self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
                if LoaderClass.shared.arrSelectedMealDynamic[stopNumber].count < numberOfSeat {
                    selectedMeal = selectedMeal + 1
                    let cell = tblVwMealBaggage.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BaggageTVC
                    cell.vwOuter.borderColor = .lightBlue()
                    bottomPriceMeal = arrMealDynamic[stopNumber][sender.tag].airlineDescription?.count ?? 0 == 0  ? 0 : arrMealDynamic[stopNumber][sender.tag].price ?? 0
                    cell.lblQuatity.text = "\(Int(cell.lblQuatity.text ?? "0")! + 1)"
                    selectedMealTotalPrice = selectedMealTotalPrice + bottomPriceMeal
                    
                    self.lblPrice.text = "₹\(Int(priceData+Double(allSeatsPrice)+Double(selectedMealTotalPrice)+Double(selectedBaggageTotalPrice).rounded()))"
//                    if !selectedSectionMeal.contains(sender.tag) {
//                        selectedSectionMeal.append(sender.tag)
//                    }
                    
                    var price1 = 0
                    self.selectedMealData.append(arrMealDynamic[stopNumber][sender.tag])
                    price1 = price1 + (arrMealDynamic[stopNumber][sender.tag].airlineDescription?.count ?? 0 == 0 ? 0 : arrMealDynamic[stopNumber][sender.tag].price ?? 0)
                    
                    LoaderClass.shared.arrSelectedMealDynamic[stopNumber] = selectedMealData
                } else {
                    LoaderClass.shared.showSnackBar(message: "Maximum \(LoaderClass.shared.arrSelectedMealDynamic[stopNumber].count) meal can be selected")
                }
            } else {
                if LoaderClass.shared.arrSelectedMeal[stopNumber].count < numberOfSeat {
                    selectedMeal = selectedMeal + 1
                    let cell = tblVwMealBaggage.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BaggageTVC
                    cell.vwOuter.borderColor = .lightBlue()
                    //                    bottomPriceMeal = arrMeal[stopNumber][sender.tag].description?.count ?? 0 == 0  ? 0 : arrMealDynamic[stopNumber][sender.tag].price ?? 0
                    cell.lblQuatity.text = "\(Int(cell.lblQuatity.text ?? "0")! + 1)"
                    //                    selectedMealTotalPrice = selectedMealTotalPrice + bottomPriceMeal
                    
                    //                    self.lblPrice.text = "₹\(Int(priceData+Double(allSeatsPrice)+Double(selectedMealTotalPrice)+Double(selectedBaggageTotalPrice).rounded()))"
//                    if !selectedSectionMeal.contains(sender.tag) {
//                        selectedSectionMeal.append(sender.tag)
//                    }
                    
                    var price1 = 0
                    self.selectedMealDataNonLCC.append(arrMeal2[stopNumber][sender.tag])
                    //                    price1 = price1 + (arrMealDynamic[stopNumber][sender.tag].airlineDescription?.count ?? 0 == 0  ? 0 : arrMealDynamic[stopNumber][sender.tag].price ?? 0)
                    
                    LoaderClass.shared.arrSelectedMeal[stopNumber] = selectedMealDataNonLCC
                } else {
                    LoaderClass.shared.showSnackBar(message: "Maximum \(LoaderClass.shared.arrSelectedMeal[stopNumber].count) meal can be selected")
                }
            }
        } else {
            if LoaderClass.shared.arrSelectedBaggageDynamic[stopNumber].count < numberOfSeat {
                selectedBaggage = selectedBaggage + 1
                let cell = tblVwMealBaggage.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BaggageTVC
                cell.vwOuter.borderColor = .lightBlue()
                bottomPriceBaggage = self.ssrModel?.ssr?.response?.baggage?[stopNumber][sender.tag].price ?? 0
                cell.lblQuatity.text = "\(Int(cell.lblQuatity.text ?? "0")! + 1)"
               
                selectedBaggageTotalPrice = selectedBaggageTotalPrice + bottomPriceBaggage
                
                self.lblPrice.text = "₹\(Int(priceData+Double(allSeatsPrice)+Double(selectedMealTotalPrice)+Double(selectedBaggageTotalPrice).rounded()))"

                
                if !selectedSectionBaggage.contains(sender.tag) {
                    selectedSectionBaggage.append(sender.tag)
                }
                var price1 = 0
                self.selectedBaggageData.append((self.ssrModel?.ssr?.response?.baggage?[stopNumber][sender.tag])!)
                price1 = price1 + (self.ssrModel?.ssr?.response?.baggage?[stopNumber][sender.tag].weight ?? 0 == 0 ? 0 : self.ssrModel?.ssr?.response?.baggage?[stopNumber][sender.tag].price ?? 0)
                LoaderClass.shared.arrSelectedBaggageDynamic[stopNumber] = selectedBaggageData
            } else {
                LoaderClass.shared.showSnackBar(message: "Maximum \(LoaderClass.shared.arrSelectedBaggageDynamic[stopNumber].count) meal can be selected")
            }
        }
    }
    
    @objc func actionDecrease(_ sender: UIButton) {
        if selectedHeader == 1 {
            if self.ssrModel?.fare_quote?.response?.fareQuoteResult?.isLCC == true {
                let cell = tblVwMealBaggage.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BaggageTVC
                if Int(cell.lblQuatity.text ?? "0")! > 0 && LoaderClass.shared.arrSelectedMealDynamic[stopNumber].count > 0 {
                    selectedMeal = selectedMeal - 1
                    cell.lblQuatity.text = "\(Int(cell.lblQuatity.text ?? "0")! - 1)"
                    
                    bottomPriceMeal = arrMealDynamic[stopNumber][sender.tag].airlineDescription?.count ?? 0 == 0 ? 0 : arrMealDynamic[stopNumber][sender.tag].price ?? 0
                    selectedMealTotalPrice = selectedMealTotalPrice - bottomPriceMeal
                    self.lblPrice.text = "₹\(Int(priceData+Double(allSeatsPrice)+Double(selectedMealTotalPrice)+Double(selectedBaggageTotalPrice).rounded()))"
                    
//                    let index = arrMealDynamic[stopNumber][sender.tag]
//                    selectedMealData.removeAll { $0.airlineDescription == index.airlineDescription }
                    
                    let mealToRemove = arrMealDynamic[stopNumber][sender.tag]
                    let airlineDescription = mealToRemove.airlineDescription
                    
                    if let indexToRemove = LoaderClass.shared.arrSelectedMealDynamic[stopNumber].firstIndex(where: { $0.airlineDescription == airlineDescription }) {
                        LoaderClass.shared.arrSelectedMealDynamic[stopNumber].remove(at: indexToRemove)
                        selectedMealData.remove(at: indexToRemove)
                        
                        if cell.lblQuatity.text == "0" {
                            cell.vwOuter.borderColor = .clear
                          //  selectedSectionMeal.removeAll { $0 == sender.tag }
                        }
                    }
                }
            } else {
                let cell = tblVwMealBaggage.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BaggageTVC
                if Int(cell.lblQuatity.text ?? "0")! > 0 && LoaderClass.shared.arrSelectedMeal[stopNumber].count > 0 {
                    selectedMeal = selectedMeal - 1
                    cell.lblQuatity.text = "\(Int(cell.lblQuatity.text ?? "0")! - 1)"
                    
                    //  bottomPriceMeal = arrMeal[stopNumber][sender.tag].airlineDescription?.count ?? 0 == 0 ? 0 : arrMeal[stopNumber][sender.tag].price ?? 0
                    //  selectedMealTotalPrice = selectedMealTotalPrice - bottomPriceMeal
                    // self.lblPrice.text = "₹\(Int(priceData+Double(allSeatsPrice)+Double(selectedMealTotalPrice)+Double(selectedBaggageTotalPrice).rounded()))"
                    
//                    let index = arrMeal[stopNumber][sender.tag]
//                    selectedMealDataNonLCC.removeAll { $0.code == index.code && $0.description == index.description }
                    
                    let mealToRemove = arrMeal2[stopNumber][sender.tag]
                    let airlineDescription = mealToRemove.description
                    let airlineCode = mealToRemove.code
                    
                    if let indexToRemove = LoaderClass.shared.arrSelectedMeal[stopNumber].firstIndex(where: { $0.description == airlineDescription && $0.code == airlineCode }) {
                        LoaderClass.shared.arrSelectedMeal[stopNumber].remove(at: indexToRemove)
                        selectedMealDataNonLCC.remove(at: indexToRemove)
                        
                        if cell.lblQuatity.text == "0" {
                            cell.vwOuter.borderColor = .clear
                           // selectedSectionMeal.removeAll { $0 == sender.tag }
                        }
                    }
                }
            }
        } else {
          //  if selectedBaggage > 0 {
                let cell = tblVwMealBaggage.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BaggageTVC
            if Int(cell.lblQuatity.text ?? "0")! > 0 && LoaderClass.shared.arrSelectedBaggageDynamic[stopNumber].count > 0 {
                selectedBaggage = selectedBaggage - 1
                cell.lblQuatity.text = "\(Int(cell.lblQuatity.text ?? "0")! - 1)"
                bottomPriceBaggage = (self.ssrModel?.ssr?.response?.baggage?[stopNumber][sender.tag].weight ?? 0 == 0 ? 0 : self.ssrModel?.ssr?.response?.baggage?[stopNumber][sender.tag].price ?? 0)
                selectedBaggageTotalPrice = selectedBaggageTotalPrice - bottomPriceBaggage
                self.lblPrice.text = "₹\(Int(priceData+Double(allSeatsPrice)+Double(selectedMealTotalPrice)+Double(selectedBaggageTotalPrice).rounded()))"
                
                let baggageToRemove = self.ssrModel?.ssr?.response?.baggage?[stopNumber][sender.tag]
                //
                //                selectedBaggageData.removeAll { $0.text == baggageToRemove?.text }
                
                //                if selectedSectionBaggage.contains(sender.tag) {
                //                    if cell.lblQuatity.text == "0" {
                //                        cell.vwOuter.borderColor = .clear
                //                        selectedSectionBaggage = selectedSectionBaggage.filter{$0 != sender.tag}
                //                    }
                //                }
                
                if let indexToRemove = LoaderClass.shared.arrSelectedBaggageDynamic[stopNumber].firstIndex(where: { ($0.text == baggageToRemove?.text) && ($0.weight == baggageToRemove?.weight) }) {
                    LoaderClass.shared.arrSelectedBaggageDynamic[stopNumber].remove(at: indexToRemove)
                    selectedBaggageData.remove(at: indexToRemove)
                    
                    if cell.lblQuatity.text == "0" {
                        cell.vwOuter.borderColor = .clear
                        selectedSectionBaggage.removeAll { $0 == sender.tag }
                    }
                }
            }
        }
    }
    
    
    
    func findMissingElement(_ character: String) {
        
        var allMatch = true
        for element in arr[stopNumber].rowSeats ?? [] {
            if let lastSeat = element.seats?.last?.seatNo.unicodeScalars.first,
               let characterFirst = character.unicodeScalars.first {
                if lastSeat > characterFirst {
                    //Find out the number of an alphabetical character
                    totalNumberofSeatsWithMissingChar = Int(lastSeat.value - UnicodeScalar("A").value + 1)
                    allMatch = false
                    break
                }
            }
        }
        if allMatch {
            print("All last elements match the specific value")
        } else {
            var index = [String]()
            
            for j in maxSeats {
                index.append(j.seatNo)
            }
            let seatNoSet = Set(index)
            let seatIndexSet = Set(seatIndex)
            
            let jj = seatIndexSet.subtracting(seatNoSet)
            
            //}
            // seatIndex.filter({$0 != arr[stopNumber].rowSeats?.last?.seats?.last?.seatNo})
            missingIndex = []
            for (index1,i) in seatIndex.enumerated() {
                for item in jj {
                    if item == i {
                        missingIndex.append(index1)
                    }
                }
            }
        }
    }
}
