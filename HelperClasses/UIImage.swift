//
//  UIImage.swift
//  Josh
//
//  Created by Esfera-Macmini on 01/07/22.
//

import UIKit

extension UIImage{
    
    
    class func flightSelectSeat() -> UIImage{
        return UIImage.init(named: "ic_flight_selected_seat 1") ?? UIImage()
    }
    
    class func busUnSelectSeat() -> UIImage{
        return UIImage.init(named: "ic_bus_seat_green") ?? UIImage()
    }
    
    class func bus() -> UIImage{
        return UIImage.init(named: "ic_bus") ?? UIImage()
    }
    
    class func flight() -> UIImage{
        return UIImage.init(named: "ic_flight") ?? UIImage()
    }
    
    class func flightBookSeat() -> UIImage{
        return UIImage.init(named: "ic_flight_Booked_seat") ?? UIImage()
    }
    
    class func squarPlacholder() -> UIImage{
        return UIImage.init(named: "square_landscape") ?? UIImage()
    }
    
    class func landscapePlacholder() -> UIImage{
        return UIImage.init(named: "landscape_placeholder") ?? UIImage()
    }
    
    class func placeHolder() -> UIImage{
        return UIImage.init(named: "ic_placeholder") ?? UIImage()
    }
    class func placeHolderProfile() -> UIImage{
        return UIImage.init(named: "ic_profilePic") ?? UIImage()
    }
    class func hotelplaceHolder() -> UIImage{
        return UIImage.init(named: "ic_hotelPlaceholder") ?? UIImage()
    }
    
    class func checkMark() -> UIImage {
        return UIImage.init(named: "ic_check") ?? UIImage()
    }
    
    class func uncheckMark() -> UIImage{
        return UIImage.init(named: "ic_uncheck") ?? UIImage()
    }
    
    class func homeSelected() -> UIImage{
        return UIImage.init(named: "ic_home_selected") ?? UIImage()
    }
    
    class func homeUnselect() -> UIImage{
        return UIImage.init(named: "ic_home_unselected") ?? UIImage()
    }
    
    class func profileSelected() -> UIImage{
        return UIImage.init(named: "ic_profile_selected") ?? UIImage()
    }
    
    class func profileUnselect() -> UIImage{
        return UIImage.init(named: "ic_profile_unselected") ?? UIImage()
    }
    
    class func tripSelected() -> UIImage{
        return UIImage.init(named: "ic_trip_selected") ?? UIImage()
    }
    
    class func tripUnselect() -> UIImage{
        return UIImage.init(named: "ic_trip_unselected") ?? UIImage()
    }
    
    class func notificationSelected() -> UIImage{
        return UIImage.init(named: "ic_notification_selected") ?? UIImage()
    }
    
    class func notificationUnselect() -> UIImage{
        return UIImage.init(named: "ic_notification_unselected") ?? UIImage()
    }
    
    class func walletSelected() -> UIImage{
        return UIImage.init(named: "ic_wallet_selected") ?? UIImage()
    }
    
    class func walletUnselect() -> UIImage{
        return UIImage.init(named: "ic_wallet_unselected") ?? UIImage()
    }
    
    class func internetConnection() -> UIImage{
        return UIImage.init(named: "no_internet") ?? UIImage()
    }
    
    class func noBuses() -> UIImage{
        return UIImage.init(named: "ic_no_bus") ?? UIImage()
    }
    
    class func noHotels() -> UIImage{
        return UIImage.init(named: "ic_no_hotel") ?? UIImage()
    }
    
    class func noFlight() -> UIImage{
        return UIImage.init(named: "ic_no_flight") ?? UIImage()
    }
}
