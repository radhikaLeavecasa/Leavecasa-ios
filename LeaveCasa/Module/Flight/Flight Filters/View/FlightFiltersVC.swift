//
//  FlightFiltersVC.swift
//  LeaveCasa
//
//  Created by acme on 03/11/22.
//

import UIKit
import IBAnimatable

enum SortType {
    case isCheapest
    case isDurationSort
    case isLateDeparture
    case isEarlyDeparture
    case isNoSort
}

protocol isFilter {
    func filterFlight(nonStop: Bool, nonStop2: Bool, oneStop: Bool, oneStop2: Bool, isCheapestFirst: SortType, isCheapestFirst2: SortType, airlineCode: [String], airlineCode2: [String], isRefund: String, isRefund2: String, returnNonStop: Bool, returnNonStop2: Bool, returnOneStop: Bool, returnOneStop2: Bool)
}

class FlightFiltersVC: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnApply: AnimatableButton!
    @IBOutlet weak var btnReset: UIButton!
    //MARK: Sort Filter
    @IBOutlet weak var btnEarlyDeparture: AnimatableButton!
    @IBOutlet weak var btnLateDepartureOnPress: AnimatableButton!
    @IBOutlet weak var btnDurationSort: AnimatableButton!
    @IBOutlet weak var btnPriceChepest: AnimatableButton!
    @IBOutlet weak var chepestPriceView: AnimatableView!
    @IBOutlet weak var durationSortView: AnimatableView!
    @IBOutlet weak var lateDepartureView: AnimatableView!
    @IBOutlet weak var earlyDepartureView: AnimatableView!
    
    //MARK: Stops Filter
    @IBOutlet weak var lblNonStop: UILabel!
    @IBOutlet weak var lblZero: UILabel!
    @IBOutlet weak var btnZeroStops: UIButton!
    @IBOutlet weak var zeroStopView: AnimatableView!
    @IBOutlet weak var oneStopView: AnimatableView!
    @IBOutlet weak var lblOneStop: UILabel!
    @IBOutlet weak var lblOne: UILabel!
    @IBOutlet weak var btnOneStop: UIButton!
    @IBOutlet weak var imgNonRefund: UIImageView!
    @IBOutlet weak var imgRefund: UIImageView!
    
    //MARK: - Out Bound
    @IBOutlet weak var tableViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var vwOutBound: UIView!
    @IBOutlet weak var tablView2: UITableView!
    @IBOutlet var btnInboundOutbound: [AnimatableButton]!
    
    @IBOutlet weak var btnEarlyDeparture2: AnimatableButton!
    @IBOutlet weak var btnLateDepartureOnPress2: AnimatableButton!
    @IBOutlet weak var btnDurationSort2: AnimatableButton!
    @IBOutlet weak var btnPriceChepest2: AnimatableButton!
    @IBOutlet weak var chepestPriceView2: AnimatableView!
    @IBOutlet weak var durationSortView2: AnimatableView!
    @IBOutlet weak var lateDepartureView2: AnimatableView!
    @IBOutlet weak var earlyDepartureView2: AnimatableView!
    
    @IBOutlet weak var lblNonStop2: UILabel!
    @IBOutlet weak var lblZero2: UILabel!
    @IBOutlet weak var btnZeroStops2: UIButton!
    @IBOutlet weak var zeroStopView2: AnimatableView!
    @IBOutlet weak var oneStopView2: AnimatableView!
    @IBOutlet weak var lblOneStop2: UILabel!
    @IBOutlet weak var lblOne2: UILabel!
    @IBOutlet weak var btnOneStop2: UIButton!
    @IBOutlet weak var imgNonRefund2: UIImageView!
    @IBOutlet weak var imgRefund2: UIImageView!
    
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var inBoundOutboundStack: UIStackView!
    //MARK: - Variables
    var delegate: isFilter?
    var flights = [[Flight]]()
    
    var nonStop = false
    var oneStop = false
    var returnNonStop = false
    var returnOneStop = false
    var isCheapest: SortType? = .isNoSort
    var selectedAirline = [String]()
    var isReturn = false
    var isDomestic = false
    var isRefund = ""
    
    var nonStop2 = false
    var oneStop2 = false
    var returnNonStop2 = false
    var returnOneStop2 = false
    var isCheapest2: SortType? = .isNoSort
    var selectedAirline2 = [String]()
    var isReturn2 = false
    var isDomestic2 = false
    var isRefund2 = ""
    
    var flightsDict = [[String : String]]()
    var selectedTag = 0
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.setupTableView()
        self.filterData()
        if title == "Domestic Round" {
            actionInOutBound(btnInboundOutbound[0])
            stackViewHeight.constant = 40
            inBoundOutboundStack.isHidden = false
        } else {
            stackViewHeight.constant = 0
            inBoundOutboundStack.isHidden = true
        }
    }
    
    //MARK: - Custom methods
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.ragisterNib(nibName: AirlinesXIB().identifire)
        self.tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
        
        self.tablView2.tableFooterView = UIView()
        self.tablView2.ragisterNib(nibName: AirlinesXIB().identifire)
        self.tablView2.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
    }
    
    //MARK: Add Observer For TableView Height
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Strings.CONTENT_SIZE {
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                DispatchQueue.main.async {
                    self.tableViewHeight.constant = newsize.height
                    self.tableViewHeight2.constant = newsize.height
                }
            }
        }
    }
    //MARK: - @IBActions
    
    @IBAction func actionReset(_ sender: UIButton) {
        btnReset.isSelected = true
        self.unsortFunctionSetup(view: self.durationSortView, sender: self.btnDurationSort)
        self.unsortFunctionSetup(view: self.earlyDepartureView, sender: self.btnEarlyDeparture)
        self.unsortFunctionSetup(view: self.lateDepartureView, sender: self.btnLateDepartureOnPress)
        self.unsortFunctionSetup(view: self.chepestPriceView, sender: self.btnPriceChepest)
        
        self.unsortFunctionSetup2(view: self.durationSortView2, sender: self.btnDurationSort2)
        self.unsortFunctionSetup2(view: self.earlyDepartureView2, sender: self.btnEarlyDeparture2)
        self.unsortFunctionSetup2(view: self.lateDepartureView2, sender: self.btnLateDepartureOnPress2)
        self.unsortFunctionSetup2(view: self.chepestPriceView2, sender: self.btnPriceChepest2)
        
        self.oneStopView.borderWidth = 0
        self.oneStopView.borderColor = .clear
        self.lblOne.textColor = .theamColor()
        self.lblOneStop.textColor = .theamColor()
        self.oneStop = false
        
        self.oneStopView2.borderWidth = 0
        self.oneStopView2.borderColor = .clear
        self.lblOne2.textColor = .theamColor()
        self.lblOneStop2.textColor = .theamColor()
        self.oneStop2 = false
        
        self.zeroStopView.borderWidth = 0
        self.zeroStopView.borderColor = .clear
        self.lblZero.textColor = .theamColor()
        self.lblNonStop.textColor = .theamColor()
        self.nonStop = false
        
        self.zeroStopView2.borderWidth = 0
        self.zeroStopView2.borderColor = .clear
        self.lblZero2.textColor = .theamColor()
        self.lblNonStop2.textColor = .theamColor()
        self.nonStop2 = false
        
        self.isCheapest = .none
        self.imgNonRefund.image = .uncheckMark()
        self.imgRefund.image = .uncheckMark()
        isRefund = ""
        
        self.isCheapest2 = .none
        self.imgNonRefund2.image = .uncheckMark()
        self.imgRefund2.image = .uncheckMark()
        isRefund2 = ""
        
        self.selectedAirline = []
        self.selectedAirline2 = []
        tableView.reloadData()
    }
    
    @IBAction func refundOnPress(_ sender: UIButton) {
        self.imgRefund.image = .checkMark()
        self.imgNonRefund.image = .uncheckMark()
        self.isRefund = "1"
    }
    
    @IBAction func refundOnPress2(_ sender: UIButton) {
        self.imgRefund2.image = .checkMark()
        self.imgNonRefund2.image = .uncheckMark()
        self.isRefund2 = "1"
    }
    
    @IBAction func nonRefundOnPress(_ sender: UIButton) {
        self.imgNonRefund.image = .checkMark()
        self.imgRefund.image = .uncheckMark()
        self.isRefund = "0"
    }
    
    @IBAction func nonRefundOnPress2(_ sender: UIButton) {
        self.imgNonRefund2.image = .checkMark()
        self.imgRefund2.image = .uncheckMark()
        self.isRefund2 = "0"
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        if let del = self.delegate {
            del.filterFlight(nonStop: self.nonStop, nonStop2: self.nonStop2, oneStop: self.oneStop, oneStop2: self.oneStop2, isCheapestFirst: self.isCheapest ?? .isNoSort, isCheapestFirst2: self.isCheapest2 ?? .isNoSort, airlineCode: self.selectedAirline, airlineCode2: self.selectedAirline2, isRefund: self.isRefund, isRefund2: self.isRefund2, returnNonStop: self.returnNonStop, returnNonStop2: self.returnNonStop2, returnOneStop: self.returnOneStop, returnOneStop2: self.returnOneStop2)
            
            self.popView()
            LoaderClass.shared.showSnackBar(message: "Filter applied successfully!")
        }
    }
    
    @IBAction func priceChepestOnPress(_ sender: UIButton) {
        self.sortFunctionSetup(view: self.chepestPriceView, sender: sender)
        self.unsortFunctionSetup(view: self.durationSortView, sender: self.btnDurationSort)
        self.unsortFunctionSetup(view: self.earlyDepartureView, sender: self.btnEarlyDeparture)
        self.unsortFunctionSetup(view: self.lateDepartureView, sender: self.btnLateDepartureOnPress)
        self.isCheapest = .isCheapest
    }
    @IBAction func priceChepestOnPress2(_ sender: UIButton) {
        self.sortFunctionSetup2(view: self.chepestPriceView2, sender: sender)
        self.unsortFunctionSetup2(view: self.durationSortView2, sender: self.btnDurationSort2)
        self.unsortFunctionSetup2(view: self.earlyDepartureView2, sender: self.btnEarlyDeparture2)
        self.unsortFunctionSetup2(view: self.lateDepartureView2, sender: self.btnLateDepartureOnPress2)
        self.isCheapest2 = .isCheapest
    }
    
    @IBAction func durationSortOnPress(_ sender: UIButton) {
        self.sortFunctionSetup(view: self.durationSortView, sender: sender)
        self.unsortFunctionSetup(view: self.chepestPriceView, sender: self.btnPriceChepest)
        self.unsortFunctionSetup(view: self.earlyDepartureView, sender: self.btnEarlyDeparture)
        self.unsortFunctionSetup(view: self.lateDepartureView, sender: self.btnLateDepartureOnPress)
        self.isCheapest = .isDurationSort
    }
    @IBAction func durationSortOnPress2(_ sender: UIButton) {
        self.sortFunctionSetup2(view: self.durationSortView2, sender: sender)
        self.unsortFunctionSetup2(view: self.chepestPriceView2, sender: self.btnPriceChepest2)
        self.unsortFunctionSetup2(view: self.earlyDepartureView2, sender: self.btnEarlyDeparture2)
        self.unsortFunctionSetup2(view: self.lateDepartureView2, sender: self.btnLateDepartureOnPress2)
        self.isCheapest2 = .isDurationSort
    }
    
    @IBAction func lateDepartureOnPress(_ sender: UIButton) {
        self.sortFunctionSetup(view: self.lateDepartureView, sender: sender)
        self.unsortFunctionSetup(view: self.chepestPriceView, sender: self.btnPriceChepest)
        self.unsortFunctionSetup(view: self.earlyDepartureView, sender: self.btnEarlyDeparture)
        self.unsortFunctionSetup(view: self.durationSortView, sender: self.btnDurationSort)
        self.isCheapest = .isEarlyDeparture
    }
    @IBAction func lateDepartureOnPress2(_ sender: UIButton) {
        self.sortFunctionSetup2(view: self.lateDepartureView2, sender: sender)
        self.unsortFunctionSetup2(view: self.chepestPriceView2, sender: self.btnPriceChepest2)
        self.unsortFunctionSetup2(view: self.earlyDepartureView2, sender: self.btnEarlyDeparture2)
        self.unsortFunctionSetup2(view: self.durationSortView2, sender: self.btnDurationSort2)
        self.isCheapest = .isEarlyDeparture
    }
    
    @IBAction func earlyDepartureOnPress(_ sender: UIButton) {
        self.sortFunctionSetup(view: self.earlyDepartureView, sender: sender)
        self.unsortFunctionSetup(view: self.chepestPriceView, sender: self.btnPriceChepest)
        self.unsortFunctionSetup(view: self.lateDepartureView, sender: self.btnLateDepartureOnPress)
        self.unsortFunctionSetup(view: self.durationSortView, sender: self.btnDurationSort)
        self.isCheapest = .isLateDeparture
    }
    @IBAction func earlyDepartureOnPress2(_ sender: UIButton) {
        self.sortFunctionSetup(view: self.earlyDepartureView2, sender: sender)
        self.unsortFunctionSetup(view: self.chepestPriceView2, sender: self.btnPriceChepest2)
        self.unsortFunctionSetup(view: self.lateDepartureView2, sender: self.btnLateDepartureOnPress2)
        self.unsortFunctionSetup(view: self.durationSortView2, sender: self.btnDurationSort2)
        self.isCheapest2 = .isLateDeparture
    }
    
    @IBAction func oneStopOnPress(_ sender: UIButton) {
        self.setupOneStop(sender: sender)
    }
    @IBAction func oneStopOnPress2(_ sender: UIButton) {
        self.setupOneStop2(sender: sender)
    }
    
    @IBAction func zeroStopOnPress(_ sender: UIButton) {
        self.setupZeroStop(sender: sender)
    }
    @IBAction func zeroStopOnPress2(_ sender: UIButton) {
        self.setupZeroStop2(sender: sender)
    }
    
    @IBAction func twoStopOnPress(_ sender: UIButton) {
        //self.setupTwoStop(sender: sender)
    }
    
    @IBAction func applyOnPress(_ sender: UIButton) {
        if let del = self.delegate {
            del.filterFlight(nonStop: self.nonStop, nonStop2: self.nonStop2, oneStop: self.oneStop, oneStop2: self.oneStop2, isCheapestFirst: self.isCheapest ?? .isNoSort, isCheapestFirst2: self.isCheapest2 ?? .isNoSort, airlineCode: self.selectedAirline, airlineCode2: self.selectedAirline2, isRefund: self.isRefund, isRefund2: self.isRefund2, returnNonStop: self.returnNonStop, returnNonStop2: self.returnNonStop2, returnOneStop: self.returnOneStop, returnOneStop2: self.returnOneStop2)
            self.popView()
            LoaderClass.shared.showSnackBar(message: "Filter applied successfully!")
        }
    }
    @IBAction func actionInOutBound(_ sender: UIButton) {
        
        for btn in btnInboundOutbound {
            if btn.tag == sender.tag {
                btn.backgroundColor = .lightBlue()
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = .boldFont(size: 16)
            } else {
                btn.backgroundColor = .clear
                btn.setTitleColor(.black, for: .normal)
                btn.titleLabel?.font = .boldFont(size: 14)
            }
        }
        if sender.tag == 0 {
            vwOutBound.isHidden = true
            self.btnInboundOutbound[0].isSelected = true
            self.btnInboundOutbound[1].isSelected = false
        } else if sender.tag == 1 {
            vwOutBound.isHidden = false
            self.btnInboundOutbound[1].isSelected = true
            self.btnInboundOutbound[0].isSelected = false
        }
        tableView.reloadData()
        tablView2.reloadData()
    }
}
// MARK: - UITABLEVIEW METHODS
extension FlightFiltersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.flightsDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AirlinesXIB().identifire, for: indexPath) as! AirlinesXIB
        
        let indexData = self.flightsDict[indexPath.row]["code"]
        cell.imgAirlines.image = UIImage.init(named: indexData ?? "") == nil ? .placeHolder() : UIImage.init(named: indexData ?? "")
        if self.flightsDict.count > 0 {
            cell.lblAirline.text = self.flightsDict[indexPath.row]["name"]
        }
        if tableView == self.tableView {
            cell.imgCheck.image = self.selectedAirline.contains(indexData ?? "") ? .checkMark() : .uncheckMark()
        } else {
            cell.imgCheck.image = self.selectedAirline2.contains(indexData ?? "") ? .checkMark() : .uncheckMark()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexData = self.flightsDict[indexPath.row]["code"]
        if tableView == self.tableView {
            if self.selectedAirline.contains(indexData ?? "") {
                let index = self.selectedAirline.firstIndex(of: indexData ?? "") ?? 0
                self.selectedAirline.remove(at: index)
            } else {
                self.selectedAirline.append(indexData ?? "")
            }
        } else {
            if self.selectedAirline2.contains(indexData ?? "") {
                let index = self.selectedAirline2.firstIndex(of: indexData ?? "") ?? 0
                self.selectedAirline2.remove(at: index)
            } else {
                self.selectedAirline2.append(indexData ?? "")
            }
        }
        self.tableView.reloadData()
        self.tablView2.reloadData()
    }
}

// MARK: - UIBUTTON ACTION
extension FlightFiltersVC {
    func setupPriceChepest(sender: UIButton) {
        self.setBorder(sender: self.btnPriceChepest)
        self.desetBorder(sender: self.btnDurationSort)
        self.desetBorder(sender: self.btnLateDepartureOnPress)
        self.desetBorder(sender: self.btnEarlyDeparture)
    }
    
    func setupDurationSort(sender: UIButton) {
        self.setBorder(sender: self.btnDurationSort)
        self.desetBorder(sender: self.btnPriceChepest)
        self.desetBorder(sender: self.btnLateDepartureOnPress)
        self.desetBorder(sender: self.btnEarlyDeparture)
    }
    
    func setupLateDeparture(sender: UIButton) {
        self.setBorder(sender: self.btnLateDepartureOnPress)
        self.desetBorder(sender: self.btnPriceChepest)
        self.desetBorder(sender: self.btnDurationSort)
        self.desetBorder(sender: self.btnEarlyDeparture)
    }
    
    func setupEarlyDeparture(sender: UIButton) {
        self.setBorder(sender: self.btnEarlyDeparture)
        self.desetBorder(sender: self.btnPriceChepest)
        self.desetBorder(sender: self.btnLateDepartureOnPress)
        self.desetBorder(sender: self.btnDurationSort)
    }
    
    func setupZeroStop(sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.zeroStopView.borderWidth = 1
            self.zeroStopView.borderColor = .cutomRedColor()
            self.lblZero.textColor = .cutomRedColor()
            self.lblNonStop.textColor = .cutomRedColor()
            self.nonStop = true
        } else {
            sender.isSelected = false
            self.zeroStopView.borderWidth = 0
            self.zeroStopView.borderColor = .clear
            self.lblZero.textColor = .theamColor()
            self.lblNonStop.textColor = .theamColor()
            self.nonStop = false
        }
    }
    
    func setupZeroStop2(sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.zeroStopView2.borderWidth = 1
            self.zeroStopView2.borderColor = .cutomRedColor()
            self.lblZero2.textColor = .cutomRedColor()
            self.lblNonStop2.textColor = .cutomRedColor()
            self.nonStop2 = true
        } else {
            sender.isSelected = false
            self.zeroStopView2.borderWidth = 0
            self.zeroStopView2.borderColor = .clear
            self.lblZero2.textColor = .theamColor()
            self.lblNonStop2.textColor = .theamColor()
            self.nonStop2 = false
        }
    }
    
    func setupOneStop(sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.oneStopView.borderWidth = 1
            self.oneStopView.borderColor = .cutomRedColor()
            self.lblOne.textColor = .cutomRedColor()
            self.lblOneStop.textColor = .cutomRedColor()
            self.oneStop = true
        } else {
            sender.isSelected = false
            self.oneStopView.borderWidth = 0
            self.oneStopView.borderColor = .clear
            self.lblOne.textColor = .theamColor()
            self.lblOneStop.textColor = .theamColor()
            self.oneStop = false
        }
    }
    
    func setupOneStop2(sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.oneStopView2.borderWidth = 1
            self.oneStopView2.borderColor = .cutomRedColor()
            self.lblOne2.textColor = .cutomRedColor()
            self.lblOneStop2.textColor = .cutomRedColor()
            self.oneStop2 = true
        } else {
            sender.isSelected = false
            self.oneStopView2.borderWidth = 0
            self.oneStopView2.borderColor = .clear
            self.lblOne2.textColor = .theamColor()
            self.lblOneStop2.textColor = .theamColor()
            self.oneStop2 = false
        }
    }
    
    //MARK: Create Funtion
    func setBorder(sender:AnimatableButton) {
        sender.borderColor = .cutomRedColor()
        sender.borderWidth = 1
        sender.setTitleColor(.cutomRedColor(), for: .normal)
        sender.titleLabel?.font = UIFont.boldFont(size: 15.0)
    }
    
    func desetBorder(sender:AnimatableButton) {
        sender.borderColor = .clear
        sender.borderWidth = 1
        sender.setTitleColor(.theamColor(), for: .normal)
        sender.titleLabel?.font = UIFont.regularFont(size: 15.0)
    }
    
    
    func sortFunctionSetup(view:AnimatableView,sender:UIButton) {
        sender.setTitleColor(.cutomRedColor(), for: .normal)
        sender.titleLabel?.font = UIFont.regularFont(size: 15.0)
        view.borderColor = .cutomRedColor()
        view.borderWidth = 1
        view.backgroundColor = .white
    }
    
    func sortFunctionSetup2(view:AnimatableView,sender:UIButton) {
        sender.setTitleColor(.cutomRedColor(), for: .normal)
        sender.titleLabel?.font = UIFont.regularFont(size: 15.0)
        view.borderColor = .cutomRedColor()
        view.borderWidth = 1
        view.backgroundColor = .white
    }
    
    func unsortFunctionSetup(view:AnimatableView,sender:UIButton) {
        sender.setTitleColor(.theamColor(), for: .normal)
        sender.titleLabel?.font = UIFont.regularFont(size: 15.0)
        view.borderColor = .clear
        view.borderWidth = 1
        view.backgroundColor = .customGrayDateTimeColor()
    }
    
    func unsortFunctionSetup2(view:AnimatableView,sender:UIButton) {
        sender.setTitleColor(.theamColor(), for: .normal)
        sender.titleLabel?.font = UIFont.regularFont(size: 15.0)
        view.borderColor = .clear
        view.borderWidth = 1
        view.backgroundColor = .customGrayDateTimeColor()
    }
    func filterData(){
        if isRefund == "1" {
            self.imgRefund.image = .checkMark()
            self.imgNonRefund.image = .uncheckMark()
        } else if isRefund == "0" {
            self.imgNonRefund.image = .checkMark()
            self.imgRefund.image = .uncheckMark()
        }
        
        if isRefund2 == "1" {
            self.imgRefund2.image = .checkMark()
            self.imgNonRefund2.image = .uncheckMark()
        } else if isRefund2 == "0" {
            self.imgNonRefund2.image = .checkMark()
            self.imgRefund2.image = .uncheckMark()
        }
        
        if nonStop == true && oneStop == true {
            btnZeroStops.isSelected = false
            setupZeroStop(sender: btnZeroStops)
            btnOneStop.isSelected = false
            setupOneStop(sender: btnOneStop)
        } else if nonStop == true {
            btnZeroStops.isSelected = false
            setupZeroStop(sender: btnZeroStops)
        } else if oneStop == true {
            btnOneStop.isSelected = false
            setupOneStop(sender: btnOneStop)
        }
        
        if nonStop2 == true && oneStop2 == true {
            btnZeroStops2.isSelected = false
            setupZeroStop2(sender: btnZeroStops2)
            btnOneStop2.isSelected = false
            setupOneStop2(sender: btnOneStop2)
        } else if nonStop2 == true {
            btnZeroStops2.isSelected = false
            setupZeroStop2(sender: btnZeroStops2)
        } else if oneStop2 == true {
            btnOneStop2.isSelected = false
            setupOneStop2(sender: btnOneStop2)
        }
        
        switch isCheapest {
        case .isCheapest:
            self.sortFunctionSetup(view: self.chepestPriceView, sender: btnPriceChepest)
        case .isDurationSort:
            self.sortFunctionSetup(view: self.durationSortView, sender: btnDurationSort)
        case .isEarlyDeparture:
            self.sortFunctionSetup(view: self.lateDepartureView, sender: btnLateDepartureOnPress)
        case .isLateDeparture:
            self.sortFunctionSetup(view: self.earlyDepartureView, sender: btnEarlyDeparture)
        default:
            break
        }
        
        
        switch isCheapest2 {
        case .isCheapest:
            self.sortFunctionSetup2(view: self.chepestPriceView2, sender: btnPriceChepest2)
        case .isDurationSort:
            self.sortFunctionSetup2(view: self.durationSortView2, sender: btnDurationSort2)
        case .isEarlyDeparture:
            self.sortFunctionSetup2(view: self.lateDepartureView2, sender: btnLateDepartureOnPress2)
        case .isLateDeparture:
            self.sortFunctionSetup2(view: self.earlyDepartureView2, sender: btnEarlyDeparture2)
        default:
            break
        }
        
    }
}
