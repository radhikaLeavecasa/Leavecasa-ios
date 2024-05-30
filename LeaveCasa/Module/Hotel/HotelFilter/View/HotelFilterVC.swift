//
//  HotelFilterVC.swift
//  LeaveCasa
//
//  Created by acme on 09/09/22.
//

import UIKit
import IBAnimatable
import RangeSeekSlider


protocol filterHotelList {
    func filterHotelList(rating: [Int], maxPrice: Double, minPrice: Double, propertyType: [String], amenities: [String], refundable: String, breakfast: String)
}

class HotelFilterVC: UIViewController, RangeSeekSliderDelegate {
    //MARK: - @IBOutlets
    @IBOutlet weak var aminitiesCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var propertyCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var fourStartView: AnimatableView!
    @IBOutlet weak var threeStarView: AnimatableView!
    @IBOutlet weak var fiveStarView: AnimatableView!
    @IBOutlet weak var sliderPrice: RangeSeekSlider!
    @IBOutlet weak var amenitiesCollectionView: UICollectionView!
    @IBOutlet weak var propertyCollectionView: UICollectionView!
    @IBOutlet var btnBreakfastNot: [UIButton]!
    @IBOutlet var btnRefundableNon: [UIButton]!
    @IBOutlet weak var btnAppy: AnimatableButton!
    //MARK: - Variables

    var filterData = [String:Any]()
    var rate = [Int]()
    var price = Double()
    var price2 = Double()
    var maxAmount = 100000
    var delegate : filterHotelList?
    var selectPropertyType = [String]()
    var selectAmenities = [String]()
    var isMorePropertyType = false
    var isRefundable = String()
    var isBreakfast = String()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        sliderPrice.delegate = self
        self.setupSlider()
        self.setupFilterData()
        self.setRefundableBreakfast()
        LoaderClass.shared.stopAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
            self.amenitiesCollectionView.reloadData()
            self.propertyCollectionView.reloadData()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.propertyCollectionHeight.constant = 200
        self.aminitiesCollectionHeight.constant = 220
        self.view.layoutIfNeeded()
        self.view.updateFocusIfNeeded()
    }
    
    //MARK: - @IBActions
    @IBAction func backOnPress(_ sender: UIButton) {
        if let del = self.delegate {
            self.price = round(self.sliderPrice.selectedMaxValue)
            self.price2 = round(self.sliderPrice.selectedMinValue)
            del.filterHotelList(rating: self.rate, maxPrice: self.price, minPrice: price2, propertyType: self.selectPropertyType, amenities: self.selectAmenities, refundable: self.isRefundable, breakfast: self.isBreakfast)
            HotelFilterData.share.rate = self.rate
            HotelFilterData.share.price = self.price
            HotelFilterData.share.amenities = selectAmenities
            HotelFilterData.share.propertyType = selectPropertyType
            HotelFilterData.share.isBreakfast = self.isBreakfast
            HotelFilterData.share.refundable = self.isRefundable
            self.popView()
            LoaderClass.shared.showSnackBar(message: "Filter applied successfully!")

        }
    }
    
    @IBAction func actionRefundableNot(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if btnRefundableNon[0].isSelected && btnRefundableNon[1].isSelected {
            isRefundable = "Both"
        }else if btnRefundableNon[0].isSelected {
            isRefundable = "Non-Refundable"
        } else if btnRefundableNon[1].isSelected {
            isRefundable = "Refundable"
        } else {
            isRefundable = ""
        }
    }
    
    @IBAction func actionBreakfastNot(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if btnBreakfastNot[0].isSelected && btnBreakfastNot[1].isSelected {
            isBreakfast = "Both"
        } else if btnBreakfastNot[1].isSelected {
            isBreakfast = "Included"
        } else if btnBreakfastNot[0].isSelected {
            isBreakfast = "Not-Included"
        }  else {
            isBreakfast = ""
        }
    }
    
    
    @IBAction func resetViewOnPress(_ sender: UIButton) {
        self.rate = []
        self.price = 0.0
        self.selectPropertyType.removeAll()
        self.selectAmenities.removeAll()
        
        HotelFilterData.share.rate = self.rate
        HotelFilterData.share.price = self.price
        HotelFilterData.share.amenities = selectAmenities
        HotelFilterData.share.propertyType = selectPropertyType
        
        self.setupFilterData()
        
        self.amenitiesCollectionView.reloadData()
        self.propertyCollectionView.reloadData()
        
        if let del = self.delegate {
            del.filterHotelList(rating: self.rate, maxPrice: self.price, minPrice: price2, propertyType: self.selectPropertyType, amenities: self.selectAmenities, refundable: self.isRefundable, breakfast: self.isBreakfast)
            HotelFilterData.share.isReset = true
            self.popView()
        }
    }
    
    @IBAction func applyOnPress(_ sender: UIButton) {
        if let del = self.delegate {
            self.price = round(self.sliderPrice.selectedMaxValue)
            
            del.filterHotelList(rating: self.rate, maxPrice: self.price, minPrice: price2, propertyType: self.selectPropertyType, amenities: self.selectAmenities, refundable: self.isRefundable, breakfast: self.isBreakfast)
            HotelFilterData.share.rate = self.rate
            HotelFilterData.share.price = self.price
            HotelFilterData.share.price2 = self.price2
            HotelFilterData.share.amenities = selectAmenities
            HotelFilterData.share.propertyType = selectPropertyType
            HotelFilterData.share.isBreakfast = self.isBreakfast
            HotelFilterData.share.refundable = self.isRefundable
            self.popView()
            LoaderClass.shared.showSnackBar(message: "Filter applied successfully!")
        }
    }
    
    @IBAction func sliderOnSlide(_ sender: RangeSeekSlider) {
        print(sender.maxValue)
        print(sender.minValue)
    }
    
    @IBAction func fiveStarOnPress(_ sender: UIButton) {
        self.setupFiveStartView()
    }
    
    @IBAction func fourStarOnPress(_ sender: UIButton) {
        self.setupFourStartView()
    }
    
    @IBAction func threeStarOnPress(_ sender: UIButton) {
        self.setupThreeStartView()
    }
    
    //MARK: - Custom methods
    func setupFilterData() {
        if HotelFilterData.share.rate.contains(5) {
            self.setupFiveStartView()
        } else if HotelFilterData.share.rate.contains(4) {
            self.setupFourStartView()
        } else if HotelFilterData.share.rate.contains(3) {
            self.setupThreeStartView()
        } else {
            self.fiveStarView.borderWidth = 0
            self.fiveStarView.borderColor = .clear
            
            self.fourStartView.borderWidth = 0
            self.fourStartView.borderColor = .clear
            
            self.threeStarView.borderWidth = 0
            self.threeStarView.borderColor = .clear
        }
        
        if HotelFilterData.share.price != 0.0 {
            price = HotelFilterData.share.price
            sliderPrice.selectedMaxValue = price
        } else {
            sliderPrice.selectedMaxValue = CGFloat(maxAmount)
            sliderPrice.maxValue = CGFloat(maxAmount)
        }
        
        selectPropertyType = HotelFilterData.share.propertyType
        selectAmenities = HotelFilterData.share.amenities
    }
    
    func setRefundableBreakfast(){
        if isRefundable == "Both"{
            btnRefundableNon[0].isSelected = true
            btnRefundableNon[1].isSelected = true
       }else if isRefundable == "Non-Refundable" {
           btnRefundableNon[0].isSelected = true
           btnRefundableNon[1].isSelected = false
       } else if isRefundable == "Refundable" {
           btnRefundableNon[1].isSelected = true
           btnRefundableNon[0].isSelected = false
       } else if isRefundable == "" {
           btnRefundableNon[1].isSelected = false
           btnRefundableNon[0].isSelected = false
       }
        
        if isBreakfast == "Both"{
            btnBreakfastNot[0].isSelected = true
            btnBreakfastNot[1].isSelected = true
       }else if isBreakfast == "Non-Refundable" {
           btnBreakfastNot[0].isSelected = true
           btnBreakfastNot[1].isSelected = false
       } else if isBreakfast == "Refundable" {
           btnBreakfastNot[1].isSelected = true
           btnBreakfastNot[0].isSelected = false
       } else if isBreakfast == "" {
           btnBreakfastNot[1].isSelected = false
           btnBreakfastNot[0].isSelected = false
       }
    }
    
    func setupCollectionView() {
        self.propertyCollectionView.delegate = self
        self.propertyCollectionView.dataSource = self
        self.propertyCollectionView.ragisterNib(nibName: "PropertyTypeXIB")
        self.amenitiesCollectionView.delegate = self
        self.amenitiesCollectionView.dataSource = self
        self.amenitiesCollectionView.ragisterNib(nibName: "PropertyTypeXIB")
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        self.propertyCollectionView.collectionViewLayout = layout
//
//        let layout2 = UICollectionViewFlowLayout()
//        layout2.scrollDirection = .vertical
//        layout2.minimumInteritemSpacing = 0
//        layout2.minimumLineSpacing = 0
//        layout2.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//
//        self.amenitiesCollectionView.collectionViewLayout = layout2
    }
    
    func setupSlider() {
//        lblMinValue.text = "1000"
//        lblMaxValue.text = "100000"
        self.sliderPrice.minValue = 1000
        self.sliderPrice.maxValue = CGFloat(self.maxAmount)
        self.sliderPrice.selectedMaxValue = CGFloat(self.maxAmount)
        self.sliderPrice.minLabelColor = .customBlueColor()
        self.sliderPrice.maxLabelColor = .customBlueColor()
        self.sliderPrice.minLabelFont = .boldFont(size: 14)
        self.sliderPrice.maxLabelFont = .boldFont(size: 14)
    }
    
    func setupFiveStartView() {
        if self.rate.contains(5) {
            self.fiveStarView.borderWidth = 0
            self.fiveStarView.borderColor = .clear
            self.rate.removeAll(where: { $0 == 5 })
        } else {
            self.fiveStarView.borderWidth = 1
            self.fiveStarView.borderColor = .cutomRedColor()
            
//            self.fourStartView.borderWidth = 0
//            self.fourStartView.borderColor = .clear
//
//            self.threeStarView.borderWidth = 0
//            self.threeStarView.borderColor = .clear
            
            self.rate.append(5)
        }
    }
    
    func setupFourStartView() {
        if self.rate.contains(4) {
            self.fourStartView.borderWidth = 0
            self.fourStartView.borderColor = .clear
            
            self.rate.removeAll(where: { $0 == 4 })
        } else {
            self.fourStartView.borderWidth = 1
            self.fourStartView.borderColor = .cutomRedColor()
            
//            self.fiveStarView.borderWidth = 0
//            self.fiveStarView.borderColor = .clear
//
//            self.threeStarView.borderWidth = 0
//            self.threeStarView.borderColor = .clear
            
            self.rate.append(4)
        }
    }
    
    func setupThreeStartView() {
        if self.rate.contains(3) {
            self.threeStarView.borderWidth = 0
            self.threeStarView.borderColor = .clear
            self.rate.removeAll(where: { $0 == 3 })
        }else{
            self.threeStarView.borderWidth = 1
            self.threeStarView.borderColor = .cutomRedColor()
            
//            self.fourStartView.borderWidth = 0
//            self.fourStartView.borderColor = .clear
//
//            self.fiveStarView.borderWidth = 0
//            self.fiveStarView.borderColor = .clear
            
            self.rate.append(3)
        }
    }
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
//        lblMinValue.text = "\(slider.minValue)"
//        lblMaxValue.text = "\(slider.maxValue)"
    }
    

}

extension HotelFilterVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.propertyCollectionView {
            return HotelFilterData.share.propertyType1.count
        } else if collectionView == self.amenitiesCollectionView{
            return HotelFilterData.share.aminityType.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyTypeXIB", for: indexPath) as! PropertyTypeXIB
        if collectionView == self.propertyCollectionView {
            cell.lblTitle.text = HotelFilterData.share.propertyType1[indexPath.item]
            
            if self.selectPropertyType.contains(HotelFilterData.share.propertyType1[indexPath.item]) {
              //  cell.lblTitle.textColor = .cutomRedColor()
                cell.backView.borderColor = .cutomRedColor()
            }else{
               // cell.lblTitle.textColor = .theamColor()
                cell.backView.borderColor = .grayColor()
            }
        }
        else if collectionView == self.amenitiesCollectionView {
            cell.lblTitle.text = HotelFilterData.share.aminityType[indexPath.item].facility_name ?? ""
            
            if self.selectAmenities.contains(HotelFilterData.share.aminityType[indexPath.item].facility_name ?? "") {
                cell.backView.borderColor = .cutomRedColor()
                
            } else {
                cell.backView.borderColor = .grayColor()
            }
        }
        
        cell.lblTitle.sizeToFit()
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.propertyCollectionView {
            return CGSize(width: self.propertyCollectionView.frame.size.width/2, height: 35)
        }else{
            //            if let cell = (self.amenitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "PropertyTypeXIB", for: indexPath) as? PropertyTypeXIB) {
            //                let targetSize = CGSize(width: self.amenitiesCollectionView.frame.size.width/2, height: UIView.layoutFittingCompressedSize.height)
            //                let size = cell.contentView.systemLayoutSizeFitting(targetSize)
            
            return CGSize(width: self.amenitiesCollectionView.frame.size.width/2, height: 45)
            //            }
            //            return CGSize(width: 0, height: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.propertyCollectionView {
            if self.selectPropertyType.contains(HotelFilterData.share.propertyType1[indexPath.row]) {
                let index = self.selectPropertyType.firstIndex(of: HotelFilterData.share.propertyType1[indexPath.row])
                self.selectPropertyType.remove(at: index ?? 0)
            }
            else{
                self.selectPropertyType.append(HotelFilterData.share.propertyType1[indexPath.row])
            }
            
            self.propertyCollectionView.reloadData()
        }
        else if collectionView == self.amenitiesCollectionView {
            if self.selectAmenities.contains(HotelFilterData.share.aminityType[indexPath.row].facility_name ?? "") {
                let index = self.selectAmenities.firstIndex(of: HotelFilterData.share.aminityType[indexPath.row].facility_name ?? "")
                self.selectAmenities.remove(at: index ?? 0)
            }
            else{
                self.selectAmenities.append(HotelFilterData.share.aminityType[indexPath.row].facility_name ?? "")
            }
            self.amenitiesCollectionView.reloadData()
        }
    }
}
