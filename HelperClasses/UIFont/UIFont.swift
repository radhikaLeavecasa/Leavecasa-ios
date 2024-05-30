//
//  UIFont.swift
//  LeaveCasa
//
//  Created by acme on 19/09/22.
//

import UIKit

extension UIFont{
    
    class func boldFont(size:CGFloat) -> UIFont{
        return UIFont(name: "Metropolis-Bold", size: size) ?? UIFont()
    }
    
    class func regularFont(size:CGFloat) -> UIFont{
        return UIFont(name: "Metropolis-Regular", size: size) ?? UIFont()
    }
}
