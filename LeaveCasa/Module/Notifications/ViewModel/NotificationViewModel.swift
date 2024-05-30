//
//  NotificationViewModel.swift
//  LeaveCasa
//
//  Created by acme on 03/02/23.
//

import Foundation
import ObjectMapper

class NotificationViewModel{
    
    var delegate : ResponseProtocol?
    var modelData : NotificationModel?
    
    func getNotification(view:UIViewController){
    
        WebService.callApi(api: .notification,method: .get ,param: [:],header: true){ status, msg,response in
            LoaderClass.shared.stopAnimation()
            if status == true{
                let data = response as? [String:Any] ?? [:]
                let responseModel = Mapper<NotificationModel>().map(JSON: data)
                self.modelData = responseModel
                self.delegate?.onSuccess()
            }else{
                self.delegate?.onFail?(msg: msg)
                LoaderClass.shared.stopAnimation()
                view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
            }
        }
    }
}
