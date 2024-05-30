//
//  SearchHotelVC.swift
//  LeaveCasa
//
//  Created by acme on 09/09/22.
//

import UIKit
import SearchTextField
import DropDown
import AdvancedPageControl
import SDWebImage

class SearchHotelVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var tblVwRooms: UITableView!
    @IBOutlet weak var imgTop: UIImageView!
    @IBOutlet weak var hotelName: UIView!
    @IBOutlet weak var txtCity: SearchTextField!
    @IBOutlet weak var txtCheckIn: UITextField!
    @IBOutlet weak var txtCheckOut: UITextField!
    @IBOutlet weak var tblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var childrenStack: UIStackView!
    @IBOutlet weak var btnAddRoom: UIButton!
    @IBOutlet weak var pageControle: AdvancedPageControlView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    //MARK: - Variables
    var checkinDate = Date()
    var checkoutDate = Date()
    var isFromCheckin = true
    var tblVwCount = 1
    //MARK: Recheck Hotel Availablity
    var isFromHotelDetails = false
    var checkInHotelDate = ""
    var checkOutHotelDate = ""
    
    lazy var cityCode = [String]()
    lazy var cityName = [String]()
    lazy var cityCodeStr = Int()
    var numberOfRooms = 1
    var numberOfAdults = 1
    var numberOfChildren = 0
    var ageOfChildren: [Int] = []
    var finalRooms = [[String: AnyObject]]()
    var isFromRecommended = false
    var selectedIndex = 0
    //var delegate : HotelDetails?
    var paramCheckHotel = [[String:Any]]()
    var section = 0
    
    var viewModel = SearchViewModel()
    var previouslyAddedCity = String()
    var below12Count = 0
    var below6Count = 0
    var numberOfChild = 12
    var totalChild12 = 0
    var totalChild6 = 0
    var hotelData = [HotelRoomDetail]()
    var couponsData: [CouponData]?
    var imagesUrl = [URL]()
    
    var isFirstTime = true
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.scrollView.delegate = self
        self.txtCity.isUserInteractionEnabled = previouslyAddedCity == ""
        self.txtCity.text = previouslyAddedCity
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
        
        self.setupView()
        
        self.viewModel.searchHotelCity(city: "",view: self)
        
        
        var data = HotelRoomDetail()
        data.adults = 1
        data.children = 0
        data.childOne = 0
        data.childTwo = 0
        self.hotelData.append(data)
        
    }
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tblVwHeight?.constant = self.tblVwRooms.contentSize.height + 30
    }
    
    //MARK: - Custom methos
    func setupView(){
        self.childrenStack.isHidden = true
        self.setDates()
        hotelName.isHidden = title != "withCity"
        //MARK: UITextFeild Delegate
        self.txtCheckIn.delegate = self
        self.txtCheckOut.delegate = self
        self.viewModel.delegate = self
        self.txtCity.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
    }
    
    //MARK: - Custom methods
    func setDates() {
        if self.isFromHotelDetails == true{
            self.txtCheckIn.text = self.checkInHotelDate
            self.txtCheckOut.text = self.checkOutHotelDate
            self.hotelName.isHidden = title != "withCity"
            self.imgTop.isHidden = true
        }else{
            checkinDate = Date()
            checkoutDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            txtCheckIn.text = setCheckInDate()
            txtCheckOut.text = setCheckOutDate()
        }
    }
    
//    func openDateCalendar() {
//        if let calendar = UIStoryboard.init(name: ViewControllerType.WWCalendarTimeSelector.rawValue, bundle: nil).instantiateInitialViewController() as? WWCalendarTimeSelector {
//            calendar.delegate = self
//            calendar.optionCurrentDate = isFromCheckin ? checkinDate : checkoutDate
//            calendar.optionStyles.showDateMonth(true)
//            calendar.optionStyles.showMonth(false)
//            calendar.optionStyles.showYear(true)
//            calendar.optionStyles.showTime(false)
//            calendar.optionButtonShowCancel = true
//            present(calendar, animated: true, completion: nil)
//        }
//    }
    //MARK: - @IBActions
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
    
    @IBAction func actionAddRooms(_ sender: Any) {
        if tblVwCount < 4 {
            tblVwCount = tblVwCount + 1
            var data = HotelRoomDetail()
            data.adults = 1
            data.children = 0
            data.childOne = 0
            data.childTwo = 0
            self.hotelData.append(data)
            btnAddRoom.isHidden = tblVwCount == 4
            tblVwRooms.reloadData()
        }
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
}

// MARK: - WWCALENDARTIMESELECTOR DELEGATE
extension SearchHotelVC: WWCalendarTimeSelectorProtocol {
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        if isFromCheckin {
            checkinDate = date
            checkoutDate = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? Date()
            txtCheckIn.text = convertDate(date)
            txtCheckOut.text = nextCheckOutDate("yyyy-MM-dd",date)
        } else {
            checkoutDate = date
            txtCheckOut.text = convertDate(date)
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
        } else {
            return true
        }
    }
}

// MARK: - UITEXTFIELD DELEGATE
extension SearchHotelVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
//        if textField == txtCity && currentText?.count == 3 {
//            self.viewModel.searchHotelCity(city: currentText ?? "",view: self)
//        }
         if textField == txtCity {
            self.setupSearchTextField(self.viewModel.cityName)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtCity {
            return true
        }
        else if textField == txtCheckIn || textField == txtCheckOut {
            if let vc = ViewControllerHelper.getViewController(ofType: .CalendarPopUpVC, StoryboardName: .Hotels) as? CalendarPopUpVC{
                vc.firstDate = returnDate(txtCheckIn.text ?? "", strFormat: "yyyy-MM-dd")
                vc.lastDate = returnDate(txtCheckOut.text ?? "", strFormat: "yyyy-MM-dd")
                
                vc.doneCompletion = {
                    firstDate, lastDate in
                    self.txtCheckIn.text = firstDate
                    self.txtCheckOut.text = lastDate
                }
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            }
            return false
        } else {
            return false
        }
    }
}


// MARK: - UIBUTTON ACTION
extension SearchHotelVC {
    
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        if self.isFromRecommended == true{
            self.dismiss(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func searchCity(_ sender: UITextField) {
        if self.cityName.count > 0 {
            self.cityName.removeAll()
        }
        
        if self.cityCode.count > 0 {
            self.cityCode.removeAll()
        }
        
//        if isFirstTime { //!(sender.text?.isEmpty ?? true) &&
//            self.viewModel.satchCity(city: "",view: self)
//            isFirstTime = false
//        }
    }
    
    @IBAction func searchClicked(_ sender: UIButton) {
        
        if txtCity.text?.isEmpty ?? true || cityCodeStr == 0 {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.CITY)
        } else {
            self.finalRooms.removeAll()
            self.ageOfChildren.removeAll()
            var params: [String: AnyObject] = [:]
            
            for i in 0..<self.tblVwCount{
                if self.hotelData[i].children == 1 {
                    self.ageOfChildren.append(self.hotelData[i].childOne)
                } else if self.hotelData[i].children == 2 {
                    self.ageOfChildren.append(self.hotelData[i].childOne)
                    self.ageOfChildren.append(self.hotelData[i].childTwo)
                }
                params[WSRequestParams.WS_REQS_PARAM_ADULTS] = self.hotelData[i].adults as AnyObject
                params[WSRequestParams.WS_REQS_PARAM_CHILDREN_AGES] = self.ageOfChildren as AnyObject
                self.finalRooms.append(params)
                self.ageOfChildren = []
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                LoaderClass.shared.loadAnimation()
                self.viewModel.fetchHotelsByCity(cityCodeStr: "\(self.cityCodeStr)", txtCheckIn: self.txtCheckIn.text ?? "", txtCheckOut: self.txtCheckOut.text ?? "", finalRooms: self.finalRooms, view: self, numberOfRooms: self.tblVwCount, numberOfAdults: self.numberOfAdults, ageOfChildren: self.ageOfChildren, cityName:self.txtCity.text ?? "", hotelData: self.hotelData)
            })
        }
    }
}

extension SearchHotelVC:ResponseProtocol{
    
    func onSuccess() {
        self.setupSearchTextField(self.viewModel.cityName)
    }
    
    //MARK: Setup Search Textfeild
    func setupSearchTextField(_ searchedCities: [String]) {
        txtCity.theme = SearchTextFieldTheme.lightTheme()
        txtCity.theme.font = .systemFont(ofSize: 12)
        txtCity.theme.bgColor = UIColor.white
        txtCity.theme.fontColor = UIColor.black
        txtCity.theme.cellHeight = 40
        txtCity.filterStrings(searchedCities)
        txtCity.isFilter = true
        txtCity.itemSelectionHandler = { filteredResults, itemPosition in
            if filteredResults.count > 0 {
                let item = filteredResults[itemPosition]
                self.txtCity.text = item.title
                self.viewModel.dict.forEach({ val in
                    if val["City"] as! String == item.title {
                        self.cityCodeStr = val["code"] as? Int ?? 0
                        return
                    }
                })
                self.txtCity.resignFirstResponder()
            }
        }
    }
}

extension SearchHotelVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tblVwCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomsTVC") as! RoomsTVC
        cell.lblRoom.tag = indexPath.row
        cell.lblAdults.tag = indexPath.row
        cell.lblChildren.tag = indexPath.row
        cell.lblChildOne.tag = indexPath.row
        cell.btnDelete.isHidden = indexPath.row != hotelData.count - 1 || indexPath.row == 0
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(actionDelete), for: .touchUpInside)
        btnAddRoom.isHidden = tblVwCount == 4
        if hotelData.count > 0 {
            
            cell.vwChildrenSection.isHidden = hotelData[indexPath.row].children == 0
            cell.vwChildTwo.isHidden = hotelData[indexPath.row].children == 1 || hotelData[indexPath.row].children == 0
            cell.vwChildOne.isHidden = hotelData[indexPath.row].children == 0
            cell.lblAdults.text = "\(hotelData[indexPath.row].adults)"
            cell.lblChildOne.text = "\(hotelData[indexPath.row].childOne)"
            cell.lblChildTwo.text = "\(hotelData[indexPath.row].childTwo)"
            cell.lblChildren.text = "\(hotelData[indexPath.row].children)"
        }
        cell.lblRoom.text = "ROOM \(indexPath.row+1)"
        cell.btnPlusMinusChild[0].accessibilityIdentifier = "\(indexPath.row) 44"
        cell.btnPlusMinusChild[1].accessibilityIdentifier = "\(indexPath.row) 444"
        cell.btnPlusMinusAdults[0].accessibilityIdentifier = "\(indexPath.row) 55"
        cell.btnPlusMinusAdults[1].accessibilityIdentifier = "\(indexPath.row) 555"
        cell.btnPlusMinusChildOne[0].accessibilityIdentifier = "\(indexPath.row) 66"
        cell.btnPlusMinusChildOne[1].accessibilityIdentifier = "\(indexPath.row) 666"
        cell.btnPlusMinusChildTwo[0].accessibilityIdentifier = "\(indexPath.row) 77"
        cell.btnPlusMinusChildTwo[1].accessibilityIdentifier = "\(indexPath.row) 777"
        cell.btnPlusMinusChild[0].addTarget(self, action: #selector(actionAddChild), for: .touchUpInside)
        cell.btnPlusMinusChild[1].addTarget(self, action: #selector(actionAddChild), for: .touchUpInside)
        cell.btnPlusMinusAdults[0].addTarget(self, action: #selector(actionAddAdults), for: .touchUpInside)
        cell.btnPlusMinusAdults[1].addTarget(self, action: #selector(actionAddAdults), for: .touchUpInside)
        cell.btnPlusMinusChildOne[0].addTarget(self, action: #selector(actionAddChildOne), for: .touchUpInside)
        cell.btnPlusMinusChildOne[1].addTarget(self, action: #selector(actionAddChildOne), for: .touchUpInside)
        cell.btnPlusMinusChildTwo[0].addTarget(self, action: #selector(actionAddChildTwo), for: .touchUpInside)
        cell.btnPlusMinusChildTwo[1].addTarget(self, action: #selector(actionAddChildTwo), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return hotelData[indexPath.row].children == 0 ? 150 : hotelData[indexPath.row].children == 1 ? 190 : 225
    }
    
    @objc func actionAddChild(_ sender: UIButton) {
        let cell = tblVwRooms.cellForRow(at: IndexPath(row: Int(sender.accessibilityIdentifier!.components(separatedBy: " ")[0]) ?? 0, section: 0)) as! RoomsTVC
        var noOfChildren = Int(cell.lblChildren.text ?? "0")
        if sender.accessibilityIdentifier!.contains("444") {
            if noOfChildren! >= 0 && noOfChildren != 2 {
                noOfChildren = noOfChildren! + 1
                cell.lblChildren.text = "\(noOfChildren ?? 0)"
            }
        } else {
            if noOfChildren! >= 1 {
                noOfChildren = noOfChildren! - 1
                cell.lblChildren.text = "\(noOfChildren ?? 0)"
            }
        }
        cell.vwChildrenSection.isHidden = noOfChildren ?? 0 == 0
        cell.vwChildTwo.isHidden = noOfChildren == 1
        hotelData[Int(sender.accessibilityIdentifier!.components(separatedBy: " ")[0]) ?? 0].children = noOfChildren ?? 0
        tblVwRooms.reloadData()
    }
    @objc func actionAddAdults(_ sender: UIButton) {
        let cell = tblVwRooms.cellForRow(at: IndexPath(row: Int(sender.accessibilityIdentifier!.components(separatedBy: " ")[0]) ?? 0, section: 0)) as! RoomsTVC
        var noOFAdults = Int(cell.lblAdults.text ?? "0")
        if sender.accessibilityIdentifier!.contains("555") {
            if noOFAdults! >= 1 && noOFAdults != 12{
                noOFAdults = noOFAdults! + 1
                cell.lblAdults.text = "\(noOFAdults ?? 0)"
            }
        } else {
            if noOFAdults! > 1 {
                noOFAdults = noOFAdults! - 1
                cell.lblAdults.text = "\(noOFAdults ?? 0)"
            }
        }
        hotelData[Int(sender.accessibilityIdentifier!.components(separatedBy: " ")[0]) ?? 0].adults = noOFAdults ?? 0
    }
    @objc func actionAddChildOne(_ sender: UIButton) {
        let cell = tblVwRooms.cellForRow(at: IndexPath(row: Int(sender.accessibilityIdentifier!.components(separatedBy: " ")[0]) ?? 0, section: 0)) as! RoomsTVC
        var ageChildOne = Int(cell.lblChildOne.text ?? "0")
        if sender.accessibilityIdentifier!.contains("666") {
            if ageChildOne! >= 0 && ageChildOne != 12{
                ageChildOne = ageChildOne! + 1
                cell.lblChildOne.text = "\(ageChildOne ?? 0)"
            }
        } else {
            if ageChildOne! >= 1 {
                ageChildOne = ageChildOne! - 1
                cell.lblChildOne.text = "\(ageChildOne ?? 0)"
            }
        }
        hotelData[Int(sender.accessibilityIdentifier!.components(separatedBy: " ")[0]) ?? 0].childOne = ageChildOne ?? 0
        
        
    }
    @objc func actionAddChildTwo(_ sender: UIButton) {
        let cell = tblVwRooms.cellForRow(at: IndexPath(row: Int(sender.accessibilityIdentifier!.components(separatedBy: " ")[0]) ?? 0, section: 0)) as! RoomsTVC
        var ageChildTwo = Int(cell.lblChildTwo.text ?? "0")
        if sender.accessibilityIdentifier!.contains("777") {
            if ageChildTwo! >= 0 && ageChildTwo != 12{
                ageChildTwo = ageChildTwo! + 1
                cell.lblChildTwo.text = "\(ageChildTwo ?? 0)"
            }
        } else {
            if ageChildTwo! >= 1 {
                ageChildTwo = ageChildTwo! - 1
                cell.lblChildTwo.text = "\(ageChildTwo ?? 0)"
            }
        }
        hotelData[Int(sender.accessibilityIdentifier!.components(separatedBy: " ")[0]) ?? 0].childTwo = ageChildTwo ?? 0
    }
    
    @objc func actionDelete(_ sender: UIButton) {
        if tblVwCount != 1 {
            tblVwCount = tblVwCount - 1
            hotelData.removeLast()
        }
        btnAddRoom.isHidden = tblVwCount == 4
        tblVwRooms.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}
extension SearchHotelVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.couponsData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelImagesXIB().identifire, for: indexPath) as! HotelImagesXIB
        
        cell.imgHotel.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        cell.imgHotel.sd_setImage(with: URL(string: self.couponsData?[indexPath.row].imgUrl ?? ""), placeholderImage: .hotelplaceHolder())
        cell.imgHotel.cornerRadius = 15
        cell.imgShadow.isHidden = true
       
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: (self.collectionView.frame.size.height))
    }
}
