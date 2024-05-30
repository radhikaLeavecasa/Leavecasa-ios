//
//  BaggageDetailsVC.swift
//  LeaveCasa
//
//  Created by acme on 20/12/22.
//

import UIKit

class BaggageDetailsVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblCabinBaggage: UILabel!
    @IBOutlet weak var lblCheckInBaggage: UILabel!
    @IBOutlet weak var lblDestinationSource: UILabel!
    //MARK: - Variables
    var source : String?
    var checkIn : String?
    var cabin : String?
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblDestinationSource.text = self.source
        self.lblCabinBaggage.text = self.cabin
        self.lblCheckInBaggage.text = self.checkIn
    }
    //MARK: - @IBActions
    @IBAction func clossOnPress(_ sender: UIButton) {
        self.dismiss()
    }
}
