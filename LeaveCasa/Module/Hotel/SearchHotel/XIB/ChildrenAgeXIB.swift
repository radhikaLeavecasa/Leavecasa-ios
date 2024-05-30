//
//  ChildrenAgeXIB.swift
//  LeaveCasa
//
//  Created by acme on 09/09/22.
//

import UIKit

class ChildrenAgeXIB: UITableViewCell {

    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var lblChildCount: UILabel!
    @IBOutlet weak var btnPlusChild: UIButton!
    @IBOutlet weak var btnMinusChild: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
