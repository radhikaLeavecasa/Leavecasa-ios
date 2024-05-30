//
//  DiscoverTopPlacesVC.swift
//  LeaveCasa
//
//  Created by acme on 15/11/23.
//

import UIKit
import IBAnimatable
import SearchTextField

class DiscoverTopPlacesVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var btnOptions: [AnimatableButton]!
    @IBOutlet weak var tblVwList: UITableView!
    @IBOutlet weak var vwCompleteBottom: UIView!
    @IBOutlet weak var vwDomesticBottom: UIView!
    @IBOutlet weak var vwThirdBottom: UIView!
    @IBOutlet weak var vwThird: UIView!
    @IBOutlet weak var cnstHeightTxtFld: NSLayoutConstraint!
    @IBOutlet weak var vwSearch: AnimatableView!
    @IBOutlet weak var txtFldSearch: SearchTextField!
    //MARK: - Variables
    var objSearchViewModel = SearchViewModel()
    lazy var cityName = [String]()
    var arrDomestic: [CityDetailModel]?
    var arrInternational: [CityDetailModel]?
    var selectedTag = 0
    var couponData: [CouponData]?
    var couponDataFilter: [CouponData]?
    var selectedSection = 0
    var viewModel = DiscoverTopPlacesVM()
    
    var arrDomestic1 = [String]()
    var arrInternational1 = [String]()
    
    
    var arrPackageDomestic1: [PackagesDetailModel]?
    var arrPackageInternational1: [PackagesDetailModel]?
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedSection == 2 {
            if LoaderClass.shared.arrSearchResultAll.count == 0 {
                LoaderClass.shared.loadAnimation()
                self.objSearchViewModel.searchPackageCity(view: self)
            }
            cnstHeightTxtFld.constant = 50
            vwSearch.isHidden = false
        }
      //  self.txtFldSearch.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
        objSearchViewModel.delegate = self
        viewModel.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.vwThird.isHidden = selectedSection == 2 || selectedSection == 3
        lblTitle.text = selectedSection == 1 ? "Explore Offers" : selectedSection == 3 ? "Discover Top Places Of The Season" : "Packages"
        btnOptions[0].setTitle(selectedSection == 1 ? "Flights" : "Domestic", for: .normal)
        btnOptions[1].setTitle(selectedSection == 1 ? "Bus" : "International", for: .normal)
        btnOptions[2].setTitle(selectedSection == 1 ? "Hotels" : "", for: .normal)
        tblVwList.ragisterNib(nibName: "PackagesTVC")
        actionOptions(btnOptions[selectedTag])
        if selectedSection == 2 {
            self.viewModel.callPackagesApi(view: self)
        }
    }
    //MARK: - Custom methods
//    @objc func searchCity(_ sender: UITextField) {
//        apiReload()
////        if self.cityName.count > 0 {
////            self.cityName.removeAll()
////        }
//    }
    //MARK: - @IBActions
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
    @IBAction func actionOptions(_ sender: UIButton) {
        for btn in btnOptions {
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
            self.btnOptions[0].isSelected = true
            self.btnOptions[1].isSelected = false
            self.btnOptions[2].isSelected = false
        } else if sender.tag == 1 {
            self.btnOptions[1].isSelected = true
            self.btnOptions[0].isSelected = false
            self.btnOptions[2].isSelected = false
        } else {
            self.btnOptions[2].isSelected = true
            self.btnOptions[0].isSelected = false
            self.btnOptions[1].isSelected = false
        }
        if selectedSection == 2 {
            selectedTag = sender.tag
            txtFldSearch.text = ""
            txtFldSearch.resignFirstResponder()
            apiReload()
        }
        self.tblVwList.reloadData()
    }
}

extension DiscoverTopPlacesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSection == 1 {
            return btnOptions[0].isSelected ? self.couponData?.filter({$0.category == "flight"}).count ?? 0 : btnOptions[1].isSelected ? self.couponData?.filter({$0.category == "bus"}).count ?? 0 : self.couponData?.filter({$0.category == "hotel"}).count ?? 0
        } else if selectedSection == 3 {
            return btnOptions[0].isSelected ? arrDomestic?.count ?? 0 : arrInternational?.count ?? 0
        } else {
            return btnOptions[0].isSelected ? viewModel.arrPackageDomestic?.count ?? 0 : viewModel.arrPackageInternational?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedSection == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverTVC") as! DiscoverTVC
            cell.lblCity.text = btnOptions[0].isSelected ? arrDomestic?[indexPath.row].descrip : arrInternational?[indexPath.row].descrip
            cell.imgVwCities.sd_setImage(with: URL(string:btnOptions[0].isSelected ?  arrDomestic?[indexPath.row].cityImage ?? "" : arrInternational?[indexPath.row].cityImage ?? ""), placeholderImage: .placeHolder())
            return cell
        } else if selectedSection == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PackagesTVC") as! PackagesTVC
            cell.lblDestinationPlace.text = btnOptions[0].isSelected ? viewModel.arrPackageDomestic?[indexPath.row].destination : viewModel.arrPackageInternational?[indexPath.row].destination
            cell.lblPrice.text = "\(btnOptions[0].isSelected ? viewModel.arrPackageDomestic?[indexPath.row].leavecasaPrice ?? "" : viewModel.arrPackageInternational?[indexPath.row].leavecasaPrice ?? "")"
            cell.lblDayNight.text = btnOptions[0].isSelected ? viewModel.arrPackageDomestic?[indexPath.row].packageDuration : viewModel.arrPackageInternational?[indexPath.row].packageDuration
            cell.reloadData(btnOptions[0].isSelected ? viewModel.arrPackageDomestic?[indexPath.row].keyHighlights ?? "" : viewModel.arrPackageInternational?[indexPath.row].keyHighlights ?? "",isFromList: true,viewController: self,indexPath: indexPath)

            if btnOptions[0].isSelected {
                cell.imgVwPackage.sd_setImage(with: URL(string: viewModel.arrPackageDomestic?[indexPath.row].imageUrlArr?.first ?? ""), placeholderImage: .placeHolder())
                
            } else {
                cell.imgVwPackage.sd_setImage(with: URL(string: viewModel.arrPackageInternational?[indexPath.row].imageUrlArr?.first ?? ""), placeholderImage: .placeHolder())
            }
        
            cell.btnViewPackage.tag = indexPath.row
            cell.btnViewPackage.addTarget(self, action: #selector(actionViewPackage), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverTVC") as! DiscoverTVC
            cell.lblCity.text = btnOptions[0].isSelected ? couponData?.filter({$0.category == "flight"})[indexPath.row].couponDescription : btnOptions[1].isSelected ? couponData?.filter({$0.category == "bus"})[indexPath.row].couponDescription : couponData?.filter({$0.category == "hotel"})[indexPath.row].couponDescription
            cell.imgVwCities.sd_setImage(with: URL(string:(btnOptions[0].isSelected ? couponData?.filter({$0.category == "flight"})[indexPath.row].imgUrl : btnOptions[1].isSelected ? couponData?.filter({$0.category == "bus"})[indexPath.row].imgUrl : couponData?.filter({$0.category == "hotel"})[indexPath.row].imgUrl) ?? ""), placeholderImage: .placeHolder())
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedSection == 1 {
            if btnOptions[0].isSelected {
                if let vc = ViewControllerHelper.getViewController(ofType: .SearchFlightVC, StoryboardName: .Flight) as? SearchFlightVC {
                    vc.couponsData = couponData?.filter({$0.category == "flight"})
                    self.pushView(vc: vc)
                }
            } else if btnOptions[1].isSelected {
                if let vc = ViewControllerHelper.getViewController(ofType: .BusSearchVC, StoryboardName: .Bus) as? BusSearchVC{
                    vc.viewModel.couponsData = couponData?.filter({$0.category == "bus"})
                    self.pushView(vc: vc)
                }
            } else {
                if let vc = ViewControllerHelper.getViewController(ofType: .SearchHotelVC, StoryboardName: .Hotels) as? SearchHotelVC{
                    vc.couponsData = couponData?.filter({$0.category == "hotel"})
                    self.pushView(vc: vc, title: "withCity")
                }
            }
        } else {
            if btnOptions[0].isSelected {
                
            } else {
                
            }
        }
    }
    
    @objc func actionViewPackage(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .PackageDetailVC, StoryboardName: .Main) as? PackageDetailVC {
            vc.packageDetail = btnOptions[0].isSelected ? viewModel.arrPackageDomestic?[sender.tag] : viewModel.arrPackageInternational?[sender.tag]
            self.pushView(vc: vc)
        }
    }
}
    
extension DiscoverTopPlacesVC: ResponseProtocol {
    
    func onSuccess() {
        self.arrPackageDomestic1 = self.viewModel.arrPackageDomestic
        self.arrPackageInternational1 = self.viewModel.arrPackageInternational
        tblVwList.reloadData()
    }
    
    func apiReload() {
        
        if selectedTag == 0 && arrDomestic1.count == 0 {
            for i in LoaderClass.shared.arrDomesticSearches {
                arrDomestic1.append(i.city ?? "")
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                LoaderClass.shared.stopAnimation()
            })
        } else if selectedTag == 1 && arrInternational1.count == 0 {
            for i in LoaderClass.shared.arrInternationalSearches {
                if i.city == nil {
                    arrInternational1.append(i.country ?? "")
                } else {
                    arrInternational1.append("\(i.city ?? ""),\(i.country ?? "")")
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                LoaderClass.shared.stopAnimation()
            })
        }
        txtFldSearch.theme = SearchTextFieldTheme.lightTheme()
        txtFldSearch.theme.font = .systemFont(ofSize: 12)
        txtFldSearch.theme.bgColor = UIColor.white
        txtFldSearch.theme.fontColor = UIColor.black
        txtFldSearch.theme.cellHeight = 40
        if selectedTag == 0 {
            txtFldSearch.filterStrings(arrDomestic1)
        } else {
            txtFldSearch.filterStrings(arrInternational1)
        }
        txtFldSearch.isFilter = true
        txtFldSearch.itemSelectionHandler = { filteredResults, itemPosition in
            if filteredResults.count > 0 {
                let item = filteredResults[itemPosition]
                self.txtFldSearch.text = item.title
                self.txtFldSearch.resignFirstResponder()
                if self.selectedTag == 0 {
                    self.viewModel.arrPackageDomestic =  self.arrPackageDomestic1?.filter({$0.destination!.contains(self.txtFldSearch.text!) || $0.destination!.contains(self.txtFldSearch.text!.uppercased())})
                    self.tblVwList.reloadData()
                    if self.viewModel.arrPackageDomestic?.count == 0 {
                        self.pushNoInterConnection(view: self,titleMsg: "Oops!", msg: "No Result found for your required search. Please send your enquiry for custom Package.\nOur team will reach you out soon.") {
                            if let vc = ViewControllerHelper.getViewController(ofType: .RequestCallBackVC, StoryboardName: .Main) as? RequestCallBackVC {
                                vc.destination = item.title
                                self.pushView(vc: vc)
                            }
                        }
                    }
                } else {
                    self.viewModel.arrPackageInternational =  self.arrPackageInternational1?.filter({$0.destination!.contains(self.txtFldSearch.text?.components(separatedBy: ",").count ?? 0 > 0 ? self.txtFldSearch.text!.components(separatedBy: ",")[0] : self.txtFldSearch.text!) || $0.destination!.contains(self.txtFldSearch.text?.components(separatedBy: ",").count ?? 0 > 0 ? self.txtFldSearch.text!.components(separatedBy: ",")[0].uppercased() : self.txtFldSearch.text!.uppercased())})
                    self.tblVwList.reloadData()
                    if self.viewModel.arrPackageInternational?.count == 0 {
                        self.pushNoInterConnection(view: self,titleMsg: "Oops!", msg: "No Result found for your required search. Please send your enquiry for custom Package.\nOur team will reach you out soon.") {
                            if let vc = ViewControllerHelper.getViewController(ofType: .RequestCallBackVC, StoryboardName: .Main) as? RequestCallBackVC {
                                vc.destination = item.title
                                self.pushView(vc: vc)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension DiscoverTopPlacesVC: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.viewModel.arrPackageDomestic = self.arrPackageDomestic1
        self.viewModel.arrPackageInternational = self.arrPackageInternational1
        txtFldSearch.resignFirstResponder()
        tblVwList.reloadData()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        apiReload()
        return true
    }
}
