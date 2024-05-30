//
//  ProfileVC.swift
//  LeaveCasa
//
//  Created by acme on 27/09/22.
//

import UIKit
import IBAnimatable

class ProfileVC: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var cnstTrailingBackBtn: NSLayoutConstraint!
    @IBOutlet weak var btnEditProfile: AnimatableButton!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var lblHide: UILabel!
    @IBOutlet weak var lblShow: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: AnimatableImageView!
    @IBOutlet weak var cnstBackButtonWidth: NSLayoutConstraint!
    //MARK: - Variables
    var viewModel = EditProfileViewModel()
    var param = [String:Any]()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
       // self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cnstTrailingBackBtn.constant = tabBarController?.selectedIndex == 0 || tabBarController?.selectedIndex == 1 || tabBarController?.selectedIndex == 2 || tabBarController?.selectedIndex == 4 || tabBarController?.selectedIndex == 3 ? 0 : 15
        btnBack.isHidden = tabBarController?.selectedIndex == 0 || tabBarController?.selectedIndex == 1 || tabBarController?.selectedIndex == 2 || tabBarController?.selectedIndex == 4 || tabBarController?.selectedIndex == 3
        cnstBackButtonWidth.constant = tabBarController?.selectedIndex == 0 || tabBarController?.selectedIndex == 1 || tabBarController?.selectedIndex == 2 || tabBarController?.selectedIndex == 4 || tabBarController?.selectedIndex == 3 ? 0 : 32
        btnEditProfile.isUserInteractionEnabled = true
        self.lblVersion.text = "Version : \(GetData.share.getAppVersion())"
        
        self.setupProfileData()
    }
    @IBAction func actionSocials(_ sender: UIButton) {
        let appURL = URL(string: sender.tag == 0 ? "https://www.facebook.com/leavecasaa?mibextid=LQQJ4d" : sender.tag == 1 ? "https://www.instagram.com/leavecasa/?igshid=NGVhN2U2NjQ0Yg%3D%3D" : "https://www.linkedin.com/company/leavecasa/")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            let webURL = URL(string: sender.tag == 0 ? "https://www.facebook.com/leavecasaa?mibextid=LQQJ4d" : sender.tag == 1 ? "https://www.instagram.com/leavecasa/?igshid=NGVhN2U2NjQ0Yg%3D%3D" : "https://www.linkedin.com/company/leavecasa/")!
            application.open(webURL)
        }
    }
    
    //MARK: - Custom methods
    func setupProfileData(){
        
        self.lblName.text = Cookies.userInfo()?.name
        self.lblEmail.text = Cookies.userInfo()?.email == "" || Cookies.userInfo()?.email == nil ? "Email missing" : "\(Cookies.userInfo()?.email ?? "") (\(Cookies.userInfo()?.emailVerified == 1 ? "Verfied" : "Not Verified"))"
        self.lblContactNumber.text = Cookies.userInfo()?.mobile
        self.imgUser.sd_setImage(with: URL(string: "\(Cookies.userInfo()?.profile_pic ?? "")"), placeholderImage: .placeHolderProfile())
        
        if Cookies.userInfo()?.notification_setting == 0{
            self.btnSwitch.isOn = false
            self.lblHide.text = "OFF"
        } else {
            self.lblHide.text = "ON"
            self.btnSwitch.isOn = true
        }
    }
    
    //MARK: - @IBAction
    @IBAction func editIOnPress(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .EditProfileVC, StoryboardName: .Main) as? EditProfileVC {
            btnEditProfile.isUserInteractionEnabled = false
            self.pushView(vc: vc)
        }
    }
    @IBAction func myTripOnPress(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    @IBAction func notificationOnPress(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 3
    }
    @IBAction func actionAboutUs(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
            self.pushView(vc: vc,title: "About Us")
        }
    }
    @IBAction func actionTermsConditions(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
            self.pushView(vc: vc,title: "Terms and Conditions")
        }
    }
    @IBAction func actopnPrivacyPolicy(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
            self.pushView(vc: vc,title: "Privacy Policy")
        }
    }
    @IBAction func actionHelpSupport(_ sender: Any) {
        if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
            self.pushView(vc: vc,title: "Help & Support")
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
    @IBAction func logoutOnPress(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .CommonPopupVC, StoryboardName: .Main) as? CommonPopupVC {
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.noTitle = AlertKeys.NO
            vc.yesTitle = AlertKeys.YES
            if sender.tag == 0 {
                vc.type = "delete"
            } else {
                vc.type = "logout"
            }
            vc.tapCallback = {
                self.param[CommonParam.TYPE] = sender.tag == 1 ? "logout" : "remove"
                self.viewModel.logoutDeleteAccApi(param: self.param, view: self, type: sender.tag == 1 ? "logout" : "remove")
            }
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func slideOnPress(_ sender: UISwitch) {
        var param = [String:Any]()
        if sender.isOn == true{
            self.btnSwitch.isOn = true
            param["notification_setting"] = 1
            self.lblHide.text = "ON"
            
        }else{
            self.btnSwitch.isOn = false
            param["notification_setting"] = 0
            self.lblHide.text = "OFF"
        }
        self.viewModel.callUpdateNotification(param: param,view: self)
    }
}

extension ProfileVC:ResponseProtocol{
    func onSuccess() {
        self.setupProfileData()
    }
}
