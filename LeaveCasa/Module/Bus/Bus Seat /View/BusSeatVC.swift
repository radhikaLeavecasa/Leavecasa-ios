//
//  BusSeatVC.swift
//  LeaveCasa
//
//  Created by acme on 10/10/22.
//

import UIKit
import IBAnimatable
import AMPopTip

class BusSeatVC: UIViewController, TVCDelegate {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var priceCollection: UICollectionView!
    @IBOutlet weak var priceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblTotalSeat: UILabel!
    @IBOutlet weak var lblBoarding: UILabel!
    @IBOutlet weak var lblDropping: UILabel!
    @IBOutlet weak var rateView: AnimatableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTravlerName: UILabel!
    @IBOutlet weak var lblGstText: UILabel!
    @IBOutlet weak var collVwMain: UICollectionView!
    
    //MARK: - Variables
    lazy var objBusSearchVM = BusSearchViewModel()
    var markupDict: Markup?
    var busSeatNumDict = [Int]()
    var pathWayNumber = 0
    var seatNumer = Int()
    var viewModel = BusSeatViewModel()
    var bus = Bus()
    let popTip = PopTip()
    lazy var busDropping = BusBoarding()
    lazy var busBoarding = BusBoarding()
    lazy var selectedSeats = [BusSeat]()
    lazy var selectedSeatsUpper = [BusSeat]()
    lazy var souceName = ""
    lazy var destinationName = ""
    lazy var totalPrice = Double()
    lazy var totalSeats = Int()
    lazy var sBpId = String()
    lazy var priceArray = [String]()
    lazy var serviceDate = ""
    lazy var seatPrice = 0.0
    lazy var logID = 0
    var searchedParams = [String: Any]()
    var checkInDate = Date()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.collVwMain.delegate = self
        self.collVwMain.dataSource = self
        self.setupCollectionVIew()
        self.viewModel.delegate = self
        
        let params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_BUS_ID : bus.sBusId as AnyObject]
        
        //MARK: SET Boarding And Dropping
        if let dropping = self.bus.sBusDroppingArr.first{
            self.busDropping = dropping
        }
        if let boarding = self.bus.sBusBoardingArr.first{
            self.busBoarding = boarding
        }
        
        self.sBpId = self.busBoarding.sBpId
        self.lblBoarding.text = self.busBoarding.sLandmark
        self.lblDropping.text = self.busDropping.sLandmark
        self.lblTravlerName.text = self.bus.sTravels
        self.lblLocation.text = "\(self.souceName) - \(self.destinationName)"
        self.lblTime.text = "\(getTimeString(time:self.bus.sDepartureTime)) - \(getTimeString(time:self.bus.sArrivalTime))"
        self.lblDate.text = self.serviceDate
        
        self.viewModel.callApiSeat(param: params,view: self)
        
        if let vc = ViewControllerHelper.getViewController(ofType: .BoardingDroppingVC, StoryboardName: .Bus) as? BoardingDroppingVC {
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            vc.bus = self.bus
            vc.delegate = self
            vc.isBoarding = true
            vc.busDropping = self.busDropping
            vc.busBoarding = self.busBoarding
            self.present(vc, animated: true)
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    override func viewWillDisappear(_ animated: Bool) {
        hideSideMenu()
    }
    //MARK: - Custom methods
    func setupCollectionVIew(){
        
        self.priceCollection.delegate = self
        self.priceCollection.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.priceCollection.collectionViewLayout = layout
        self.priceCollection.ragisterNib(nibName: "PriceXIB")
    }
    //MARK: - @IBActions
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
    @IBAction func actionChooseAnotherFare(_ sender: UIButton) {
        LoaderClass.shared.isFareScreen = true
        self.objBusSearchVM.searchBus(param: searchedParams, view: self, souceName: souceName, destinationName: destinationName, checkinDate: checkInDate, date: searchedParams[WSRequestParams.WS_REQS_PARAM_JOURNEY_DATE] as! String)
    }
    @IBAction func actionCancellationPolicy(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .BusCancellationPolicyVC, StoryboardName: .Bus) as? BusCancellationPolicyVC {
            vc.bus = bus
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func legendOnPress(_ sender: UIButton) {
        self.showSideMenu()
    }
    
    @IBAction func boardingOnPress(_ sender: UIButton) {
        
        if let vc = ViewControllerHelper.getViewController(ofType: .BoardingDroppingVC, StoryboardName: .Bus) as? BoardingDroppingVC{
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            vc.bus = self.bus
            vc.delegate = self
            vc.busDropping = self.busDropping
            vc.busBoarding = self.busBoarding
            vc.isBoarding = true
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func droppingOnPress(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .BoardingDroppingVC, StoryboardName: .Bus) as? BoardingDroppingVC {
            
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            vc.bus = self.bus
            vc.delegate = self
            vc.isBoarding = false
            vc.busDropping = self.busDropping
            vc.busBoarding = self.busBoarding
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func nextOnPress(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .ConfirmBusBookingVC, StoryboardName: .Bus) as? ConfirmBusBookingVC {
            vc.date = self.lblDate.text ?? ""
            vc.time = self.lblTime.text ?? ""
            vc.souceName = self.souceName
            vc.destinationName = self.destinationName
            vc.price = self.totalPrice
            vc.totalSeats = self.totalSeats
            vc.busSeat = self.selectedSeats + self.selectedSeatsUpper
            vc.sBpId = self.sBpId
            vc.bus = self.bus
            vc.searchedParams = searchedParams
            vc.checkInDate = checkInDate
            vc.logID = "\(self.logID)"
            vc.travellerName = self.bus.sTravels
            self.pushView(vc: vc)
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension BusSeatVC: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension BusSeatVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func didFinishSelectingData(_ selectedSeatCount: [BusSeat], cvc: String) {
        var markUpPrice = Double()
        if cvc == "lower" {
            selectedSeats = selectedSeatCount
        } else {
            selectedSeatsUpper = selectedSeatCount
        }
        self.lblTotalSeat.text = ((self.selectedSeats.count) + (self.selectedSeatsUpper.count)) == 1 ? "FOR \((self.selectedSeats.count) + (self.selectedSeatsUpper.count)) SEAT" : "FOR \((self.selectedSeats.count) + (self.selectedSeatsUpper.count)) SEATS"
        self.totalSeats = (self.selectedSeats.count) + (self.selectedSeatsUpper.count)
        let calculate = String(self.selectedSeats.map{$0.sFare}.reduce(0.0, +))
        let calculateUpper = String(self.selectedSeatsUpper.map{$0.sFare}.reduce(0.0, +))
        
        for i in self.selectedSeats {
            if let markup = self.markupDict {
                if markup.amountBy == Strings.PERCENT {
                    let price = (i.sFare * (markup.amountOrPercent) / 100)
                    let fee = (markup.amountOrPercent * 18)/100
                    markUpPrice += (fee + price)
                } else {
                    var price = Double()
                    price += (markup.amountOrPercent)
                    let fee = (markup.amountOrPercent * 18)/100
                    markUpPrice += (fee + price)
                }
            }
        }

        for i in self.selectedSeatsUpper {
            if let markup = self.markupDict {
                if markup.amountBy == Strings.PERCENT {
                    let price = (i.sFare * (markup.amountOrPercent) / 100)
                    let fee = (markup.amountOrPercent * 18)/100
                    markUpPrice += (fee + price)
                } else {
                    var price = Double()
                    price += (markup.amountOrPercent)
                    let fee = (markup.amountOrPercent * 18)/100
                    markUpPrice += (fee + price)
                }
            }
        }
        
        //self.lblGstText.text = "(+ ₹\(String(format: "%.2f", markUpPrice)) incl. of GST & Taxes)"
        self.lblGstText.text = "(+ ₹75 Convenience fee + 18% GST)"
        self.totalPrice = (Double(calculate) ?? 0.0) + (Double(calculateUpper) ?? 0.0) + 88.5
        self.lblTotalPrice.text = "₹ \(String(format: "%.2f", (Double(calculate) ?? 0.0) + (Double(calculateUpper) ?? 0.0)))"
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            if ((self.selectedSeats.count) + (self.selectedSeatsUpper.count)) > 0{
                self.priceViewHeight.constant = 60
            }else{
                self.priceViewHeight.constant = 0
            }
                self.view.layoutIfNeeded()
            })
            self.collVwMain.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collVwMain {
            return self.viewModel.seatsUpper.count == 0 ? 1 : 2
        } else {
            return self.priceArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.priceCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriceXIB", for: indexPath) as! PriceXIB
            let index = self.priceArray[indexPath.item]
            cell.lblPrice.text = "₹\(index)"
            if "\(self.seatPrice)" == "All" {
                cell.backView.backgroundColor = .customPink()
                cell.lblPrice.textColor = .white
            }
            else if Double(index) ?? 0 == self.seatPrice {
                cell.backView.backgroundColor = .customPink()
                cell.lblPrice.textColor = .white
                
            } else {
                cell.lblPrice.textColor = .customPink()
                cell.backView.backgroundColor = .customLightRedColor()
            }
            return cell
        } else {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LowerBerthCVC", for: indexPath) as! LowerBerthCVC
                cell.delegate = self
                cell.lblLowerBerth.isHidden = self.viewModel.seatsUpper.count == 0
                cell.reloadData((self.viewModel.columnsOfSeats.last ?? 0), numberOfRows: self.viewModel.rowsOfSeats.count, arrSeats: self.viewModel.seatsLower.reversed(), seatPrice: self.seatPrice, upperSeats: selectedSeatsUpper.count, totalSeats: Int(self.bus.sMaxSeatsPerTicket) ?? 0, selectedSeats: selectedSeats, view: self)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpperBerthCVC", for: indexPath) as! UpperBerthCVC
                cell.delegate = self
                cell.reloadData((self.viewModel.columnsOfSeatsUpper.last ?? 0), numberOfRows: viewModel.rowsOfSeatsUpper.count, arrSeats: self.viewModel.seatsUpper.reversed(), seatPrice: self.seatPrice, lowerSeats: selectedSeats.count, totalSeats: Int(self.bus.sMaxSeatsPerTicket) ?? 0, selectedSeatsUpper: selectedSeatsUpper, view: self)
                return cell
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.priceCollection{
            return CGSize(width: Int(self.priceCollection.frame.width) / 4, height: 30)
        }else{
            return CGSize(width: self.viewModel.seatsUpper.count == 0 ? self.collVwMain.frame.width : self.collVwMain.frame.width-60, height: self.collVwMain.frame.height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.section,indexPath.row)
        
        DispatchQueue.main.async {
            if collectionView == self.priceCollection {
                let indexData = self.priceArray[indexPath.item]
                self.seatPrice = Double(indexData) ?? 0
                self.priceCollection.reloadData()
                self.collVwMain.reloadData()
            }
        }
    }
}

extension BusSeatVC:ResponseProtocol,selectedBoarding{
    
    func selectedBoarding(_ boarding: BusBoarding, _ dropping: BusBoarding) {
        self.lblBoarding.text = boarding.sLandmark
        self.lblDropping.text = dropping.sLandmark
        
        self.busDropping = dropping
        self.busBoarding = boarding
        
        self.sBpId = boarding.sBpId
    }
    
    func onSuccess() {
        DispatchQueue.main.async {
            self.view.updateConstraintsIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
               
                //MARK: Check Price
                let upperPrice = self.viewModel.seatsUpper.map{"\($0.sFare)"}
                let lowerPrice = self.viewModel.seatsLower.map{"\($0.sFare)"}
                let priceArray = Array(Set(lowerPrice + upperPrice))
                self.priceArray = priceArray.filter({$0 != "0.0"})
                self.priceArray.insert("All", at: 0)
                self.collVwMain.reloadData()
                self.priceCollection.reloadData()
            }
        }
    }
}
