//
//  HotelCancellationPolicyVC.swift
//  LeaveCasa
//
//  Created by acme on 01/03/24.
//

import UIKit

class HotelCancellationPolicyVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblCancellationPolicy: UILabel!
    //MARK: - Variables
    var cancellationPolicy = String()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCancellationPolicy.text = cancellationPolicy
    }
    //MARK: - @IBActions
    @IBAction func actionCross(_ sender: Any) {
        dismiss()
    }
}
