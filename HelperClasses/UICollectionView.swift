//
//  UICollectionView.swift
//  Josh
//
//  Created by Esfera-Macmini on 29/03/22.
//

import UIKit

extension UICollectionView{
    
    func ragisterNib(nibName:String){
        self.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
    func registerFooterNib(nibName: String) {
        self.register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: nibName)
    }
}

extension UICollectionViewCell{
    func getIdentifier() -> String{
        return "\(self)"
    }
}
