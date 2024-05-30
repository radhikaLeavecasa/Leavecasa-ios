//
//  DateCollectionXIB.swift
//  LeaveCasa
//
//  Created by acme on 01/11/22.
//

import UIKit
import IBAnimatable

class DateCollectionXIB: UICollectionViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var vwOuter: AnimatableView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    //MARK: - Variable
    let identifire = "DateCollectionXIB"
}
