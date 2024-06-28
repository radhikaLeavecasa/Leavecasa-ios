//
//  TaxBifurcationVC.swift
//  LeaveCasa
//
//  Created by acme on 15/02/24.
//

import UIKit

class TaxBifurcationVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var lblOtAndGst: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var cnstTop: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    //MARK: - Variables
    var otherChagerOrOT: String?
    var tax: String?
    var titleStr: String?
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblOtAndGst.textColor = title == "FareFlight" ? .white : .black
        cnstTop.constant = titleStr == "" ? 0 : title == "Visa" ? 10  : 20
        lblOtAndGst.text = otherChagerOrOT
        lblTax.text = tax
        lblTitle.text = titleStr
        lblTitle.font = UIFont.regularFont(size: 15)
    }
}
