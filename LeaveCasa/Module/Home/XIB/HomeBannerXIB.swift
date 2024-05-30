//
//  HomeBannerXIB.swift
//  LeaveCasa
//
//  Created by acme on 08/09/22.
//

import UIKit
import SDWebImage

class HomeBannerXIB: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var tblVwHome: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK: - Variables
    var type : HomeType?
    var modelData = [Results]()
    var homeCouponData = [CouponData]()
    var identifire = "HomeBannerXIB"
    var logId = 0
    var view = UIViewController()
    var numberOfRooms = 1
    var numberOfAdults = 1
    var numberOfChild = 0
    var numberOfNights = 1
    var ageOfChildren: [Int] = []
    var markups = [Markup]()
    var checkInDate = ""
    var checkIn = ""
    var checkOut = ""
    var cityCodeStr = ""
    var index: Int?
    var section: Int?
    var selectedTag = 12
    var arrDomestic: [CityDetailModel]?
    var arrIntrnational: [CityDetailModel]?
    var domesticPackageArr: [PackagesDetailModel]?
    var internationalPackArr: [PackagesDetailModel]?
    var selectedTagTwo = 13
    var mainUrl: String?
    var arrHome = [("24/7 Customer Support", "home_img1", "Round-the-clock assistance available."),
                   //  ("Loyalty Program", "home_img2", "Rewards for returning customers."),
                   ("Expert curators", "home_img3", "Knowlegable travel planners."),
                   //  ("Personalized itinerates", "home_img4", "Tailored trip plans."),
                   //  ("Exceptional Service", "home_img5", "High-quality customer care."),
                   ("Flexible Packages", "home_img6", "Customizable travel arrangements.")]
    var allCouponData = [CouponData]()
    var viewController = UIViewController()
    var selectedTagOne = 11
    var viewModel = PackagesVM()
    var param: [String: Any]?
    //MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCollectionView()
    }
    //MARK: - Custom methods
    func setupCollectionView(){
        self.tblVwHome.delegate = self
        self.tblVwHome.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.ragisterNib(nibName: "BannerXIB")
        self.tblVwHome.ragisterNib(nibName: "HomeLeaveCasaTVC")
        self.collectionView.ragisterNib(nibName: PopulerCollectionXIB().identifire)
    }
    
    func setupModelData(model:[Results], homeCouponModel: [CouponData], index: Int, domesticArr: [CityDetailModel], internationalArr:[CityDetailModel], section: Int, selectedTag:Int, viewController: UIViewController, selectedTagOne: Int, allCoupons: [CouponData], domesticPackageArr: [PackagesDetailModel], internationalPackArr: [PackagesDetailModel], selectedTagTwo: Int, mainUrl: String){
        self.modelData = model
        self.homeCouponData = homeCouponModel
        self.index = index
        self.arrDomestic = domesticArr
        self.arrIntrnational = internationalArr
        self.section = section
        self.selectedTag = selectedTag
        self.viewController = viewController
        self.selectedTagOne = selectedTagOne
        self.allCouponData = allCoupons
        self.selectedTagTwo = selectedTagTwo
        self.domesticPackageArr = domesticPackageArr
        self.internationalPackArr = internationalPackArr
        self.mainUrl = mainUrl
        self.collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension HomeBannerXIB: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if self.type == .Popurlar{
            return self.modelData.count
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.section == 1 {
            return homeCouponData.count
        } else if selectedTagTwo == 13 && self.section == 3 {
            return arrDomestic?.count ?? 0
        } else if selectedTagTwo == 23 && self.section == 3 {
            return arrIntrnational?.count ?? 0
        } else if self.section == 2 && selectedTag == 12 {
            debugPrint("domestic Array: \(domesticPackageArr?.count ?? 0)")
            return domesticPackageArr?.count ?? 0
        } else if self.section == 2 && selectedTag == 22 {
            debugPrint("international Array: \(internationalPackArr?.count ?? 0)")
            return internationalPackArr?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.type == .Banner{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerXIB", for: indexPath) as! BannerXIB
            cell.imgVwBlackShadow.isHidden = true
            cell.lblDestination.text = ""
            if self.section == 1 {
                cell.imgVwBanner.sd_setImage(with: URL(string: homeCouponData[indexPath.row].imgUrl ?? ""), placeholderImage: .placeHolder())
            } else if selectedTagTwo == 23 && self.section == 3 {
                cell.imgVwBanner.sd_setImage(with: URL(string: arrIntrnational?[indexPath.row].cityImage ?? ""), placeholderImage: .placeHolder())
            } else if selectedTagTwo == 13 && self.section == 3 {
                cell.imgVwBanner.sd_setImage(with: URL(string: arrDomestic?[indexPath.row].cityImage ?? ""), placeholderImage: .placeHolder())
            } else if self.section == 2 && selectedTag == 12 {
                
                cell.imgVwBanner.sd_setImage(with: URL(string: domesticPackageArr?[indexPath.row].imageUrl?.components(separatedBy: ",").count ?? 0 > 0 ? domesticPackageArr?[indexPath.row].imageUrl?.components(separatedBy: ",")[0] ?? "" : domesticPackageArr?[indexPath.row].imageUrl ?? ""), placeholderImage: .placeHolder())
                    
                
                
              //  cell.imgVwBanner.sd_setImage(with: URL(string: domesticPackageArr?[indexPath.row].imageUrl ?? ""), placeholderImage: .placeHolder())
                cell.imgVwBlackShadow.isHidden = false
                cell.lblDestination.text = domesticPackageArr?[indexPath.row].destination
            } else if self.section == 2 && selectedTag == 22 {
                cell.imgVwBanner.sd_setImage(with: URL(string: internationalPackArr?[indexPath.row].imageUrl?.components(separatedBy: ",").count ?? 0 > 0 ? internationalPackArr?[indexPath.row].imageUrl?.components(separatedBy: ",")[0] ?? "" : internationalPackArr?[indexPath.row].imageUrl ?? ""), placeholderImage: .placeHolder())
                cell.imgVwBlackShadow.isHidden = false
                
               // cell.imgVwBanner.sd_setImage(with: URL(string: internationalPackArr?[indexPath.row].imageUrl ?? ""), placeholderImage: .placeHolder())
                cell.lblDestination.text = internationalPackArr?[indexPath.row].destination
            }
            return cell
        }else{
            let populerCell = collectionView.dequeueReusableCell(withReuseIdentifier: PopulerCollectionXIB().identifire, for: indexPath) as! PopulerCollectionXIB
            
            let hotels = self.modelData[indexPath.section].hotels
            
            let hotel: Hotels?
            hotel = hotels[indexPath.row]
            
            populerCell.lblHotelName.text = hotel?.sName
            populerCell.lblRate.text = "\(hotel?.iCategory ?? 0)"
            populerCell.lblAddress.text = "₹\(String(format: "%.0f", hotel?.iMinRate.sPrice ?? 0))"
            if let image = hotel?.sImages {
                if let imageUrl = image[WSResponseParams.WS_RESP_PARAM_URL] as? String {
                    if let imageStr = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                        if let url = URL(string: imageStr) {
                            populerCell.imgHotel.sd_setImage(with: url, completed: nil)
                        }
                    }
                }
            }
            return populerCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.section == 1 {
            return CGSize(width: self.collectionView.frame.size.width/1.2, height: (self.collectionView.frame.size.height))
        } else {
            return CGSize(width: self.collectionView.frame.size.width/1.5, height: (self.collectionView.frame.size.height-10))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.section == 1 {
            switch selectedTagOne {
            case 11:
                if homeCouponData[indexPath.row].category == "flight" {
                    if let vc = ViewControllerHelper.getViewController(ofType: .SearchFlightVC, StoryboardName: .Flight) as? SearchFlightVC {
                        vc.couponsData = homeCouponData.filter({$0.category == "flight"})
                        self.viewController.pushView(vc: vc)
                    }
                } else if homeCouponData[indexPath.row].category == "bus" {
                    if let vc = ViewControllerHelper.getViewController(ofType: .BusSearchVC, StoryboardName: .Bus) as? BusSearchVC{
                        vc.viewModel.couponsData = homeCouponData.filter({$0.category == "bus"})
                        self.viewController.pushView(vc: vc)
                    }
                } else {
                    if let vc = ViewControllerHelper.getViewController(ofType: .SearchHotelVC, StoryboardName: .Hotels) as? SearchHotelVC{
                        vc.couponsData = homeCouponData.filter({$0.category == "hotel"})
                        self.viewController.pushView(vc: vc, title: "withCity")
                    }
                }
                
            case 21:
                if let vc = ViewControllerHelper.getViewController(ofType: .SearchFlightVC, StoryboardName: .Flight) as? SearchFlightVC {
                    vc.couponsData = homeCouponData.filter({$0.category == "flight"})
                    self.viewController.pushView(vc: vc)
                }
            case 31:
                if let vc = ViewControllerHelper.getViewController(ofType: .BusSearchVC, StoryboardName: .Bus) as? BusSearchVC{
                    vc.viewModel.couponsData = homeCouponData.filter({$0.category == "bus"})
                    self.viewController.pushView(vc: vc)
                }
            case 41:
                if let vc = ViewControllerHelper.getViewController(ofType: .SearchHotelVC, StoryboardName: .Hotels) as? SearchHotelVC{
                    vc.couponsData = homeCouponData.filter({$0.category == "hotel"})
                    self.viewController.pushView(vc: vc, title: "withCity")
                }
            default:
                break
            }
        } else if section == 3 {
            if let vc = ViewControllerHelper.getViewController(ofType: .SearchHotelVC, StoryboardName: .Hotels) as? SearchHotelVC {
                vc.couponsData = allCouponData.filter({$0.category == "hotel"})
                vc.cityCodeStr = Int((selectedTagTwo == 23 ? arrIntrnational?[indexPath.row].code : arrDomestic?[indexPath.row].code) ?? "0") ?? 0
                vc.previouslyAddedCity = (selectedTagTwo == 23 ? arrIntrnational?[indexPath.row].cityName?.capitalized : arrDomestic?[indexPath.row].cityName?.capitalized) ?? ""
                self.viewController.pushView(vc: vc, title: "withCity")
            }
        } else if section == 2 {
            LoaderClass.shared.loadAnimation()
            self.param = ["destination": (selectedTag == 12 ? domesticPackageArr?[indexPath.row].destination ?? "" : internationalPackArr?[indexPath.row].destination ?? "")]
            viewModel.destination = selectedTag == 12 ? domesticPackageArr?[indexPath.row].destination ?? "" : internationalPackArr?[indexPath.row].destination ?? ""
            viewModel.searchByDestinationApi(param: param!, view: viewController)
        }
    }
}

extension HomeBannerXIB: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrHome.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVwHome.dequeueReusableCell(withIdentifier: "HomeLeaveCasaTVC") as! HomeLeaveCasaTVC
        cell.imgVwLeaveCasa.image = UIImage(named: arrHome[indexPath.row].1)
        cell.lblTitle.text = arrHome[indexPath.row].0
        cell.lblDescription.text = arrHome[indexPath.row].2
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if let vc = ViewControllerHelper.getViewController(ofType: .RequestCallBackVC, StoryboardName: .Main) as? RequestCallBackVC {
                viewController.pushView(vc: vc, title: "Home")
            }
        case 1:
            if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
                viewController.pushView(vc: vc,title: "Expert Curator")
            }
        case 2:
            let storyboard = UIStoryboard(name: StoryboardName.Main.rawValue, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DiscoverTopPlacesVC") as! DiscoverTopPlacesVC
            vc.selectedSection = 2
            vc.selectedTag = 0
            viewController.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
