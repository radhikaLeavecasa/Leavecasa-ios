//
//  BusSearchVC.swift
//  LeaveCasa
//
//  Created by acme on 22/09/22.
//

import UIKit
import IBAnimatable
import SearchTextField
import AdvancedPageControl
import SDWebImage

class BusSearchVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblLineTwo: UILabel!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtFrom: SearchTextField!
    @IBOutlet weak var txtDesination: SearchTextField!
    @IBOutlet weak var lblLineOne: UILabel!
    @IBOutlet weak var pageControle: AdvancedPageControlView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    //MARK: - Variables
    lazy var journyDate = Date()
    lazy var cityCode = [Int]()
    lazy var cityName = [String]()
    lazy var destinationCode = [String]()
    lazy var destinationName = [String]()
    lazy var searchedDestinationCode = [String]()
    lazy var searchedDestinationName = [String]()
    lazy var sourceCityCode = Int()
    lazy var destinationCityCode = Int()
    var titleStr = "Source"
    
    var imagesUrl = [URL]()
    //MARK: View Model object
    lazy var viewModel = BusSearchViewModel()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.scrollView.delegate = self
        self.pageControle.numberOfPages = self.viewModel.couponsData?.count ?? 0
        self.collectionView.ragisterNib(nibName: HotelImagesXIB().identifire)
        //MARK: Setup PageIndicater
        self.pageControle.drawer = ScaleDrawer(numberOfPages: self.viewModel.couponsData?.count ?? 0, height: 1, width: 1, space: 5, raduis: 1, currentItem: 0, indicatorColor: .white, dotsColor: .clear, isBordered: true, borderColor: .white, borderWidth: 1.0, indicatorBorderColor: .white, indicatorBorderWidth: 1.0)
        
        DispatchQueue.main.async {
            self.imagesUrl.removeAll()
            for index in self.viewModel.couponsData ?? [] {
                if let url = URL(string: index.imgUrl ?? "") {
                    self.imagesUrl.append(url)
                }
            }
        }
        self.setDates()
        self.textFeildDelegateSetup()
        self.viewModel.delegate = self
    }
    //MARK: - @IBActions
    @IBAction func actionSwapCities(_ sender: Any) {
        var temp = Int()
        temp = sourceCityCode
        sourceCityCode = destinationCityCode
        destinationCityCode = temp
        
        var tempCity = String()
        tempCity = txtFrom.text ?? ""
        txtFrom.text = txtDesination.text
        txtDesination.text = tempCity
    }
    
    @IBAction func searchOnPress(_ sender: UIButton) {
        LoaderClass.shared.sourceSestination = "\(txtFrom.text?.components(separatedBy: " - ")[0] ?? "") - \(txtDesination.text?.components(separatedBy: " - ")[0] ?? "")"
        view.endEditing(true)
        if self.txtFrom.text?.isEmpty ?? true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.LEAVING_LOCATION)
        } else if self.txtDesination.text?.isEmpty ?? true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.DESTINATION_LOCATION)
        } else {
            let params = [WSRequestParams.WS_REQS_PARAM_JOURNEY_DATE: self.txtDate.text ?? "",
                          WSRequestParams.WS_REQS_PARAM_BUS_FROM: sourceCityCode ,
                          WSRequestParams.WS_REQS_PARAM_BUS_TO: destinationCityCode] as [String : Any]
            self.viewModel.searchBus(param: params, view: self, souceName: self.txtFrom.text ?? "", destinationName: self.txtDesination.text ?? "", checkinDate: self.journyDate, date:self.txtDate.text ?? "")
        }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView{
            
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            
            let index = Int(round(offSet/width))
            print(index)
            self.pageControle.setPage(index)
            
        }
    }
    //MARK: - Custom methods
    func textFeildDelegateSetup(){
        self.txtDate.delegate = self
        self.txtFrom.delegate = self
        self.txtDesination.delegate = self
        
        self.txtFrom.addTarget(self, action: #selector(searchSourceCity(_:)), for: .editingChanged)
        self.txtDesination.addTarget(self, action: #selector(searchDestinationCity(_:)), for: .editingChanged)
        
    }
    func setDates() {
        self.journyDate = Date()
        self.txtDate.text = setJournyDate(formate: "E, dd MMM, yyyy")
    }
    
    @objc func searchSourceCity(_ sender: UITextField) {
        if self.cityName.count > 0 {
            self.cityName.removeAll()
        }
        
        if self.cityCode.count > 0 {
            self.cityCode.removeAll()
        }
        
        if !(sender.text?.isEmpty ?? true) {
            titleStr = "Source"
            self.viewModel.fatchFromCity(city: self.txtFrom.text ?? "", view: self)
        }
    }
    
    @objc func searchDestinationCity(_ sender: UITextField) {
        if self.cityName.count > 0 {
            self.cityName.removeAll()
        }
        
        if self.cityCode.count > 0 {
            self.cityCode.removeAll()
        }
        
        if (txtFrom.text?.isEmpty ?? false) {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: AlertMessages.SELECT_SOURCE_CITY)
            return
        }
        
        let city = sender.text ?? ""
        if !(city.isEmpty ) {
            if !(sender.text?.isEmpty ?? true) {
                titleStr = "Destination"
                self.viewModel.fatchFromCity(city: self.txtDesination.text ?? "",title: "Destination",txtfldFrom: txtFrom.text ?? "", txtCode: self.sourceCityCode, view: self)
            }
        }
        
        //            for (index, item) in self.viewModel.destinationName.enumerated() {
        //
        //                if item.lowercased().contains(city.lowercased()) {
        //                    searchedDestinationName.append(self.viewModel.destinationName[index])
//                    searchedDestinationCode.append(self.viewModel.destinationCode[index])
//                }
//            }
//        } else {
//            searchedDestinationCode = self.viewModel.destinationCode
//            searchedDestinationName = self.viewModel.destinationName
//        }
    }
    
    func setupSourceSearchTextField(_ searchedCities: [String]) {
        self.txtFrom.theme = SearchTextFieldTheme.lightTheme()
        self.txtFrom.theme.font = UIFont.regularFont(size: 12)
        self.txtFrom.theme.bgColor = UIColor.white
        self.txtFrom.theme.fontColor = UIColor.black
        self.txtFrom.theme.cellHeight = 40
        self.txtFrom.filterStrings(searchedCities)
        self.txtFrom.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.txtFrom.text = item.title
            for i in self.viewModel.sourceresult {
                if item.title == i[WSResponseParams.WS_RESP_PARAM_CITY_NAME] as? String ?? "" {
                    self.sourceCityCode = i[WSResponseParams.WS_RESP_PARAM_CITY_CODE] as? Int ?? 0
                }
            }
            self.txtFrom.resignFirstResponder()
            //self.viewModel.fetchDestinationCityList(cityCode: self.sourceCityCode)
        }
    }
    
    func setupDestinationSearchTextField(_ searchedCities: [String]) {
        txtDesination.theme = SearchTextFieldTheme.lightTheme()
        txtDesination.theme.font = UIFont.regularFont(size: 12)
        txtDesination.theme.bgColor = UIColor.white
        txtDesination.theme.fontColor = UIColor.black
        txtDesination.theme.cellHeight = 40
        txtDesination.filterStrings(searchedCities)
        txtDesination.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.txtDesination.text = item.title
            for i in self.viewModel.sourceresult {
                if item.title == i[WSResponseParams.WS_RESP_PARAM_CITY_NAME] as? String ?? ""{
                    self.destinationCityCode = i[WSResponseParams.WS_RESP_PARAM_CITY_CODE] as? Int ?? 0
                }
            }
            self.txtDesination.resignFirstResponder()
        }
    }
}

extension BusSearchVC{
    func openDateCalendar() {
        if let calendar = UIStoryboard.init(name: ViewControllerType.WWCalendarTimeSelector.rawValue, bundle: nil).instantiateInitialViewController() as? WWCalendarTimeSelector {
            calendar.delegate = self
            calendar.optionCurrentDate = journyDate
            calendar.optionStyles.showDateMonth(true)
            calendar.optionStyles.showMonth(false)
            calendar.optionStyles.showYear(true)
            calendar.optionStyles.showTime(false)
            calendar.optionButtonShowCancel = true
            present(calendar, animated: true, completion: nil)
        }
    }
}


extension BusSearchVC: WWCalendarTimeSelectorProtocol {
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        
        self.journyDate = date
        self.txtDate.text = self.convertDateWithDateFormater("E, dd MMM, yyyy",date)
        
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        if date < Date() {
            return false
        }else {
            return true
        }
    }
}

extension BusSearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        lblLineOne.backgroundColor = .lightGray
        lblLineTwo.backgroundColor = .lightGray
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.txtDate {
            openDateCalendar()
            return false
        } else if textField == txtFrom {
            lblLineOne.backgroundColor = .customPink()
            lblLineTwo.backgroundColor = .lightGray
            return true
        } else if textField == txtDesination {
            lblLineOne.backgroundColor = .lightGray
            lblLineTwo.backgroundColor = .customPink()
            return true
        } else {
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFrom {
            lblLineOne.backgroundColor = .lightGray
        } else if textField == txtDesination {
            lblLineTwo.backgroundColor = .lightGray
        }
    }
}

extension BusSearchVC:ResponseProtocol {
    func onSuccess() {
        if titleStr == "Source" {
            self.setupSourceSearchTextField(self.viewModel.cityName)
        } else {
            self.setupDestinationSearchTextField(self.viewModel.cityName)
        }
    }
}
extension BusSearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.couponsData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelImagesXIB().identifire, for: indexPath) as! HotelImagesXIB
        let dict = self.viewModel.couponsData?[indexPath.row]
        
        cell.imgHotel.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        cell.imgHotel.sd_setImage(with: URL(string: self.viewModel.couponsData?[indexPath.row].imgUrl ?? ""), placeholderImage: .hotelplaceHolder())
        cell.imgHotel.cornerRadius = 15
        cell.imgShadow.isHidden = true
      
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: (self.collectionView.frame.size.height))
    }
}
