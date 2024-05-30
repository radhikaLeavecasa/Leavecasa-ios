//
//  FlighFoodXIB.swift
//  LeaveCasa
//
//  Created by acme on 21/11/22.
//

import UIKit

class FlighFoodXIB: UICollectionViewCell {

    @IBOutlet weak var imgFood: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    
    let identifire = "FlighFoodXIB"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
