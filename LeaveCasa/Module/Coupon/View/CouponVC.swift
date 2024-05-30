//
//  CouponVC.swift
//  LeaveCasa
//
//  Created by acme on 19/09/22.
//

import UIKit
import IBAnimatable

class CouponVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var txtFldCoupon: AnimatableTextField!
    @IBOutlet weak var btnApply: AnimatableButton!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Variables
    var viewModel = CouponViewModel()
    var couponData: [CouponData]?
    var selectedIndex = -1
    var isFromBus = false
    var isFromHotel = false
    var isFromFlight = false
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.viewModel.delegate = self
        
        if isFromHotel {
            self.viewModel.callHotelCoupons(view: self)
        }
        else if isFromBus {
            self.viewModel.callBusCoupons(view: self)
        }
        else if isFromFlight {
            self.viewModel.flightCoupons(view: self)
        }
    }
    override func viewDidLayoutSubviews() {
        self.btnApply.setTitle("APPLY", for: .normal)
    }
    
    //MARK: - Custom methods
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.ragisterNib(nibName: CouponXIB().identifire)
    }
    //MARK: - @IBActions
    @IBAction func applyPressed(_ sender: AnimatableButton) {
        if selectedIndex != -1 && sender.tag == 1 {
            self.dismiss()
            let discount = couponData?[selectedIndex].discountAmount ?? 0.0
            let couponCode = couponData?[selectedIndex].code ?? ""
            let couponId = couponData?[selectedIndex].couponId ?? 0
            
            if isFromHotel {
                hotelConfirmBookingVCDelegate?.applyCoupon(discount: discount, couponCode: couponCode, couponId: couponId)
            }
            else if isFromBus {
                confirmBusBookingVCDelegate?.applyCoupon(discount: discount, couponCode: couponCode, couponId: couponId)
            }
            else if isFromFlight {
                flightBookingDelegate?.applyCoupon(discount: discount, couponCode: couponCode, couponId: couponId)
            }
        } else if selectedIndex == -1 && sender.tag == 1 {
            Alert.showSimple(AlertMessages.SELECT_COUPON)
        } else if sender.tag == 0 && txtFldCoupon.text == "" {
            Alert.showSimple(AlertMessages.ENTER_COUPON_CODE)
        }
    }
}

extension CouponVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CouponXIB().identifire, for: indexPath) as! CouponXIB
        
        cell.lblCouponName.text = couponData?[indexPath.row].code ?? ""
        cell.lblCouponDescription.text = couponData?[indexPath.row].couponName ?? ""
        cell.lblCouponPrice.text = "₹\(String(format: "%.0f", couponData?[indexPath.row].discountAmount ?? 0))"
        
        if self.selectedIndex == indexPath.row {
            cell.imgCheck.image = .checkMark()
        }
        else {
            cell.imgCheck.image = .uncheckMark()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.tableView.reloadData()
    }
}

// MARK: - API RESPONSE METHODS
extension CouponVC: ResponseProtocol {
    func onSuccess() {
        self.couponData = self.viewModel.couponData
        btnApply.isHidden = self.couponData?.count ?? 0 == 0
        self.tableView.reloadData()
    }
    
    func onFail(msg: String) {
        
    }
}
