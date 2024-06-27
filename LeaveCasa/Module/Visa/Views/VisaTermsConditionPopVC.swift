//
//  VisaTermsConditionPopVC.swift
//  LeaveCasa
//
//  Created by acme on 27/06/24.
//

import UIKit

class VisaTermsConditionPopVC: UIViewController {

    @IBOutlet weak var lblTCText: UILabel!
    
    var termsCondText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTCText.text = termsCondText
    }
    @IBAction func actionCross(_ sender: Any) {
        dismiss()
    }
}
