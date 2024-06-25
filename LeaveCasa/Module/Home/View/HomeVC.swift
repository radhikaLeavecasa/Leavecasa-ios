//
//  HomeVC.swift
//  LeaveCasa
//
//  Created by acme on 08/09/22.
//

import UIKit
import IBAnimatable

enum HomeType{
    case Banner
    case Popurlar
}

class HomeVC: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var imgUser: AnimatableImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTime: UILabel!
    
    //MARK: - Variables
    var viewModel = HomeViewModel()
    var location = LocationService()
    var arrHeader = ["Explore Offers", "Packages", "Discover Top Places Of The Season", "Why book with LeaveCasa"]
    var selectedTag = 12
    var selectedTagOne = 11
    var selectedTagTwo = 13
    var couponData: [CouponData]?
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.imgUser.isUserInteractionEnabled = true
        self.imgUser.addGestureRecognizer(tap)
       // checkForUpdate()
        //MARK: GET PASSANGER LIST
        DispatchQueue.background(background: {
            self.viewModel.updateDeviceToken()
        }, completion:{
            
        })
        //MARK: GET COUPON LIST
        self.viewModel.callHomeCoupons(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lblTime.text = checkTime()
        self.imgUser.sd_setImage(with: URL(string: Cookies.userInfo()?.profile_pic ?? ""), placeholderImage: .placeHolderProfile())
    }
    //MARK: - Custom methods
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true {
            let vc = ViewControllerHelper.getViewController(ofType: .GuestLoginVC, StoryboardName: .Main) as! GuestLoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.tabBarController?.selectedIndex = 4
        }
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.ragisterNib(nibName: HomeHeaderXIB().identifire)
        tableView.register(UINib(nibName: "HomeHeaderNewXIB", bundle: nil), forHeaderFooterViewReuseIdentifier: "HomeHeaderNewXIB")
        tableView.ragisterNib(nibName: "HomeBannerXIB")
        LoaderClass.shared.loadAnimation()
        self.viewModel.delegate = self
        self.viewModel.getHomeData(city: "", type: "", lat: "", long: "",view: self)
    }
    
    @IBAction func hotelOnPress(sender:UIButton){
        LoaderClass.shared.isFareScreen = false
        if let vc = ViewControllerHelper.getViewController(ofType: .SearchHotelVC, StoryboardName: .Hotels) as? SearchHotelVC{
            vc.couponsData = self.viewModel.couponData?.filter({$0.category == "hotel"})
            self.pushView(vc: vc, title: "withCity")
        }
    }
    
    @IBAction func busOnPress(sender:UIButton){
        LoaderClass.shared.isFareScreen = false
        if let vc = ViewControllerHelper.getViewController(ofType: .BusSearchVC, StoryboardName: .Bus) as? BusSearchVC{
            vc.viewModel.couponsData = viewModel.couponData?.filter({$0.category == "bus"})
            self.pushView(vc: vc)
        }
    }
    
    @IBAction func flightOnPress(sender:UIButton){
        LoaderClass.shared.isFareScreen = false
        if let vc = ViewControllerHelper.getViewController(ofType: .SearchFlightVC, StoryboardName: .Flight) as? SearchFlightVC {
            vc.couponsData = viewModel.couponData?.filter({$0.category == "flight"})
            self.pushView(vc: vc)
        }
    }
    @IBAction func packageOnPress(_ sender: Any) {
        LoaderClass.shared.isFareScreen = false
        if let vc = ViewControllerHelper.getViewController(ofType: .PackagesVC, StoryboardName: .Main) as? PackagesVC {
            vc.imgPackage = viewModel.mainUrl ?? ""
            self.pushView(vc: vc)
        }
    }
    @IBAction func actionInsurance(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .InsuranceSearchVC, StoryboardName: .Main) as? InsuranceSearchVC {
            self.pushView(vc: vc)
        }
    }
    @IBAction func actionVisa(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .VisaDetailsVC, StoryboardName: .Visa) as? VisaDetailsVC {
            self.pushView(vc: vc)
        }
    }
}

extension HomeVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrHeader.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeBannerXIB().identifire, for: indexPath) as! HomeBannerXIB
        
        cell.tblVwHome.isHidden = indexPath.section != 4
        cell.collectionView.isHidden = indexPath.section == 4
        if indexPath.section != 4 || indexPath.section != 0 {
            cell.type = .Banner
            cell.view = self
            cell.logId = self.viewModel.logId
            cell.setupModelData(model: self.viewModel.modelData, homeCouponModel: self.couponData ?? [], index: indexPath.row, domesticArr: viewModel.arrDomestic ?? [], internationalArr: viewModel.arrInternational ?? [], section: indexPath.section, selectedTag: selectedTag, viewController: self, selectedTagOne: selectedTagOne, allCoupons: self.viewModel.couponData ?? [], domesticPackageArr: viewModel.arrPackageDomestic ?? [], internationalPackArr: viewModel.arrPackageInternational ?? [], selectedTagTwo: selectedTagTwo, mainUrl: viewModel.mainUrl ?? "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 0 : indexPath.section == 4 ? 192 : indexPath.section == 1 ? 190 : 180
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let view = tableView.dequeueReusableCell(withIdentifier: HomeHeaderXIB().identifire) as! HomeHeaderXIB
            return view
        } else {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeHeaderNewXIB().identifire) as! HomeHeaderNewXIB
            view.btnAllAndDomestic.titleLabel?.font = UIFont.regularFont(size: 13)
            if section == 1 {
                DispatchQueue.main.async {
                    view.lblFlightAndInternational.isHidden = self.selectedTagOne != section+20
                    view.lblAllAndDomestic.isHidden = self.selectedTagOne != section+10
                    view.btnFlightAndInternational.setTitleColor(self.selectedTagOne == section+20 ? UIColor(named: "APP_VIOLET") : .darkGray, for: .normal)
                    view.btnAllAndDomestic.setTitleColor(self.selectedTagOne == section+10 ? UIColor(named: "APP_VIOLET") : .darkGray, for: .normal)
                    view.actionBus.setTitleColor(self.selectedTagOne == section+30 ? UIColor(named: "APP_VIOLET") : .darkGray, for: .normal)
                    view.actionHotels.setTitleColor(self.selectedTagOne == section+40 ? UIColor(named: "APP_VIOLET") : .darkGray, for: .normal)
                    view.lblBus.isHidden = self.selectedTagOne != section+30
                    view.lblHotels.isHidden = self.selectedTagOne != section+40
                }
            } else if section == 2 || section == 3 {
                DispatchQueue.main.async {
                    view.lblFlightAndInternational.isHidden = self.selectedTag != section+20 && self.selectedTagTwo != section+20
                    view.lblAllAndDomestic.isHidden = self.selectedTag != section+10 && self.selectedTagTwo != section+10
                    view.btnFlightAndInternational.setTitleColor(self.selectedTag == section+20 || self.selectedTagTwo == section+20 ? UIColor(named: "APP_VIOLET") : .darkGray, for: .normal)
                    view.btnAllAndDomestic.setTitleColor(self.selectedTag == section+10 || self.selectedTagTwo == section+10 ? UIColor(named: "APP_VIOLET") : .darkGray, for: .normal)
                }
            }
            
            view.lblTitle.text = arrHeader[section-1]
            view.vwThree.isHidden = section == 2 || section == 3
            view.vwFour.isHidden = section == 2 || section == 3
            view.vwstack.isHidden = section == 4
            view.vwAllOne.isHidden = section == 4 || section == 2 || section == 3
            view.vwAllTwo.isHidden = section == 4 || section == 1
            view.constViewAllOneWidth.constant = section == 2 || section == 3 ? 0 : 80
            view.btnAllAndDomestic.setTitle(section == 1 ? "All" : "Domestic", for: .normal)
            view.btnFlightAndInternational.setTitle(section == 1 ? "Flights" : "International", for: .normal)
            view.constLeadingStackVw.constant = section == 1 ? 0 : 10
            view.btnAllAndDomestic.tag = section+10
            view.btnFlightAndInternational.tag = section+20
            view.actionBus.tag = section+30
            view.actionHotels.tag = section+40
            view.btnAllAndDomestic.addTarget(self, action: #selector(actionFlightAndDomestic), for: .touchUpInside)
            view.btnFlightAndInternational.addTarget(self, action: #selector(actionBusandInternational), for: .touchUpInside)
            view.actionBus.addTarget(self, action: #selector(actionHotel), for: .touchUpInside)
            view.actionHotels.addTarget(self, action: #selector(actionHotelss), for: .touchUpInside)
            view.vwAllOne.tag = section
            view.vwAllTwo.tag = section
            view.vwAllOne.addTarget(self, action: #selector(actionViewAll), for: .touchUpInside)
            view.vwAllTwo.addTarget(self, action: #selector(actionViewAll), for: .touchUpInside)
            return view
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 0 : section == 4 ? 45 : 70
    }
    
    @objc func actionFlightAndDomestic(_ sender: UIButton) {
        if sender.tag == 11 { //|| sender.tag == 21 || sender.tag == 31 || sender.tag == 41 {
            self.selectedTagOne = sender.tag
            self.couponData = self.viewModel.couponData //?.filter({$0.category == "flight"})
        } else if sender.tag == 12 {
            self.selectedTag = sender.tag
        } else {
            self.selectedTagTwo = sender.tag
        }
        self.tableView.reloadData()
    }
    
    @objc func actionBusandInternational(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
            if sender.tag == 21 {
                self.selectedTagOne = sender.tag
                self.couponData = self.viewModel.couponData?.filter({$0.category == "flight"})
            } else if sender.tag == 22 {
                self.selectedTag = sender.tag
            } else {
                self.selectedTagTwo = sender.tag
            }
            self.tableView.reloadData()
        })
    }
    @objc func actionHotel(_ sender: UIButton) {
        if sender.tag == 11 || sender.tag == 21 || sender.tag == 31 {
            self.selectedTagOne = sender.tag
            self.couponData = self.viewModel.couponData?.filter({$0.category == "bus"})
        } else {
            self.selectedTag = sender.tag
        }
        self.tableView.reloadData()
    }
    
    @objc func actionHotelss(_ sender: UIButton) {
        if sender.tag == 41 {
            self.selectedTagOne = sender.tag
            self.couponData = self.viewModel.couponData?.filter({$0.category == "hotel"})
        } else {
            self.selectedTag = sender.tag
        }
        self.tableView.reloadData()
    }
    
    @objc func actionViewAll(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: StoryboardName.Main.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DiscoverTopPlacesVC") as! DiscoverTopPlacesVC
        vc.couponData = self.viewModel.couponData
        vc.selectedSection = sender.tag
        if sender.tag == 1 {
            vc.selectedTag = selectedTagOne == 11 || selectedTagOne == 21 ? 0 : selectedTagOne == 31 || sender.tag == 41 ? 1 : 2
        } else if sender.tag == 2 {
            vc.selectedTag = selectedTag == 12 ? 0 : 1
        } else {
            vc.arrDomestic = self.viewModel.arrDomestic
            vc.arrInternational = self.viewModel.arrInternational
            vc.selectedTag = selectedTag == 13 ? 0 : 1
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC:ResponseProtocol{
    
    func onSuccess() {
        if self.isProfileComplete() == false && UserDefaults.standard.object(forKey: "isFirstTimeLaunch") as? Bool == true && UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false  {
            if let vc = ViewControllerHelper.getViewController(ofType: .CompleteProfilePopup, StoryboardName: .Main) as? CompleteProfilePopup{
                UserDefaults.standard.set(false, forKey: "isFirstTimeLaunch")
                UserDefaults.standard.synchronize()
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.yesTitle = AlertKeys.GO_TO_PROFILE
                vc.noTitle = AlertKeys.SKIP
                vc.tapCallback = {
                    if let vc = ViewControllerHelper.getViewController(ofType: .EditProfileVC, StoryboardName: .Main) as? EditProfileVC{
                        vc.hidesBottomBarWhenPushed = true
                        self.pushView(vc: vc)
                    }
                }
                self.present(vc, animated: true)
            }
        }
        couponData = viewModel.couponData //?.filter({$0.category == "flight"})
        self.tableView.reloadData()
    }
    
    func checkForUpdate() {
        let bundleInfo = Bundle.main.infoDictionary
        let identifier = bundleInfo?["CFBundleIdentifier"] as? String
        if let currentVersion =
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let storeURL = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier ?? "com.leavecasa.app")") {
            
            let request = URLRequest(url: storeURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let results = json["results"] as? [[String: Any]],
                           let latestVersion = results.first?["version"] as? String {
                            let vr = (Double(latestVersion) ?? 0)+0.01
                            if currentVersion.compare("\(vr)", options: .numeric) == .orderedAscending {
                                // An update is available
                                DispatchQueue.main.async {
                                    self.showAlertForUpdate()
                                }
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }
                }
            }
            
            task.resume()
        }
    }
    func showAlertForUpdate() {
        let alert = UIAlertController(title: "Update Available", message: "A new version of the app is available. Please update to the latest version.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Update Now", style: .default, handler: { action in
            if let appStoreURL = URL(string: "YOUR_APP_STORE_URL_HERE") {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
