//
//  EditProfileViewModel.swift
//  LeaveCasa
//
//  Created by acme on 06/10/22.
//

import Foundation
import UIKit
class EditProfileViewModel{
    
    var delegate : ResponseProtocol?
    
    func logoutDeleteAccApi(param:[String:Any], view: UIViewController, type: String){
        WebService.callApi(api: .logout, param: param, header: true) {status,msg,response in
            LoaderClass.shared.stopAnimation()
            if status == true {
                view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: type == "logout" ? "Logout successfully!" : "Account deleted successfully!")
                if let vc = ViewControllerHelper.getViewController(ofType: .PhoneLoginVC, StoryboardName: .Main) as? PhoneLoginVC {
                    Cookies.deleteUserInfo()
                    Cookies.deleteUserToken()
                    vc.hidesBottomBarWhenPushed = true
                    view.navigationController?.setViewControllers([vc], animated: true)
                }
            }else{
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    LoaderClass.shared.stopAnimation()
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
    
    func callEditProfile(param:[String:Any],view:UIViewController){
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .updateProfile, param: param,header: true) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            if status {
                let responseData = response as? [String:Any] ?? [:]
                if let data = responseData[CommonParam.DATA] as? [String:Any]{
                    Cookies.userInfoSave(dict: data)
                }
                self.delegate?.onSuccess()
            }else{
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    LoaderClass.shared.stopAnimation()
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
    
    func callUpdateNotification(param:[String:Any],view:UIViewController){
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .updateNotification, param: param,header: true) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            if status == true{
                let responseData = response as? [String:Any] ?? [:]
                if let data = responseData[CommonParam.DATA] as? [String:Any]{
                    Cookies.userInfoSave(dict: data)
                }
                self.delegate?.onSuccess()
            }else{
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    LoaderClass.shared.stopAnimation()
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
    
    func callUploadProfile(param:[String:Any],media:UIImage,view:UIViewController){
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .profilePic, media: media, fileName: "image", param: param) { status, msg, response in
            if status == true{
                self.callEditProfile(param: param,view: view)
            }else{
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    LoaderClass.shared.stopAnimation()
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
}
