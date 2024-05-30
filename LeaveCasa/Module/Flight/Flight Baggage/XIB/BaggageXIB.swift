//
//  BaggageXIB.swift
//  LeaveCasa
//
//  Created by acme on 21/11/22.
//

import UIKit

class BaggageXIB: UITableViewCell {

    @IBOutlet weak var lblPRice: UILabel!
    @IBOutlet weak var lblWaight: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgCheck: UIImageView!
    let identifire = "BaggageXIB"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
