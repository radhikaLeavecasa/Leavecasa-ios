//
//  FlightFareRuleVC.swift
//  LeaveCasa
//
//  Created by acme on 16/12/22.
//

import UIKit
import WebKit

class FlightFareRuleVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var loadString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font = "<font face='Montserrat-Regular' size='13' color= 'black'>%@"
        let html = String(format: font, self.loadString)
        self.webView.loadHTMLString(html, baseURL: nil)

    }

    @IBAction func closeOnPress(_ sender: UIButton) {
        self.dismiss()
    }
    
}
