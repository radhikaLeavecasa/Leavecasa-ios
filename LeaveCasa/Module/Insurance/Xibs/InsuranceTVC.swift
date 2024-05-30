//
//  InsuranceTVC.swift
//  LeaveCasa
//
//  Created by acme on 08/05/24.
//

import UIKit
import IBAnimatable

class InsuranceTVC: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var btnSelect: AnimatableButton!
    @IBOutlet weak var btnPlanCoverage: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescp: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPerPerson: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 20, width: 200, height: 30)
        let attributedString = NSMutableAttributedString.init(string: "Coverage Details")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 2, range:
                                        NSRange.init(location: 0, length: attributedString.length));
        btnPlanCoverage.setAttributedTitle(attributedString, for: .normal)
    }
}
