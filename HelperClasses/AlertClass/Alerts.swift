//
//  Alerts.swift
//  Josh
//
//  Created by Esfera-Macmini on 20/04/22.
//

import UIKit

let appNameAlert = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String

class Alert: UIAlertController {
    class func showSimple(_ message: String, completionHandler: (() -> Swift.Void)? = nil) {
        DispatchQueue.main.async {
            _ = UIApplication.shared.keyWindow
            // let mainController = keywindow?.rootViewController
            let alert = UIAlertController(title: appNameAlert, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_: UIAlertAction!) in
                completionHandler?()
            }))
            UIApplication.topViewController()?.present(alert, animated: true, completion: {
            })
        }
    }
    
    //MARK: make sure you have navigation  view controller
    
    class func showComplex(title: String? = "",
                           message: String,
                           preferredStyle: UIAlertController.Style? = .alert,
                           cancelTilte: String,
                           otherButtons: String ...,
                           comletionHandler: ((Swift.Int) -> Swift.Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle!)
        
        for i in otherButtons {
            alert.addAction(UIAlertAction(title: i, style: UIAlertAction.Style.default,
                                          handler: { (action: UIAlertAction!) in
                                            
                                            comletionHandler?(alert.actions.firstIndex(of: action)!)
                                            
                                          }
            ))
            
        }
        if (cancelTilte as String?) != nil {
            alert.addAction(UIAlertAction(title: cancelTilte, style: UIAlertAction.Style.destructive,
                                          handler: { (action: UIAlertAction!) in
                                            
                                            comletionHandler?(alert.actions.firstIndex(of: action)!)
                                            
                                          }
            ))
        }
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: {
            
        })
        
    }
    
    class func showAlertWithOkCancel(message: String, actionOk: String, actionCancel: String, completionOk: @escaping(() -> ()), completionCancel: @escaping(() -> ())) {
        let alert = UIAlertController(title: appNameAlert, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: actionOk, style: .default) { (_) in
            completionOk()
        }
        let actionCancel = UIAlertAction(title: actionCancel, style: .default){ (_) in
            completionCancel()
        }
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertWithOk(message: String, actionOk: String,  completionOk: @escaping(() -> ())) {
        let alert = UIAlertController(title: appNameAlert, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: actionOk, style: .default) { (_) in
            completionOk()
        }
        
        alert.addAction(actionOk)
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
       
        return controller
    }
}




