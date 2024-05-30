//
//  InsurancePopUpVCViewController.swift
//  LeaveCasa
//
//  Created by acme on 29/04/24.
//

import UIKit
import IBAnimatable

class InsurancePopUpVC: UIViewController {
      
    //MARK: - Variables
    @IBOutlet var btnYesNo: [AnimatableButton]!
    typealias tableCellCompletion = (_ yes: Bool) -> Void
    var tableCellDelegate: tableCellCompletion? = nil
    var selectedTab = 1
    //MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func actionYesNo(_ sender: UIButton) {
        selectedTab = sender.tag
        for btn in btnYesNo {
            if sender.tag == btn.tag {
                btn.isSelected = true
                btn.borderColor = .clear
            } else {
                btn.isSelected = false
                btn.borderColor = .black
            }
        }
//        if sender.tag == 0 {
//            btnYesNo[0].isSelected = true
//            btnYesNo[1].isSelected = false
//        } else {
//            btnYesNo[0].isSelected = false
//            btnYesNo[1].isSelected = true
//        }
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        self.dismiss(animated: true) {
            guard let tableCell = self.tableCellDelegate else { return }
            tableCell(self.selectedTab == 0 ? true : false)
        }
    }
}
