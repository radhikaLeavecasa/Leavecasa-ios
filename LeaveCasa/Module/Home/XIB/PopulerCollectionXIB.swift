//
//  PopulerCollectionXIB.swift
//  LeaveCasa
//
//  Created by acme on 08/09/22.
//

import UIKit
import IBAnimatable

class PopulerCollectionXIB: UICollectionViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var imgHotel: UIImageView!
    @IBOutlet weak var rateView: AnimatableView!
    //MARK: - Variables
    let identifire = "PopulerCollectionXIB"
}
