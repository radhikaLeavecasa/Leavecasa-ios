//
//  SearchedPackageListsVC.swift
//  LeaveCasa
//
//  Created by acme on 04/04/24.
//

import UIKit

class SearchedPackageListsVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblPackageTitle: UILabel!
    @IBOutlet weak var tblVwPackages: UITableView!
    //MARK: - Variables
    var arrPackages = [PackagesDetailModel]()
    var arrPackages2 = [PackagesDetailModel]()

    var destination = String()
    var withFlight = Bool()
    var withOutFlight = Bool()
    var twoNights = Bool()
    var threeNights = Bool()
    var fourNights = Bool()
    var fiveNights = Bool()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPackageTitle.text = "\(destination) Packages"
        tblVwPackages.ragisterNib(nibName: "PackagesTVC")
        arrPackages2 = arrPackages
    }
    //MARK: - @IBActions
    @IBAction func actionFilter(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .PackageFilterVC, StoryboardName: .Main) as? PackageFilterVC {
            vc.delegate = self
            vc.fiveNights = fiveNights
            vc.fourNights = fourNights
            vc.threeNights = threeNights
            vc.twoNights = twoNights
            vc.withFlight = withFlight
            vc.withOutFlight = withOutFlight
            self.pushView(vc: vc)
        }
    }
    @IBAction func actionCustomizePlan(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .RequestCallBackVC, StoryboardName: .Main) as? RequestCallBackVC {
            vc.destination = destination
            self.pushView(vc: vc)
        }
    }

    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
    
}
extension SearchedPackageListsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrPackages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackagesTVC") as! PackagesTVC
        cell.lblPaxCount.text = arrPackages[indexPath.row].travellerCount != "" ? "\(arrPackages[indexPath.row].travellerCount!)" : ""
        cell.lblDestinationPlace.text = arrPackages[indexPath.row].packageName
        cell.imgVwRupee.isHidden = arrPackages[indexPath.row].leavecasaPrice?.contains("contact us") ?? false ? true : false
        cell.lblPrice.text = arrPackages[indexPath.row].leavecasaPrice
        cell.lblDayNight.text = arrPackages[indexPath.row].packageDuration
        cell.reloadData(arrPackages[indexPath.row].keyHighlights ?? "",viewController: self,indexPath: indexPath)
        if arrPackages[indexPath.row].imageUrlArr?.count ?? 0 > 0 {
            cell.imgVwPackage.sd_setImage(with: URL(string: arrPackages[indexPath.row].imageUrlArr?[0] ?? ""), placeholderImage: .hotelplaceHolder())
        } else {
            cell.imgVwPackage.image = UIImage(named: "ic_hotelPlaceholder")
        }
        cell.btnViewPackage.tag = indexPath.row
        cell.btnViewPackage.addTarget(self, action: #selector(actionViewPackage), for: .touchUpInside)
        return cell
    }
    @objc func actionViewPackage(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .PackageDetailVC, StoryboardName: .Main) as? PackageDetailVC {
            vc.packageDetail = arrPackages[sender.tag]
            self.pushView(vc: vc)
        }
    }
}
extension SearchedPackageListsVC: PackageList {
    func packageList(withFlight: Bool, withOutFlight: Bool, twoN: Bool, threeN: Bool, fourN: Bool, fiveN: Bool) {
        LoaderClass.shared.loadAnimation()
        self.withFlight = withFlight
        self.withOutFlight = withOutFlight
        self.twoNights = twoN
        self.threeNights = threeN
        self.fourNights = fourN
        self.fiveNights = fiveN
        var arrPack = [PackagesDetailModel]()
        arrPackages = []
        if  withFlight == false && withOutFlight == false && twoNights == false && threeNights == false && fourNights == false && fiveNights == false {
            LoaderClass.shared.stopAnimation()
            arrPackages = arrPackages2
            self.tblVwPackages.reloadData()
        } else {
            if withFlight {
                arrPack = arrPackages2.filter({$0.flight == "Yes"})
                
                for i in arrPack {
                    arrPackages.append(i)
                }
            }
            if withOutFlight {
                arrPack = arrPackages2.filter({$0.flight == "No"})
                for i in arrPack {
                    arrPackages.append(i)
                }
            }
            if self.twoNights {
                arrPack = arrPackages2.filter({$0.packageDuration == "2N 3D"})
                for i in arrPack {
                    arrPackages.append(i)
                }
            }
            if self.threeNights {
                arrPack = arrPackages2.filter({$0.packageDuration == "3N 4D"})
                for i in arrPack {
                    arrPackages.append(i)
                }
            }
            if self.fourNights {
                arrPack = arrPackages2.filter({$0.packageDuration == "4N 5D"})
                for i in arrPack {
                    arrPackages.append(i)
                }
            }
            if self.fiveNights {
                arrPack = arrPackages2.filter({$0.packageDuration != "2N 3D"})
                
                for i in arrPack {
                    arrPackages.append(i)
                }
                arrPack = arrPackages2.filter({$0.packageDuration != "3N 4D"})
                
                for i in arrPack {
                    arrPackages.append(i)
                }
                arrPack = arrPackages2.filter({$0.packageDuration != "4N 5D"})
                
                for i in arrPack {
                    arrPackages.append(i)
                }
            }
            LoaderClass.shared.stopAnimation()
            self.tblVwPackages.reloadData()
            if arrPackages.count == 0 {
                pushNoInterConnection(view: self,titleMsg: "Oops!", msg: "No Result Found!") {
                    self.arrPackages = self.arrPackages2
                    self.tblVwPackages.reloadData()
                }
            }
        }
    }
}
