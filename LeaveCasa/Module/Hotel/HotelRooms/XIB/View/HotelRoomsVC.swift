//
//  HotelRoomsVC.swift
//  LeaveCasa
//
//  Created by acme on 12/09/22.
//

import UIKit
import IBAnimatable

class HotelRoomsVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var btnBook: AnimatableButton!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Variables
    var selectedIndex = Int()
    var hotelDetail: HotelDetail?
    var markups = [Markup]()
    var hotels: Hotels?
    var totalGuest = ""
    var totalRooms = ""
    var checkInDate = ""
    var checkOutDate = ""
    var searchId = ""
    var logId = 0
    var checkIn = ""
    var checkOut = ""
    var no_of_nights = 0
    var no_of_adults = 0
    var finalRooms = [[String: AnyObject]]()
    var conviencefee = Int()
    var gst = Int()
    var taxes = Double()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.setupTableView()
    }
    
    //MARK: - @IBActions
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
    
    @IBAction func bookOnPress(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .HotelConfirmBookingVC, StoryboardName: .Hotels) as? HotelConfirmBookingVC {
            vc.hotels = self.hotels
            vc.hotelDetail = self.hotelDetail
            vc.markups = self.markups
            vc.hotleRate = self.hotelDetail?.rates[self.selectedIndex]
            vc.totalRooms = self.totalRooms
            vc.totalGuest = self.totalGuest
            vc.checkInDate = self.checkInDate
            vc.checkOutDate = self.checkOutDate
            vc.logId = self.logId
            vc.searchId = self.searchId
            vc.checkIn = self.checkIn
            vc.checkOut = self.checkOut
            vc.no_of_nights = self.no_of_nights
            vc.finalRooms = finalRooms
            vc.taxes = taxes
            vc.conviencefee = conviencefee
            vc.gst = gst
            self.pushView(vc: vc)
        }
    }
    //MARK: - Custom methods
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.ragisterNib(nibName: HotelRoomXIB().identifire)
    }
    
    @objc func seeMoreDetails(sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .MoreinfoPopUpVC, StoryboardName: .Hotels) as? MoreinfoPopUpVC {
            vc.hotels = self.hotels
            vc.hotelDetail = self.hotelDetail
            vc.markups = self.markups
            vc.hotleRate = self.hotelDetail?.rates[sender.tag]
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
    }
    
    @objc func cancellationPolicy(sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .HotelCancellationPolicyVC, StoryboardName: .Hotels) as? HotelCancellationPolicyVC {
            let hotleRate = self.hotelDetail?.rates[sender.tag]
            var cancellationText = String()
            // Cancellation Policy
            if hotleRate?.sNonRefundable != nil {
                if hotleRate?.sNonRefundable == true {
                    cancellationText = "Non-refundable. If you choose to change or cancel this booking you will not be refunded any of the payment."
                } else if hotleRate?.sNonRefundable == false {
                    guard let cancelByDate = hotleRate?.sCancellationPolicy[WSResponseParams.WS_RESP_PARAM_CANCEL_BY_DATE] as? String else { return }
                    
                    cancellationText = "\u{2022} Full refund if you cancel this booking by \(getCancellationDate(date: cancelByDate)).\n\n \u{2022} First night cost (including taxes and fees) will be charged if you cancel this booking later than \((getCancellationDate(date: cancelByDate))).\n\n \u{2022} You might be charged upto the full cost of stay (including taxes & fees) if you do not check-in to the hotel.\n\n"
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
                    }
                }
            }
            vc.cancellationPolicy = cancellationText
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
    }
}

extension HotelRoomsVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hotelDetail?.rates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HotelRoomXIB().identifire, for: indexPath) as! HotelRoomXIB
        
        if self.selectedIndex == indexPath.row {
            cell.imgCheck.image = .checkMark()
            cell.backView.borderWidth = 1
            cell.backView.borderColor = .customBlueColor()
        }
        else {
            cell.imgCheck.image = .uncheckMark()
            cell.backView.borderWidth = 0
            cell.backView.borderColor = .clear
        }
        
        let dict = self.hotelDetail?.rates
        
        if var price = dict?[indexPath.row].sPrice as? Double {
            var tax = Double()
            for i in 0..<markups.count {
                let markup: Markup?
                markup = markups[i]
                if markup?.starRating == hotels?.iCategory {
                    if markup?.amountBy == Strings.PERCENT {
                        
                        print("base price \(price)")
                        let tax = ((price * (markup?.amount ?? 0) / 100) * 18) / 100
                        print("tax amount \(tax)")
                        price += (price * (markup?.amount ?? 0) / 100) + tax
                        print("total price \(price)")
                    } else {
                        print("base price \(price)")
                        let tax = ((markup?.amount ?? 0)  * 18) / 100
                        price += (markup?.amount ?? 0) + tax
                    }
                }
            }
            
            if price > 5000 {
                conviencefee = 400
            } else if price > 3000 {
                conviencefee = 250
            } else if price > 1200 {
                conviencefee = 150
            } else {
                conviencefee = 100
            }
            gst = (conviencefee * 18) / 100
            
            cell.lblTaxAndPernight.text = "(\(self.no_of_nights) \(self.no_of_nights > 1 ? "nights" : "night")/\(self.no_of_adults) \(self.no_of_adults > 1 ? "adults" : "adult")) Incl. of all"
          //  + ₹\(String(format: "%.0f", tax)) taxes & fees
            cell.lblPrice.text = "₹\(String(format: "%.0f", Double(Int(price)+conviencefee+gst)))"
        }
        
        cell.setupData(data: dict?[indexPath.row].sBoardingDetails as? [String] ?? [], isrefund: dict?[indexPath.row].sNonRefundable ?? false)
        
        cell.btnMoreInfo.tag = indexPath.row
        cell.btnMoreInfo.addTarget(self, action: #selector(self.seeMoreDetails(sender:)), for: .touchUpInside)
        
        cell.btnCancellationPolicy.tag = indexPath.row
        cell.btnCancellationPolicy.addTarget(self, action: #selector(self.cancellationPolicy(sender:)), for: .touchUpInside)
        
        if let rooms = dict?[indexPath.row].sRooms {
            for i in 0..<rooms.count {
                let newDict = rooms[i]
                cell.lblHotelName.text = "\(newDict.sRoomType)".capitalized
            }
        }
        
        cell.imgHotel.sd_setImage(with: URL(string: self.hotelDetail?.sImageUrl ?? ""), placeholderImage: .placeHolder())
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.tableView.reloadData()
    }
}
