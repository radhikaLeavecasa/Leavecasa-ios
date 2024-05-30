//
//  SearchFlightVC.swift
//  LeaveCasa
//
//  Created by acme on 31/10/22.
//

import UIKit
import IBAnimatable
import DropDown
import SearchTextField
import AdvancedPageControl
import SDWebImage

class SearchFlightVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var mainDepartureDateView: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var returnDateView: UIView!
    @IBOutlet weak var btnInfants: UIButton!
    @IBOutlet weak var btnChildren: UIButton!
    @IBOutlet weak var btnAdult: UIButton!
    @IBOutlet weak var txtClass: UITextField!
    @IBOutlet weak var txtReturn: UITextField!
    @IBOutlet weak var txtDeparture: UITextField!
    @IBOutlet weak var btnMultiCity: AnimatableButton!
    @IBOutlet weak var btnRoundTrip: AnimatableButton!
    @IBOutlet weak var btnOnWay: AnimatableButton!
    @IBOutlet weak var btnReload: UIButton!
    @IBOutlet weak var txtToValue: SearchTextField!
    @IBOutlet weak var txtFrom: SearchTextField!
    @IBOutlet weak var lblAdults: UILabel!
    @IBOutlet weak var lblChild: UILabel!
    @IBOutlet weak var lblInfants: UILabel!
    @IBOutlet weak var pageControle: AdvancedPageControlView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgVwGif: UIImageView!
    //MARK: - Variables
    lazy var fromValue = ""
    lazy var toValue = ""
    var checkinDate = Date()
    var checkoutDate = Date()
    var isFromCheckin = true
    var dropDown = DropDown()
    var totalCity = 1
    var selectedTab = 0 // 0 - One way, 1 - Round Trip, 2 - mutli city
    var first = FlightStruct()
    var array = [FlightStruct]()
    lazy var cityCode = [String]()
    lazy var cityName = [String]()
    var viewModel = SearchFlightViewModel()
    var selectedTextFeild = SearchTextField()
    var selectedIndex = 0
    var fromSourceCode = ""
    var toSourceCode = ""
    var isOneStope = false
    var isDirect = false
    var PreferredAirlines = [String]()
    var classType = 1
    var adultCount = 1
    var childCount = 0
    var infantCount = 0
    var totalTravller = 1
    var couponsData: [CouponData]?
    var imagesUrl = [URL]()
    var params1: [String: Any] = [:]
    var sharedParam1: [String: Any] = [:]
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.viewModel.delegate = self
        self.txtDeparture.delegate = self
        self.txtReturn.delegate = self
        self.txtClass.delegate = self
        self.setDates()
        self.txtFrom.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
        self.txtToValue.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
        
        //MARK: Setup One Way
        self.setupOneWay()
        self.setupTableView()
        self.first.flightClass = GetData.share.getFlightClass()[first.flightClassIndex]
        self.checkinDate = Date()
        self.checkoutDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        self.first.fromDate = checkinDate
        self.first.toDate = checkoutDate
        self.first.from = self.setJournyDate(formate: DateFormat.monthDateYear)
        self.first.to = setCheckOutDate()
        
        self.array.append(first)
        
        self.scrollView.delegate = self
        self.pageControle.numberOfPages = self.couponsData?.count ?? 0
        self.collectionView.ragisterNib(nibName: HotelImagesXIB().identifire)
        //MARK: Setup PageIndicater
        self.pageControle.drawer = ScaleDrawer(numberOfPages: self.couponsData?.count ?? 0, height: 1, width: 1, space: 5, raduis: 1, currentItem: 0, indicatorColor: .white, dotsColor: .clear, isBordered: true, borderColor: .white, borderWidth: 1.0, indicatorBorderColor: .white, indicatorBorderWidth: 1.0)
        
        DispatchQueue.main.async {
            self.imagesUrl.removeAll()
            for index in self.couponsData ?? [] {
                if let url = URL(string: index.imgUrl ?? "") {
                    self.imagesUrl.append(url)
                }
            }
        }
        
        if LoaderClass.shared.isFareScreen {
            self.array = LoaderClass.shared.array
            txtFrom.text = "\(array[0].source)-\(array[0].sourceCode)"
            txtToValue.text = "\(array[0].destination)-\(array[0].destinationCode)"
            lblChild.text = LoaderClass.shared.params1["InfantCount"] as? String ?? "0"
            lblAdults.text = LoaderClass.shared.params1["AdultCount"] as? String ?? "0"
            lblChild.text = LoaderClass.shared.params1["ChildCount"] as? String ?? "0"
            txtClass.text = array[0].flightClass
            txtDeparture.text = array[0].from
        }
        
    }
  
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.tableView.layer.removeAllAnimations()
        self.tableViewHeight.constant = selectedTab == 2 ? self.tableView.contentSize.height : 120
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    //MARK: - Custom methods
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.ragisterNib(nibName: MultiCityAddXIB().identifire)
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
    }
    func setDates() {
        self.txtDeparture.text = setJournyDate(formate: DateFormat.monthDateYear)
        self.txtReturn.text = nextCheckOutDate(DateFormat.monthDateYear,Date())
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView{
            
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            
            let index = Int(round(offSet/width))
            print(index)
            self.pageControle.setPage(index)
            
        }
    }

    //MARK: - @IBActions
    @IBAction func multiCityOnPress(_ sender: UIButton) {
        tableView.isHidden = false
        self.tableViewHeight.constant = self.tableView.contentSize.height
        self.setupMultiCity()
    }
    @IBAction func actionDropDown(_ sender: Any) {
        self.txtClass.becomeFirstResponder()
    }
    
    @IBAction func roundTripOnPress(_ sender: UIButton) {
        tableView.isHidden = true
        self.tableViewHeight.constant = 120
        self.setupRoundTrip()
    }
    
    @IBAction func onWayOnPress(_ sender: UIButton) {
        tableView.isHidden = true
        self.tableViewHeight.constant = 120
        self.setupOneWay()
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        if LoaderClass.shared.isFareScreen {
            LoaderClass.shared.isFareScreen = true
            let vc = ViewControllerHelper.getViewController(ofType: .TabbarVC, StoryboardName: .Main) as! TabbarVC
            self.setView(vc: vc, animation: false)
        } else {
            self.popView()
        }
    }
    
    @IBAction func adultOnPress(_ sender: UIButton) {
        self.showShortDropDown(dataSource: GetData.share.getAdultChild(int: 1), button: sender,isButton: true)
    }
    
    @IBAction func adultsPlusOnPress(_ sender: UIButton) {
        if self.adultCount >= 1 &&  self.adultCount < 9 && self.totalTravller < 9{
            self.adultCount += 1
            self.totalTravller += 1
            self.lblAdults.text = "\(adultCount)"
        }
    }
    
    @IBAction func adultsMinusOnPress(_ sender: UIButton) {
        if self.adultCount >= 2{
            self.adultCount -= 1
            self.totalTravller -= 1
            self.lblAdults.text = "\(adultCount)"
        }
    }
    
    @IBAction func childPlusOnPress(_ sender: UIButton) {
        if self.childCount >= 0 &&  self.childCount < 9 && self.totalTravller < 9{
            self.childCount += 1
            self.totalTravller += 1
            self.lblChild.text = "\(childCount)"
        }
    }
    
    @IBAction func childMinusOnPress(_ sender: UIButton) {
        if self.childCount >= 1{
            self.childCount -= 1
            self.totalTravller -= 1
            self.lblChild.text = "\(childCount)"
        }
    }
    
    @IBAction func infantsPlusOnPress(_ sender: UIButton) {
        if self.infantCount >= 0 &&  self.infantCount < 9 && self.totalTravller < 9{
            self.infantCount += 1
            self.totalTravller += 1
            self.lblInfants.text = "\(infantCount)"
        }
    }
    
    @IBAction func infantsMinusOnPress(_ sender: UIButton) {
        if self.infantCount >= 1 {
            self.infantCount -= 1
            self.totalTravller -= 1
            self.lblInfants.text = "\(infantCount)"
        }
    }
    
    @IBAction func searchOnPress(_ sender: UIButton) {
        
        if self.isValid(tab: self.selectedTab){
            LoaderClass.shared.sourceSestination = "\(txtFrom.text?.components(separatedBy: " - ")[0] ?? "") - \(txtToValue.text?.components(separatedBy: " - ")[0] ?? "")"

            var params: [String: Any] = [:]
            var sharedParam: [String: Any] = [:]

            if self.selectedTab + 1 == 2 {
                UserDefaults.standard.setValue(true, forKey: CommonParam.ONE_WAY)
                UserDefaults.standard.setValue(false, forKey: CommonParam.Ownword)
            }else{
                UserDefaults.standard.setValue(false, forKey: CommonParam.ONE_WAY)
            }

            params[WSRequestParams.WS_REQS_PARAM_JOURNEY_TYPE] = "\(self.selectedTab + 1)"
            params[WSRequestParams.WS_REQS_PARAM_ADULTS_COUNT] = self.lblAdults.text ?? ""
            params[WSRequestParams.WS_REQS_PARAM_CHILD_COUNT] = self.lblChild.text ?? ""
            params[WSRequestParams.WS_REQS_PARAM_INFANT_COUNT] = self.lblInfants.text ?? ""
            params[WSRequestParams.WS_REQS_PARAM_DIRECT_FLIGHT] = "\(self.isDirect)"
            params[WSRequestParams.WS_REQS_PARAM_ONESTOP_FLIGHT] = "\(self.isOneStope)"
            params[WSRequestParams.WS_REQS_PARAM_PREF_AIRLINE] = self.PreferredAirlines

            sharedParam[WSRequestParams.WS_REQS_PARAM_JOURNEY_TYPE] = "\(self.selectedTab + 1)"

            var segment = [[String:Any]]()
            var dict = [String:Any]()

            segment.removeAll()

            if self.selectedTab == 0{
                dict[WSResponseParams.WS_RESP_PARAM_ORIGIN] = self.array[0].sourceCode
                dict[WSResponseParams.WS_RESP_PARAM_DESTINATION] = self.array[0].destinationCode
                dict[WSResponseParams.WS_RESP_PARAM_CABIN_CLASS] = "\(self.classType)"
                dict[WSResponseParams.WS_RESP_PARAM_DEPARTURE_TIME_NEW] =  "\(self.array[0].fromDate.convertStoredDate())T00:00:00"
                dict[WSResponseParams.WS_RESP_PARAM_PREFERRED_ARRIVAL_TIME] = "\(self.array[0].fromDate.convertStoredDate())T00:00:00"

                segment.append(dict)
            }else if self.selectedTab == 1{

                var oneWay = [String:Any]()
                var roundWay = [String:Any]()

                oneWay[WSResponseParams.WS_RESP_PARAM_ORIGIN] = self.array[0].sourceCode
                oneWay[WSResponseParams.WS_RESP_PARAM_DESTINATION] = self.array[0].destinationCode
                oneWay[WSResponseParams.WS_RESP_PARAM_CABIN_CLASS] = "\(self.classType)"
                oneWay[WSResponseParams.WS_RESP_PARAM_DEPARTURE_TIME_NEW] = "\(self.array[0].fromDate.convertStoredDate())T00:00:00"
                oneWay[WSResponseParams.WS_RESP_PARAM_PREFERRED_ARRIVAL_TIME] = "\(self.array[0].fromDate.convertStoredDate())T00:00:00"

                roundWay[WSResponseParams.WS_RESP_PARAM_ORIGIN] = self.array[0].destinationCode
                roundWay[WSResponseParams.WS_RESP_PARAM_DESTINATION] = self.array[0].sourceCode
                roundWay[WSResponseParams.WS_RESP_PARAM_CABIN_CLASS] = "\(self.classType)"
                roundWay[WSResponseParams.WS_RESP_PARAM_DEPARTURE_TIME_NEW] = "\(self.array[0].toDate.convertStoredDate())T00:00:00"
                roundWay[WSResponseParams.WS_RESP_PARAM_PREFERRED_ARRIVAL_TIME] = "\(self.array[0].toDate.convertStoredDate())T00:00:00"

                segment.append(oneWay)
                segment.append(roundWay)

            }else{

                for (index) in self.array{
                    dict[WSResponseParams.WS_RESP_PARAM_ORIGIN] = index.sourceCode
                    dict[WSResponseParams.WS_RESP_PARAM_DESTINATION] = index.destinationCode
                    dict[WSResponseParams.WS_RESP_PARAM_CABIN_CLASS] = "\(self.classType)"
                    dict[WSResponseParams.WS_RESP_PARAM_DEPARTURE_TIME_NEW] = "\(index.fromDate.convertStoredDate())T00:00:00"
                    dict[WSResponseParams.WS_RESP_PARAM_PREFERRED_ARRIVAL_TIME] = "\(index.fromDate.convertStoredDate())T00:00:00"
                    segment.append(dict)
                }
            }

            params[WSResponseParams.WS_RESP_PARAM_SEGMENTS] = segment
            sharedParam[WSResponseParams.WS_RESP_PARAM_SEGMENTS] = segment
            LoaderClass.shared.isFareScreen = false
            LoaderClass.shared.array = self.array
            LoaderClass.shared.params1 = params
            //imgVwGif.isHidden = false
            LoaderClass.shared.setupGIF("search_flight", imgVW: imgVwGif)

            self.viewModel.searchFlight(param: params, selectedTab: self.selectedTab, array:self.array, sharedParam: sharedParam, view: self,couponData: couponsData ?? [])
        }
    }
    
    @IBAction func childOnPress(_ sender: UIButton) {
        self.showShortDropDown(dataSource: GetData.share.getAdultChild(int: 2), button: sender,isButton: true)
    }
    
    @IBAction func infantsOnPress(_ sender: UIButton) {
        self.showShortDropDown(dataSource: GetData.share.getAdultChild(int: 3), button: sender,isButton: true)
    }
    
    @IBAction func reloadOnPress(_ sender: UIButton) {
        self.btnReload.rotate()
        let c1 = self.array[0].sourceCode
        let c2 = self.array[0].destinationCode
        
        self.array[0].destinationCode = c1
        self.array[0].sourceCode = c2
        
        if self.fromValue == self.txtFrom.text {
            self.txtFrom.text  = self.toValue
            self.txtToValue.text  = self.fromValue
            self.fromValue = self.txtFrom.text ?? ""
            self.toValue = self.txtToValue.text ?? ""
        }else{
            self.txtToValue.text  = self.toValue
            self.txtFrom.text  = self.fromValue
            self.fromValue = self.txtFrom.text ?? ""
            self.toValue = self.txtToValue.text ?? ""
        }
    }
    
    func openDateCalendar(textFeild:UITextField) {
        DispatchQueue.main.async {
            self.txtFrom.resignFirstResponder()
            self.txtToValue.resignFirstResponder()
            self.view.endEditing(true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            if let calendar = UIStoryboard.init(name: ViewControllerType.WWCalendarTimeSelector.rawValue, bundle: nil).instantiateInitialViewController() as? WWCalendarTimeSelector {
                calendar.delegate = self
                if self.selectedTab == 2{
                    calendar.optionCurrentDate = self.array[textFeild.tag].fromDate
                }else{
                    if self.isFromCheckin {
                        calendar.optionCurrentDate = self.checkinDate
                    } else {
                        calendar.optionCurrentDate = self.checkoutDate
                    }
                }
                if self.selectedTab == 1 {
                    calendar.optionLayoutTopPanelHeight = 60
                    calendar.optionTopPanelTitle = self.isFromCheckin ? "Select Departure Date" : "Select Return Date"
                }
                calendar.optionShowTopPanel = true
                calendar.optionStyles.showDateMonth(true)
                calendar.optionStyles.showMonth(false)
                calendar.optionStyles.showYear(true)
                calendar.optionStyles.showTime(false)
                calendar.optionButtonShowCancel = true
                self.present(calendar, animated: true, completion: nil)
            }
        })
    }
    
    @objc func searchCity(_ sender: SearchTextField) {
        if self.cityName.count > 0 {
            self.cityName.removeAll()
        }

        if self.cityCode.count > 0 {
            self.cityCode.removeAll()
        }
        self.selectedTextFeild = sender

        self.viewModel.searchFlightApi(sender,view: self)
    }
}

extension SearchFlightVC{
    
    
    func isValid(tab:Int) -> Bool{
        
        for (_,item) in array.enumerated() {
            if self.selectedTab == 0 || self.selectedTab == 1{
                if self.array[0].source.isEmpty || self.array[0].sourceCode.isEmpty {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: AlertMessages.SELECT_FROM_CITY)
                    return false
                } else if self.array[0].destination.isEmpty || self.array[0].destinationCode.isEmpty {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: AlertMessages.SELECT_CITY)
                    return false
                } else if self.array[0].from.isEmpty {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: AlertMessages.SELECT_DEPARUTRE_DATE)
                    return false
                }
            }else{
                if item.source.isEmpty || item.sourceCode.isEmpty {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: AlertMessages.SELECT_FROM_CITY)
                    return false
                } else if item.destination.isEmpty || item.destinationCode.isEmpty {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: AlertMessages.SELECT_CITY)
                    return false
                } else if item.from.isEmpty {
                    pushNoInterConnection(view: self,titleMsg: "Alert", msg: AlertMessages.SELECT_DEPARUTRE_DATE)
                    return false
                }
            }
        }
        if self.txtClass.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: AlertMessages.Fill_All_FIELDS)
            return false
        }
        return true
    }
    
    func setupOneWay(){
        self.returnDateView.isHidden = true
        self.btnOnWay.backgroundColor = .lightBlue()
        self.btnOnWay.setTitleColor(.white, for: .normal)
        
        self.btnMultiCity.backgroundColor = .clear
        self.btnMultiCity.setTitleColor(.grayColor(), for: .normal)
        
        self.btnRoundTrip.backgroundColor = .clear
        self.btnRoundTrip.setTitleColor(.grayColor(), for: .normal)
        
        self.mainDepartureDateView.isHidden = false
        self.lineView.isHidden = false
        self.btnReload.isHidden = false
        self.tableView.isHidden = true
        self.totalCity = 1
        self.selectedTab = 0
        self.tableView.reloadData()
    }
    
    func setupRoundTrip(){
        self.returnDateView.isHidden = false
        self.btnRoundTrip.backgroundColor = .lightBlue()
        self.btnRoundTrip.setTitleColor(.white, for: .normal)
        self.btnMultiCity.backgroundColor = .clear
        self.btnMultiCity.setTitleColor(.grayColor(), for: .normal)
        self.btnOnWay.backgroundColor = .clear
        self.btnOnWay.setTitleColor(.grayColor(), for: .normal)
        
        self.mainDepartureDateView.isHidden = false
        self.lineView.isHidden = false
        
        self.tableView.isHidden = true
        self.totalCity = 1
        
        self.selectedTab = 1
        self.btnReload.isHidden = false
        
        self.tableView.reloadData()
    }
    
    func setupMultiCity(){
        
        self.btnMultiCity.backgroundColor = .lightBlue()
        self.btnMultiCity.setTitleColor(.white, for: .normal)
        self.btnOnWay.backgroundColor = .clear
        self.btnOnWay.setTitleColor(.grayColor(), for: .normal)
        
        self.btnRoundTrip.backgroundColor = .clear
        self.btnRoundTrip.setTitleColor(.grayColor(), for: .normal)
        
        self.mainDepartureDateView.isHidden = true
        self.lineView.isHidden = true
        self.tableView.isHidden = false
        self.totalCity = 1
        self.btnReload.isHidden = true
        self.selectedTab = 2
        
        self.tableView.reloadData()
    }
}

// MARK: - WWCALENDARTIMESELECTOR DELEGATE
extension SearchFlightVC: WWCalendarTimeSelectorProtocol {
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        DispatchQueue.main.async {
            self.txtDeparture.resignFirstResponder()
            self.txtReturn.resignFirstResponder()
        }
        
        if isFromCheckin {
            self.checkinDate = date
            self.checkoutDate = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? Date()
            self.txtDeparture.text = self.convertDateWithDateFormater(DateFormat.monthDateYear,date)
            self.txtReturn.text = self.nextCheckOutDate(DateFormat.monthDateYear,date)
            
            if self.selectedTab == 2 {
                self.array[selectedIndex].fromDate = date
                self.array[selectedIndex].from = self.convertDateWithDateFormater(DateFormat.monthDateYear,date)
            }else if self.selectedTab == 0{
                self.array[selectedIndex].fromDate = date
                self.array[selectedIndex].from = self.convertDateWithDateFormater(DateFormat.monthDateYear,date)
            }else{
                self.array[selectedIndex].fromDate = date
                self.array[selectedIndex].toDate = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? Date()
                self.array[selectedIndex].from = self.convertDateWithDateFormater(DateFormat.monthDateYear,date)
                self.array[selectedIndex].to = self.convertDateWithDateFormater(DateFormat.monthDateYear,Calendar.current.date(byAdding: .day, value: 1, to: date) ?? Date())
            }
            if selectedTab == 1 {
                isFromCheckin = false
                txtReturn.becomeFirstResponder()
            }
            self.tableView.reloadData()
        } else {
            self.checkoutDate = date
            self.txtReturn.text = self.convertDateWithDateFormater(DateFormat.monthDateYear,date)
            
            if self.selectedTab == 2 {
                self.array[selectedIndex].fromDate = date
                self.array[selectedIndex].from = self.convertDateWithDateFormater(DateFormat.monthDateYear,date)
            }else if self.selectedTab == 1 {
                self.array[selectedIndex].toDate = date
                self.array[selectedIndex].to = self.convertDateWithDateFormater(DateFormat.monthDateYear,date)
            }
        }
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        if date < Date() {
            return false
        } else if !isFromCheckin {
            if date < checkinDate {
                return false
            } else {
                return true
            }
        }else {
            return true
        }
    }
    
}

extension SearchFlightVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtDeparture{
            self.openDateCalendar(textFeild: textField)
            self.isFromCheckin = true
            return false
        } else if textField == self.txtReturn {
            self.isFromCheckin = false
            self.openDateCalendar(textFeild: textField)
            return false
        }
        return true
    }
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let row = textField.tag
        self.selectedIndex = row
        
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! MultiCityAddXIB
        
        if textField == self.txtDeparture{
            self.openDateCalendar(textFeild: textField)
            self.isFromCheckin = true
        }else if textField == self.txtReturn{
            self.isFromCheckin = false
            self.openDateCalendar(textFeild: textField)
        }else if textField == txtClass{
            self.showShortDropDown(view: textField, dataSource: GetData.share.getFlightClass())
        }else if textField == cell.txtDepartureDate {
            self.openDateCalendar(textFeild: textField)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtDeparture || textField == txtReturn {
            return false
        }
        return true
    }

    //MARK: Setup Search Textfeild
    
    func showShortDropDown(view:UITextField? = nil,dataSource:[String],button:UIButton? = nil,isButton:Bool? = false){
        if isButton == true{
            view?.resignFirstResponder()
            self.dropDown.anchorView = button?.plainView
            self.dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
            self.dropDown.dataSource = dataSource
            self.dropDown.cellHeight = 50
        }else{
            view?.resignFirstResponder()
            dropDown.anchorView = view?.plainView
            dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
            dropDown.dataSource = dataSource
            // Action triggered on selection
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                view?.text = item
                self.classType = index + 1
            }
        }
        dropDown.show()
    }
    
    @objc func closeOnPress(sender:UIButton){
        let index = sender.tag
        self.array.remove(at: index)
        self.tableView.reloadData()
    }
    
    @objc func addCityOnPress(sender:UIButton){
        if checkArrayValue() == false{
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: AlertMessages.PLEASE_FILL_ALL_DETAILS)
        }else{
            let index = sender.tag
            var obj = FlightStruct()
            
            let last = self.array[index]
            
            obj.source = last.destination
            obj.sourceCode = last.destinationCode
            obj.passengers = last.passengers
            obj.from = self.nextCheckOutDate(DateFormat.monthDateYear, last.fromDate)
            obj.fromDate = self.changeCurrentDateIntoNextDate(date: last.fromDate)
            obj.flightClass = last.flightClass
            obj.flightClassIndex = last.flightClassIndex
            
            self.array.append(obj) // add new city
            self.tableView.reloadData()
        }
    }
    
    func checkArrayValue() -> Bool{
        for index in self.array{
            if index.sourceCode.isEmpty || index.destinationCode.isEmpty {
                return false
            }
        }
        return true
    }
    
}

extension SearchFlightVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedTab <= 1 ? self.totalCity : self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MultiCityAddXIB().identifire, for: indexPath) as! MultiCityAddXIB
        
        let row = indexPath.row
        let items = self.array[row]
        
        cell.txtDepartureDate.delegate = self
        
        cell.txtFrom.isUserInteractionEnabled = true
        cell.txtTo.isUserInteractionEnabled = true
        cell.txtDepartureDate.isUserInteractionEnabled = true
        cell.btnAddCity.isUserInteractionEnabled = true
        
        cell.txtFrom.tag = indexPath.row
        cell.txtTo.tag = indexPath.row
        cell.txtDepartureDate.tag = indexPath.row
        
        cell.btnAddCity.tag = indexPath.row
        cell.btnAddCity.addTarget(self, action: #selector(self.addCityOnPress(sender:)), for: .touchUpInside)
        
        cell.btnClose.tag = indexPath.row
        cell.btnClose.addTarget(self, action: #selector(self.closeOnPress(sender:)), for: .touchUpInside)
        
        
        if self.array.count - 1 == indexPath.row && self.array.count != 5{
            cell.btnAddCity.isHidden = false
        }else{
            cell.btnAddCity.isHidden = true
        }
        
        if self.array.count != 1 && self.self.array.count - 1 == indexPath.row{
            cell.btnClose.isHidden = false
        }else{
            cell.btnClose.isHidden = true
        }
        
        if indexPath.row == 0{
            cell.txtFrom.isUserInteractionEnabled = true
        }else{
            cell.txtFrom.isUserInteractionEnabled = false
        }
        
        cell.txtFrom.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
        cell.txtTo.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
        
        cell.txtFrom.text = items.source
        cell.txtTo.text = items.destination
        cell.lblToCityCode.text = items.destinationCode
        cell.lblFromCityCode.text = items.sourceCode
        cell.txtDepartureDate.text = items.from
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SearchFlightVC:ResponseProtocol{
    
    func onSuccess() {
       // self.showShortDropDown(view: selectedTextFeild, dataSource: self.viewModel.cityName)
        self.setupSearchTextField(self.viewModel.cityName, self.viewModel.cityCode, textField: self.selectedTextFeild)
    }
    
    func apiReload() {
        self.pageControle.numberOfPages = self.couponsData?.count ?? 0
        self.pageControle.drawer = ScaleDrawer(numberOfPages: self.couponsData?.count ?? 0, height: 1, width: 1, space: 5, raduis: 1, currentItem: 0, indicatorColor: .white, dotsColor: .clear, isBordered: true, borderColor: .white, borderWidth: 1.0, indicatorBorderColor: .white, indicatorBorderWidth: 1.0)
        DispatchQueue.main.async {
            self.imagesUrl.removeAll()
            for index in self.couponsData ?? [] {
                if let url = URL(string: index.imgUrl ?? "") {
                    self.imagesUrl.append(url)
                }
            }
        }
        collectionView.reloadData()
    }
    
    func setupSearchTextField(_ searchedCities: [String], _ searchedCodes: [String], textField: SearchTextField) {
        DispatchQueue.main.async {
            var cities = [String]()
            
            let row = textField.tag
            
            let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! MultiCityAddXIB
            
            for i in 0..<searchedCities.count {
                cities.append("\(searchedCities[i]) - \(searchedCodes[i].uppercased())")
            }
            
            if textField == self.txtFrom {
                self.txtFrom.theme = SearchTextFieldTheme.lightTheme()
                self.txtFrom.theme.font = UIFont.systemFont(ofSize: 12)
                self.txtFrom.theme.bgColor = UIColor.white
                self.txtFrom.theme.fontColor = UIColor.theamColor()
                self.txtFrom.theme.cellHeight = 40
                self.txtFrom.filterStrings(cities)
                self.txtFrom.itemSelectionHandler = { filteredResults, itemPosition in
                  //  DispatchQueue.main.async {
                        textField.resignFirstResponder()
                        self.array[row].source = self.viewModel.cityName[itemPosition]
                        self.array[row].sourceCode = self.viewModel.cityCode[itemPosition]
                        self.txtFrom.text = "\(self.viewModel.cityName[itemPosition]) - \(self.viewModel.cityCode[itemPosition])"
                        self.fromValue = self.txtFrom.text ?? ""
                        self.fromSourceCode = self.viewModel.cityCode[itemPosition]
                        self.txtFrom.resignFirstResponder()
                        self.tableView.reloadData()
                  //  }
                }
            } else if textField == self.txtToValue {
                self.txtToValue.theme = SearchTextFieldTheme.lightTheme()
                self.txtToValue.theme.font = UIFont.systemFont(ofSize: 12)
                self.txtToValue.theme.bgColor = UIColor.white
                self.txtToValue.theme.fontColor = UIColor.theamColor()
                self.txtToValue.theme.cellHeight = 40
                self.txtToValue.filterStrings(cities)
                self.txtToValue.itemSelectionHandler = { filteredResults, itemPosition in
                   // DispatchQueue.main.async {
                        textField.resignFirstResponder()
                        self.array[row].destination = self.viewModel.cityName[itemPosition]
                        self.array[row].destinationCode = self.viewModel.cityCode[itemPosition]
                        if self.selectedTab == 2 && self.array.count > row + 1 {
                            self.array[row+1].source = self.viewModel.cityName[itemPosition]
                            self.array[row+1].sourceCode = self.viewModel.cityCode[itemPosition]
                        }
                        self.txtToValue.text = "\(self.viewModel.cityName[itemPosition]) - \(self.viewModel.cityCode[itemPosition])"
                        self.toValue = self.txtToValue.text ?? ""
                        self.toSourceCode = self.viewModel.cityCode[itemPosition]
                        self.txtToValue.resignFirstResponder()
                        self.tableView.reloadData()
                    //}
                }
            }else{
                if textField == cell.txtFrom {
                    cell.txtFrom.theme = SearchTextFieldTheme.lightTheme()
                    cell.txtFrom.theme.font = UIFont.systemFont(ofSize: 12)
                    cell.txtFrom.theme.bgColor = UIColor.white
                    cell.txtFrom.theme.fontColor = UIColor.theamColor()
                    cell.txtFrom.theme.cellHeight = 40
                    cell.txtFrom.filterStrings(cities)
                    cell.txtFrom.itemSelectionHandler = { filteredResults, itemPosition in
                        textField.resignFirstResponder()
                        self.array[row].source = self.viewModel.cityName[itemPosition]
                        self.array[row].sourceCode = self.viewModel.cityCode[itemPosition]
                        cell.txtFrom.resignFirstResponder()
                        self.tableView.reloadData()
                    }
                } else if textField == cell.txtTo {
                    cell.txtTo.theme = SearchTextFieldTheme.lightTheme()
                    cell.txtTo.theme.font = UIFont.systemFont(ofSize: 12)
                    cell.txtTo.theme.bgColor = UIColor.white
                    cell.txtTo.theme.fontColor = UIColor.theamColor()
                    cell.txtTo.theme.cellHeight = 40
                    cell.txtTo.filterStrings(cities)
                    cell.txtTo.itemSelectionHandler = { filteredResults, itemPosition in
                        textField.resignFirstResponder()
                        self.array[row].destination = self.viewModel.cityName[itemPosition]
                        self.array[row].destinationCode = self.viewModel.cityCode[itemPosition]
                        cell.txtTo.resignFirstResponder()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension SearchFlightVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.couponsData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelImagesXIB().identifire, for: indexPath) as! HotelImagesXIB
       // let dict = self.couponsData?[indexPath.row]
        
        cell.imgHotel.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        cell.imgHotel.sd_setImage(with: URL(string: self.couponsData?[indexPath.row].imgUrl ?? ""), placeholderImage: .hotelplaceHolder())
        cell.imgHotel.cornerRadius = 15
        cell.imgShadow.isHidden = true
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: (self.collectionView.frame.size.height))
    }
}
