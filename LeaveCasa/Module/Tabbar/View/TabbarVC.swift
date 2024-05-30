//
//  TabbarVC.swift
//  LeaveCasa
//
//  Created by acme on 08/09/22.
//

import UIKit
import CoreLocation

class TabbarVC: UITabBarController, UITabBarControllerDelegate {
    //MARK: - Variables
    var locationManager:CLLocationManager!
    var Index = 2
    var showAlert = false
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabbar()
        if showAlert {
            // Check App New Update Available
            VersionCheck.shared.checkForUpdate { (isUpdate) in
                if isUpdate {
                    DispatchQueue.main.async {
                        Alert.showAlertWithOkCancel(message: "Upgrade your travel experience. New features just a click away!", actionOk: "Update", actionCancel: "Skip") {
                            if let url = URL(string: "https://apps.apple.com/in/app/leavecasa/id1640461250"),
                               UIApplication.shared.canOpenURL(url){
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                                self.showAlert = false
                            }
                        } completionCancel: {
                            self.showAlert = false
                        }
                    }
                }
            }
        }
    }
    //MARK: - Setup Tabbar ViewController
    func setupTabbar(){
        
        self.tabBar.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        self.tabBar.layer.shadowRadius = 8
        self.tabBar.layer.shadowColor = UIColor.gray.cgColor
        self.tabBar.layer.shadowOpacity = 0.3
        self.tabBar.layer.cornerRadius = 15
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.tabBar.backgroundColor = .tabbrBGColor()
        self.tabBar.tintColor = .cutomRedColor()
        
        //ADD View Controllers
        let wallet = ViewControllerHelper.getViewController(ofType: .WalletVC, StoryboardName: .Main) as! WalletVC
        let walletIcon = UITabBarItem(title: "History", image: .walletUnselect(), selectedImage: .walletSelected())
        wallet.tabBarItem = walletIcon
        
        let home = ViewControllerHelper.getViewController(ofType: .HomeVC, StoryboardName: .Main) as! HomeVC
        let homeIcon = UITabBarItem(title: "", image: .homeUnselect(), selectedImage: .homeSelected())
        home.tabBarItem = homeIcon
        
        let trips = ViewControllerHelper.getViewController(ofType: .TripsVC, StoryboardName: .Main) as! TripsVC
        let tripsIcon = UITabBarItem(title: "My Trips", image: .tripUnselect(), selectedImage: .tripSelected())
        trips.tabBarItem = tripsIcon
        
        let notification = ViewControllerHelper.getViewController(ofType: .NotificationVC, StoryboardName: .Main) as! NotificationVC
        let notificationIcon = UITabBarItem(title: "Notification", image: .notificationUnselect(), selectedImage: .notificationSelected())
        notification.tabBarItem = notificationIcon
        
        let profile = ViewControllerHelper.getViewController(ofType: .ProfileVC, StoryboardName: .Main) as! ProfileVC
        let profileIcon = UITabBarItem(title: "Profile", image: .profileUnselect(), selectedImage: .profileSelected())
        profile.tabBarItem = profileIcon
        
        let controllers = [wallet,trips,home,notification,profile]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
        self.selectedIndex = self.Index
        
        
        self.updateLocation()
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true && item.title == "History" || UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true && item.title == "My Trips" || UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true && item.title == "Notification" || UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true && item.title == "Profile" {
            let vc = ViewControllerHelper.getViewController(ofType: .GuestLoginVC, StoryboardName: .Main) as! GuestLoginVC
            vc.title = "tab"
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    func updateLocation(){
        self.locationManager = CLLocationManager()
        //        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() == true{
                self.locationManager.startUpdatingLocation()
            }
        }
    }
}
