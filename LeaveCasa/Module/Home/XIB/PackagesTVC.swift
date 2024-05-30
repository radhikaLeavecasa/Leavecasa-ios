//
//  PackagesTVC.swift
//  LeaveCasa
//
//  Created by acme on 03/04/24.
//

import UIKit
import IBAnimatable
import Popover

class PackagesTVC: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var imgVwRupee: UIImageView!
    @IBOutlet weak var lblPaxCount: UILabel!
    @IBOutlet weak var btnViewPackage: AnimatableButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDayNight: UILabel!
    @IBOutlet weak var lblDestinationPlace: UILabel!
    @IBOutlet weak var collVwHighlights: UICollectionView!
    @IBOutlet weak var imgVwPackage: AnimatableImageView!
    //MARK: - Variables
    var arrHighlights = [String]()
    var highlights = String()
   // let popTip = PopTip()
    var isFromList = false
    var index = IndexPath()
    //var view = UIViewController()
    // let popoverView = FSPopoverView()
    
    //MARK: - Lifecycle method
    override func awakeFromNib() {
        // popoverView.dataSource = self
        //  popoverView.present(fromBarItem: barItem)
        self.collVwHighlights.delegate = self
        self.collVwHighlights.dataSource = self
        self.collVwHighlights.ragisterNib(nibName: "PackageHighCVC")
    }
    //MARK: - Custom methods
    func reloadData(_ highlights: String, isFromList: Bool = false, viewController: UIViewController, indexPath: IndexPath){
        arrHighlights = []
        self.isFromList = isFromList
        self.highlights = highlights
      //  view = viewController
        index = indexPath
        let elements3 = self.highlights.components(separatedBy: ",")
        for element in elements3 {
            if element != "\n" {
                arrHighlights.append(element)
            }
        }
        collVwHighlights.reloadData()
    }
}

extension PackagesTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrHighlights.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collVwHighlights.dequeueReusableCell(withReuseIdentifier: "PackageHighCVC", for: indexPath) as! PackageHighCVC
        
        if self.arrHighlights[indexPath.row].contains("Airfare") {
            cell.imgVwHiglights.image = UIImage(named: "Airfare")
        } else if self.arrHighlights[indexPath.row].contains("Breakfast") || self.arrHighlights[indexPath.row].contains("Lunch") || self.arrHighlights[indexPath.row].contains("Dinner") || self.arrHighlights[indexPath.row].contains("Meal") || self.arrHighlights[indexPath.row].contains("meal") {
            cell.imgVwHiglights.image = UIImage(named: "Breakfast")
        } else if self.arrHighlights[indexPath.row].contains("Hotel") {
            cell.imgVwHiglights.image = UIImage(named: "Hotel")
        } else if self.arrHighlights[indexPath.row].contains("Desert Safari") {
            cell.imgVwHiglights.image = UIImage(named: "DesertSafari")
        } else if self.arrHighlights[indexPath.row].contains("Transfer") {
            cell.imgVwHiglights.image = UIImage(named: "Transfers")
        } else if self.arrHighlights[indexPath.row].contains("Sightseeing") {
            cell.imgVwHiglights.image = UIImage(named: "Sightseeing")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: self.collVwHighlights.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PackageHighCVC
        let label = UILabel()
        label.text = "\(self.arrHighlights[indexPath.row].replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\n", with: ""))"
        label.numberOfLines = 0 // Allow the label to wrap text
        label.textAlignment = .center
        label.font = UIFont(name: "Metropolis-Regular",size: 13.0)// Center the text
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: labelSize.width+15, height: labelSize.height+10))
        label.frame = CGRect(x: 0, y: 10, width: aView.frame.size.width, height: aView.frame.size.height)
        aView.addSubview(label)
        let popover = Popover()
        popover.show(aView, fromView: cell.contentView)
        DispatchQueue.main.asyncAfter(deadline: .now()+3) { popover.dismiss() }
    }
}
