//
//  HotelMoreDetailsVC.swift
//  LeaveCasa
//
//  Created by acme on 19/09/22.
//

import UIKit

class HotelMoreDetailsVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var roomAmenitiesCollectionView: UICollectionView!
    @IBOutlet weak var roomAmenitiesCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblCancellationPolicy: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
    //MARK: - Variables
    var hotels: Hotels?
    var hotelDetail: HotelDetail?
    var hotleRate: HotelRate?
    var markups = [Markup]()
    var prices = [String]()
    var roomAmenities = [String]()
    var priceBreakup = ["Room Price", "Discount", "Taxes & Fee", "Total Price"]
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        setupCollectionView()
        displayData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height = self.roomAmenitiesCollectionView.collectionViewLayout.collectionViewContentSize.height
        self.roomAmenitiesCollectionViewHeight.constant = height
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Strings.CONTENT_SIZE {
            if let newvalue = change?[.newKey] {
                if let newsize = newvalue as? CGSize {
                    DispatchQueue.main.async {
                        self.tableViewHeightConstraint.constant = newsize.height
                    }
                }
            }
        }
    }
    
    //MARK: - Custom methods
    func setupCollectionView() {
        roomAmenitiesCollectionView.delegate = self
        roomAmenitiesCollectionView.dataSource = self
        roomAmenitiesCollectionView.ragisterNib(nibName: FacilityCollectionXIB().identifire)
        tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
    }
    
    func displayData() {
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
            
            tableView.reloadData()
        }
        
        // Room Amenities
        if hotleRate?.sOtherInclusions.count ?? 0 > 0 {
            roomAmenitiesCollectionView.isHidden = false
            lblNoDataFound.isHidden = true
            
            roomAmenities = hotleRate?.sOtherInclusions ?? []
            roomAmenitiesCollectionView.reloadData()
        }
        else {
            lblNoDataFound.isHidden = false
            roomAmenitiesCollectionView.isHidden = true
        }
        
        // Cancellation Policy
        if hotleRate?.sNonRefundable != nil {
            if hotleRate?.sNonRefundable == true {
                self.lblCancellationPolicy.text = "Non-refundable. If you choose to change or cancel this booking you will not be refunded any of the payment."
            }
            else if hotleRate?.sNonRefundable == false {
                guard let cancelByDate = hotleRate?.sCancellationPolicy[WSResponseParams.WS_RESP_PARAM_CANCEL_BY_DATE] as? String else { return }
                
                self.lblCancellationPolicy.text = "\u{2022} Full refund if you cancel this booking by \(getCancellationDate(date: cancelByDate)).\n\n \u{2022} First night cost (including taxes and fees) will be charged if you cancel this booking later than \((getCancellationDate(date: cancelByDate))).\n\n \u{2022} You might be charged upto the full cost of stay (including taxes & fees) if you do not check-in to the hotel."
            }
            
            if hotleRate?.sCancellationPolicy != nil {
                if let details = hotleRate?.sCancellationPolicy[WSResponseParams.WS_RESP_PARAM_DETAILS] as? [[String: AnyObject]], details.count > 0 {
                    
                    let underCancellation = hotleRate?.sCancellationPolicy[WSResponseParams.WS_RESP_PARAM_UNDER_CANCELLATION] as? Bool
                    var cancellationText = ""

                    if underCancellation == true {
                        cancellationText += "\u{2022} This booking is under cancellation and you have to pay charges\n\n"
                    }
                    
                    for detail in details {
                        let percent = detail[WSResponseParams.WS_RESP_PARAM_PERCENT] as? Int
                        let flatFee = detail[WSResponseParams.WS_RESP_PARAM_FLAT_FEE] as? Int
                        let currency = detail[WSResponseParams.WS_RESP_PARAM_CURRENCY_LOWERCASED] as? String
                        let fromDate = detail[WSResponseParams.WS_RESP_PARAM_FROM] as? String
                        let nights = detail[WSResponseParams.WS_RESP_PARAM_NIGHTS] as? Int
                        
                        if fromDate != nil && nights != nil {
                            cancellationText += "\u{2022} Cancellation charges are as per \(nights ?? 0) night from \(getCancellationDate(date: fromDate ?? "")).\n\n"
                        }
                        else if fromDate != nil && percent != nil {
                            cancellationText += "\u{2022} Cancellation charges are \(percent ?? 0) percent from \(getCancellationDate(date: fromDate ?? "")).\n\n"
                        }
                        else if flatFee != nil && currency != nil && fromDate != nil {
                            cancellationText += "\u{2022} If you cancel this booking by \(getCancellationDate(date: fromDate ?? "")) cancellation charges will be \(currency ?? "") \(flatFee ?? 0).\n\n"
                        }
                        else if flatFee != nil && currency != nil {
                            cancellationText += "\u{2022} Cancellation charges will be \(currency ?? "") \(flatFee ?? 0). \n\n"
                        }
                        else if currency != nil && percent != nil {
                            if percent == 100 {
                                cancellationText += "\u{2022} Full refund if you cancel this booking by \(getCancellationDate(date: fromDate ?? "")).\n\n"
                            }
                            else {
                                cancellationText += "\u{2022} Cancellation charges will be \(percent ?? 0) percent \(currency ?? "").\n\n"
                            }
                        }
                    }
                    
                    self.lblCancellationPolicy.text = cancellationText
                }
            }
        }
    }
    //MARK: - @IBActions
    @IBAction func closeOnPress(_ sender: UIButton) {
        self.dismiss()
    }
}

// MARK: - UITABLEVIEW METHODS
extension HotelMoreDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceBreakup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PriceBreakupCell")
        
        cell?.textLabel?.text = priceBreakup[indexPath.row]
        cell?.detailTextLabel?.text = prices[indexPath.row]
        
        return cell ?? UITableViewCell()
    }
}

// MARK: - COLLECTIONVIEW METHODS
extension HotelMoreDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomAmenities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FacilityCollectionXIB().identifire, for: indexPath) as! FacilityCollectionXIB
        
        cell.lblTitle.text = roomAmenities[indexPath.row]
        cell.imgDot.image = .checkMark()
        cell.imgWidth.constant = 24
        cell.imgHeight.constant = 24
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2 , height: 30)
    }
}
