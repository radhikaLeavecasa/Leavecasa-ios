//
//  UIColorExtention.swift
//  Josh
//
//  Created by Esfera-Macmini on 21/03/22.
//

import UIKit

extension UIColor{
    
    class func theamColor() -> UIColor {
        return UIColor.init(named: "TEXT_BLACK_COLOR") ?? UIColor()
    }
    
    class func filterColor() -> UIColor {
        return UIColor.init(named: "FILTER_BG_COLOR") ?? UIColor()
    }
    
    class func customPink() -> UIColor {
        return UIColor.init(named: "CUSTOM_PINK") ?? UIColor()
    }
    
    class func lightBlue() -> UIColor {
        return UIColor.init(named: "LIGHT_BLUE") ?? UIColor()
    }
    
    class func tabbrBGColor() -> UIColor {
        return UIColor.init(named: "TABBAR_BG_COLOR") ?? UIColor()
    }
    
    class func grayColor() -> UIColor {
        return UIColor.init(named: "GARK_GRAY_COLOR") ?? UIColor()
    }
    
    class func cutomRedColor() -> UIColor{
        return UIColor.init(named: "GRADIENT_RED") ?? UIColor()
    }
    
    class func otpSelectedColor() -> UIColor{
        return UIColor.init(named: "OTP_SELECTED_COLOR") ?? UIColor()
    }
    
    class func customBlueColor() -> UIColor{
        return UIColor.init(named: "BLUE_COLOR") ?? UIColor()
    }
    
    class func customLightRedColor() -> UIColor{
        return UIColor.init(named: "RED_LIGHT_COLOR") ?? UIColor()
    }
    
    class func customLightGrayColor() -> UIColor{
        return UIColor.init(named: "GRAY_COLOR") ?? UIColor()
    }
    
    class func customGrayDateTimeColor() -> UIColor{
        return UIColor.init(named: "BG_GRAY_DATETIME") ?? UIColor()
    }
    
    class func lightGreyColor() -> UIColor{
        return UIColor.init(named: "LIGHT_GREY_COLOR") ?? UIColor()
    }
}
