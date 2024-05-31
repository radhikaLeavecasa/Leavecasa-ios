//
//  PackageDetailVC.swift
//  LeaveCasa
//
//  Created by acme on 03/04/24.
//

import UIKit
import AdvancedPageControl
import SDWebImage

class PackageDetailVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var cnstTblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var lblPackageDuration: UILabel!
    @IBOutlet weak var lblPackageName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var tblVwInclusions: UITableView!
    @IBOutlet weak var collVwImages: UICollectionView!
    @IBOutlet weak var pageControl: AdvancedPageControlView!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var collVwHighlights: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collVwHighlightsHeight: NSLayoutConstraint!
    //MARK: - Variables
    //var arrImages = [String]()
    var packageDetail: PackagesDetailModel?
    var arrInclusions = [String]()
    var arrItinerary = [String]()
    var arrExclusions = [String]()
    var arrTermsCond = [String]()
    var arrHighlights = [String]()
    var arrPackageHeader = ["Day-Wise Itinerary","Package Inclusions", "Package Exclusions", "Terms & Conditions"]
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblVwInclusions.ragisterNib(nibName: OverViewXIB().identifire)
        self.tblVwInclusions.ragisterNib(nibName: "ItineraryTVC")
        self.tblVwInclusions.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
        self.collVwHighlights.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new,context: UnsafeMutableRawPointer(bitPattern: 1))
        lblDescription.text = packageDetail?.description
        if ((packageDetail?.leavecasaPrice?.contains("contact us")) != false) {
            lblPrice.text = "\(packageDetail?.leavecasaPrice ?? "")"
        } else {
            lblPrice.text = packageDetail?.travellerCount != "" ? "₹\(packageDetail?.leavecasaPrice ?? "")/\(packageDetail?.travellerCount ?? "")" : "₹\(packageDetail?.leavecasaPrice ?? "")"
        }
        lblPackageName.text = packageDetail?.packageName
        lblDestination.text = "\(packageDetail?.destination ?? ""), \(packageDetail?.mainReason ?? "")"
        lblPackageDuration.text = packageDetail?.packageDuration
        
        if packageDetail?.dayWiseInclusion != "" {
            let elements = packageDetail?.dayWiseInclusion?.components(separatedBy: "\n")
            for element in elements ?? [] {
                if element != "\r" && element != "" {
                    arrItinerary.append(element)
                }
            }
        }
        
        let elements = packageDetail?.inclusion?.components(separatedBy: "\n")
        for element in elements ?? [] {
            if element != "\r" && element != "" {
                arrInclusions.append(element)
            }
        }
        
        let elements1 = packageDetail?.packageExclusion?.components(separatedBy: "\n")
        for element in elements1 ?? [] {
            if element != "\r" && element != "" {
                arrExclusions.append(element)
            }
        }
        
        let elements2 = packageDetail?.termsCondition?.components(separatedBy: "\n")
        for element in elements2 ?? [] {
            arrTermsCond.append(element)
        }
        
        let elements3 = packageDetail?.keyHighlights?.components(separatedBy: ",")
        for element in elements3 ?? [] {
            if element != "\n" {
                arrHighlights.append(element)
            }
        }
        
        self.pageControl.drawer = ScaleDrawer(numberOfPages: packageDetail?.imageUrlArr?.count, height: 10, width: 10, space: 6, raduis: 10, currentItem: 0, indicatorColor: .white, dotsColor: .clear, isBordered: true, borderColor: .white, borderWidth: 1.0, indicatorBorderColor: .white, indicatorBorderWidth: 1.0)
        self.pageControl.numberOfPages = packageDetail?.imageUrlArr?.count ?? 0
        self.setupCollectionView()
        tblVwInclusions.reloadData()
        collVwImages.reloadData()
        collVwHighlights.reloadData()
    }
    //MARK: Add Observer For Tableview Height
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            
            if context == nil {
                if object is UITableView {
                    if let newValue = change?[.newKey]{
                        let newSize = newValue as! CGSize
                        self.cnstTblVwHeight.constant = newSize.height
                    }
                }
            }
        }
    }
    func setupCollectionView(){
        self.collVwImages.ragisterNib(nibName: HotelImagesXIB().identifire)
        self.scrollView.delegate = self
    }
    //MARK: - @IBActions
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
    @IBAction func actionRequestCallBAck(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .RequestCallBackVC, StoryboardName: .Main) as? RequestCallBackVC {
            vc.destination = packageDetail?.destination ?? ""
            self.pushView(vc: vc)
        }
    }
}

extension PackageDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        arrPackageHeader.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? arrItinerary.count : section == 1 ? arrInclusions.count : section == 2 ? arrExclusions.count : arrTermsCond.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItineraryTVC", for: indexPath) as! ItineraryTVC
            cell.lblDays.text = arrItinerary[indexPath.row].components(separatedBy: ":").count > 0 ? !arrItinerary[indexPath.row].components(separatedBy: ":")[0].contains("Day") ? "Day \(arrItinerary[indexPath.row].components(separatedBy: ":")[0])" : arrItinerary[indexPath.row].components(separatedBy: ":")[0] : ""
            cell.lblText.text = arrItinerary[indexPath.row].components(separatedBy: ":").count == 2 ? arrItinerary[indexPath.row].components(separatedBy: ":")[1] : arrItinerary[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: OverViewXIB().identifire, for: indexPath) as! OverViewXIB
            cell.lblTitle.textColor = .black
            cell.imgCheck.image = UIImage(named: indexPath.section == 2 ? "ic_cross" : "ic_tick_red")
            cell.lblTitle.text = indexPath.section == 0 ? self.arrItinerary[indexPath.row].replacingOccurrences(of: "\r", with: "") : indexPath.section == 1 ? self.arrInclusions[indexPath.row].replacingOccurrences(of: "\r", with: "") : indexPath.section == 2 ? self.arrExclusions[indexPath.row].replacingOccurrences(of: "\r", with: "") : self.arrTermsCond[indexPath.row].replacingOccurrences(of: "\r", with: "")
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 && arrItinerary.count == 0 ? 0 : UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25))
        let titleLabel = UILabel(frame: CGRect(x: 5, y: 5, width: tableView.frame.size.width - 20, height: 18))
        titleLabel.text = arrPackageHeader[section]
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldFont(size: 14)

        headerView.addSubview(titleLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 && arrItinerary.count == 0 ? 0 : 25
    }
}
extension PackageDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwImages {
            return packageDetail?.imageUrlArr?.count ?? 0
        } else {
            return arrHighlights.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwHighlights {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackageHighlightCVC", for: indexPath) as! PackageHighlightCVC
            
            if self.arrHighlights[indexPath.row].contains("Airfare") {
                cell.imgCheck.image = UIImage(named: "Airfare")
            } else if self.arrHighlights[indexPath.row].contains("Breakfast") || self.arrHighlights[indexPath.row].contains("Lunch") || self.arrHighlights[indexPath.row].contains("Dinner") || self.arrHighlights[indexPath.row].contains("Meals") {
                cell.imgCheck.image = UIImage(named: "Breakfast")
            } else if self.arrHighlights[indexPath.row].contains("Hotel") {
                cell.imgCheck.image = UIImage(named: "Hotel")
            } else if self.arrHighlights[indexPath.row].contains("Desert Safari") {
                cell.imgCheck.image = UIImage(named: "DesertSafari")
            } else if self.arrHighlights[indexPath.row].contains("Transfer") {
                cell.imgCheck.image = UIImage(named: "Transfers")
            } else if self.arrHighlights[indexPath.row].contains("Sightseeing") {
                cell.imgCheck.image = UIImage(named: "Sightseeing")
            } else if self.arrHighlights[indexPath.row].contains("Cruise") {
                cell.imgCheck.image = UIImage(named: "Cruise")
            }
            cell.lblTitle.text = self.arrHighlights[indexPath.row].first == " " ? String(self.arrHighlights[indexPath.row].dropFirst()) : self.arrHighlights[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelImagesXIB().identifire, for: indexPath) as! HotelImagesXIB
            cell.imgHotel.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgHotel.sd_setImage(with: URL(string: packageDetail?.imageUrlArr?[indexPath.row] ?? ""), placeholderImage: .hotelplaceHolder())
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwHighlights {
            let cellWidth = LoaderClass.shared.calculateWidthForCell(at: indexPath, arr: arrHighlights)
            return CGSize(width: cellWidth, height: self.collVwHighlights.frame.size.height)
        } else {
            return CGSize(width: self.collVwImages.frame.size.width, height: (self.collVwImages.frame.size.height))
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collVwImages {
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            let index = Int(round(offSet/width))
            self.pageControl.setPage(index)
        }
    }
}
