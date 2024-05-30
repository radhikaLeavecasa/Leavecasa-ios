//
//  SplashVC.swift
//  LeaveCasa
//
//  Created by acme on 27/10/23.
//

import UIKit

class SplashVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var imgVwSplash: UIImageView!
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        sleep(5)
        LoaderClass.shared.setupGIF("Logo-Animation", imgVW: imgVwSplash)
        DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {
            
            let userToken = Cookies.getUserToken()
            let introDone = Cookies.getInto()

            if userToken.isEmpty == true {
                if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == true {
                    let vc = ViewControllerHelper.getViewController(ofType: .TabbarVC, StoryboardName: .Main) as! TabbarVC
                    vc.showAlert = true
                    self.setView(vc: vc)
                } else if introDone {
                    let vc = ViewControllerHelper.getViewController(ofType: .PhoneLoginVC, StoryboardName: .Main) as! PhoneLoginVC
                    self.setView(vc: vc)
                } else {
                    let vc = ViewControllerHelper.getViewController(ofType: .SlidingVC, StoryboardName: .Main) as! SlidingVC
                    self.setView(vc: vc)
                }
            } else {
                let vc = ViewControllerHelper.getViewController(ofType: .TabbarVC, StoryboardName: .Main) as! TabbarVC
                vc.showAlert = true
                self.setView(vc: vc)
            }
        })
    }
}
