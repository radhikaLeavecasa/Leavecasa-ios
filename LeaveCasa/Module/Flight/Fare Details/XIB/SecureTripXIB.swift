//
//  SecureTripXIB.swift
//  LeaveCasa
//
//  Created by acme on 22/11/22.
//

import UIKit

class SecureTripXIB: UITableViewCell {

    @IBOutlet weak var btnSecure: UIButton!
    @IBOutlet weak var btnUnsecure: UIButton!
    
    let identifire = "SecureTripXIB"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
