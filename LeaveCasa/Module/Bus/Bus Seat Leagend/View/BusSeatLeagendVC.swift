//
//  BusSeatLeagendVC.swift
//  LeaveCasa
//
//  Created by acme on 17/10/22.
//

import UIKit

class BusSeatLeagendVC: UIViewController {
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: false)
    }
    //MARK: - @IBActions
    @IBAction func crossOnPress(_ sender: UIButton) {
        self.dismiss()
    }
}
