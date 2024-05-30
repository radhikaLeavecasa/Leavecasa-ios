//
//  MoreinfoPopUpVC.swift
//  LeaveCasa
//
//  Created by acme on 29/06/23.
//

import UIKit

class MoreinfoPopUpVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var collVwBottom: UICollectionView!
    @IBOutlet weak var collVwHeader: UICollectionView!
    //MARK: - Variables
    
    let arrHeaderTab = ["PRICE BREAKUP", "ROOM AMENITIES"]
    var selectedIndex = Int()
    var lastContentOffset: CGPoint = .zero
    var hotels: Hotels?
    var hotelDetail: HotelDetail?
    var hotleRate: HotelRate?
    var markups = [Markup]()
    var roomAmenities = [String]()
    var prices = [String]()
    var cancellationText = String()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        setData()
        
    }
    
    //MARK: - @IBAction
    @IBAction func actionDismiss(_ sender: Any) {
        self.dismiss()
    }
    
    //MARK: - Custom methods
    func setData(){
        // Price Breakup
        var tax = Double()
        if var price = hotleRate?.sPrice as? Double {
            for i in 0..<markups.count {
                let markup: Markup?
                markup = markups[i]
                if markup?.starRating == hotels?.iCategory {
                    if markup?.amountBy == Strings.PERCENT {
                        tax = ((price * (markup?.amount ?? 0) / 100) * 18) / 100
                        price += (price * (markup?.amount ?? 0) / 100) + tax
                    }
                    else {
                        tax = ((markup?.amount ?? 0)  * 18) / 100
                        price += (markup?.amount ?? 0) + tax
                    }
                }
            }
            
            prices.append("₹\(String(format: "%.0f", price))")
            prices.append("₹0")
            prices.append("₹\(String(format: "%.0f", tax))")
            prices.append("₹\(String(format: "%.0f", price))")
            
        }
        // Room Amenities
        if hotleRate?.sOtherInclusions.count ?? 0 > 0 {
            roomAmenities = hotleRate?.sOtherInclusions ?? []
        }
        // Cancellation Policy
//        if hotleRate?.sNonRefundable != nil {
//            if hotleRate?.sNonRefundable == true {
//                cancellationText = "Non-refundable. If you choose to change or cancel this booking you will not be refunded any of the payment."
//            } else if hotleRate?.sNonRefundable == false {
//                guard let cancelByDate = hotleRate?.sCancellationPolicy[WSResponseParams.WS_RESP_PARAM_CANCEL_BY_DATE] as? String else { return }
//
//                cancellationText = "\u{2022} Full refund if you cancel this booking by \(getCancellationDate(date: cancelByDate)).\n\n \u{2022} First night cost (including taxes and fees) will be charged if you cancel this booking later than \((getCancellationDate(date: cancelByDate))).\n\n \u{2022} You might be charged upto the full cost of stay (including taxes & fees) if you do not check-in to the hotel.\n\n"
//            }
//
//            if hotleRate?.sCancellationPolicy != nil {
//                if let details = hotleRate?.sCancellationPolicy[WSResponseParams.WS_RESP_PARAM_DETAILS] as? [[String: AnyObject]], details.count > 0 {
//
//                    let underCancellation = hotleRate?.sCancellationPolicy[WSResponseParams.WS_RESP_PARAM_UNDER_CANCELLATION] as? Bool
//                    var cancellationText = ""
//
//                    if underCancellation == true {
//                        cancellationText += "\u{2022} This booking is under cancellation and you have to pay charges\n\n"
//                    }
//
//                    for detail in details {
//                        let percent = detail[WSResponseParams.WS_RESP_PARAM_PERCENT] as? Int
//                        let flatFee = detail[WSResponseParams.WS_RESP_PARAM_FLAT_FEE] as? Int
//                        let currency = detail[WSResponseParams.WS_RESP_PARAM_CURRENCY_LOWERCASED] as? String
//                        let fromDate = detail[WSResponseParams.WS_RESP_PARAM_FROM] as? String
//                        let nights = detail[WSResponseParams.WS_RESP_PARAM_NIGHTS] as? Int
//
//                        if fromDate != nil && nights != nil {
//                            cancellationText += "\u{2022} Cancellation charges are as per \(nights ?? 0) night from \(getCancellationDate(date: fromDate ?? "")).\n\n"
//                        }
//                        else if fromDate != nil && percent != nil {
//                            cancellationText += "\u{2022} Cancellation charges are \(percent ?? 0) percent from \(getCancellationDate(date: fromDate ?? "")).\n\n"
//                        }
//                        else if flatFee != nil && currency != nil && fromDate != nil {
//                            cancellationText += "\u{2022} If you cancel this booking by \(getCancellationDate(date: fromDate ?? "")) cancellation charges will be \(currency ?? "") \(flatFee ?? 0).\n\n"
//                        }
//                        else if flatFee != nil && currency != nil {
//                            cancellationText += "\u{2022} Cancellation charges will be \(currency ?? "") \(flatFee ?? 0). \n\n"
//                        }
//                        else if currency != nil && percent != nil {
//                            if percent == 100 {
//                                cancellationText += "\u{2022} Full refund if you cancel this booking by \(getCancellationDate(date: fromDate ?? "")).\n\n"
//                            }
//                            else {
//                                cancellationText += "\u{2022} Cancellation charges will be \(percent ?? 0) percent \(currency ?? "").\n\n"
//                            }
//                        }
//                        self.cancellationText = cancellationText
//                    }
//                }
//            }
//        }
        collVwBottom.reloadData()
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                if selectedIndex != 0 {
                    collVwHeader.isPagingEnabled = false
                    selectedIndex = selectedIndex - 1
                    collVwBottom.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .right, animated: true)
                    collVwHeader.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                        self.collVwHeader.scrollToItem(at: IndexPath(row: self.selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
                        self.collVwHeader.isPagingEnabled = true
                    })
                }
            case UISwipeGestureRecognizer.Direction.left:
                if selectedIndex != 1 {
                    collVwHeader.isPagingEnabled = false
                    selectedIndex = selectedIndex + 1
                    collVwBottom.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .left, animated: true)
                    collVwHeader.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                        self.collVwHeader.scrollToItem(at: IndexPath(row: self.selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
                        self.collVwHeader.isPagingEnabled = true
                    })
                }
            default:
                break
            }
        }
    }
    
}

extension MoreinfoPopUpVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrHeaderTab.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwHeader {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreInfoHeaderCVC", for: indexPath) as! MoreInfoHeaderCVC
            cell.lblTitle.text = arrHeaderTab[indexPath.row]
            cell.vwBackgrcound.backgroundColor = indexPath.row == selectedIndex ? .systemBlue : UIColor.customLightGrayColor()
            cell.lblTitle.textColor = indexPath.row == selectedIndex ? .white : .darkGray
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreInfoBottomCVC", for: indexPath) as! MoreInfoBottomCVC
            cell.collViewReload(prices, index: indexPath.row,roomAmenities: roomAmenities,cancellationText: cancellationText)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwHeader {
            
            let label = UILabel(frame: CGRect.zero)
            label.text = arrHeaderTab[indexPath.item]
            label.sizeToFit()
            return CGSize(width: label.frame.width, height: self.collVwHeader.frame.size.height)
        } else {
            return CGSize(width: self.collVwBottom.frame.size.width, height: self.collVwBottom.frame.size.height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collVwHeader {
            selectedIndex = indexPath.row
            collVwHeader.isPagingEnabled = false
            collVwHeader.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
            collVwBottom.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
            collVwHeader.isPagingEnabled = true
            collVwHeader.reloadData()
        }
    }
}
