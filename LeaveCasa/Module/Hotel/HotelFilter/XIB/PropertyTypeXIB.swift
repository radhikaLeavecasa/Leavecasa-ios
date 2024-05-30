//
//  PropertyTypeXIB.swift
//  LeaveCasa
//
//  Created by acme on 29/09/22.
//

import UIKit
import IBAnimatable

class PropertyTypeXIB: UICollectionViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var backView: AnimatableView!
    @IBOutlet weak var lblTitle: UILabel!
    //MARK: - Lifecycle methods
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        let targetSize = CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height)
//        let size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
//        
//        var newFrame = layoutAttributes.frame
//        newFrame.size.height = ceil(size.height)
//        layoutAttributes.frame = newFrame
//        
//        return layoutAttributes
//    }
}
