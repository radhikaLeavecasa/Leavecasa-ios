//
//  CouponAppliedVC.swift
//  LeaveCasa
//
//  Created by acme on 21/07/23.
//

import UIKit
import IBAnimatable

class CouponAppliedVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var btnOk: AnimatableButton!
    @IBOutlet weak var lblCouponApplied: UILabel!
    //MARK: - Variable
    var couponPrize = String()
    //MARK: - Lifecycele methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCouponApplied.text = "You have saved ₹\(couponPrize)"
    }
    //MARK: - 
    @IBAction func actionOk(_ sender: Any) {
        self.dismiss()
    }
}
