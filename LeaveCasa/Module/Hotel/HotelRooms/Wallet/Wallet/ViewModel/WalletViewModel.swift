//
//  WalletViewModel.swift
//  LeaveCasa
//
//  Created by acme on 07/10/22.
//

import Foundation
import UIKit


class WalletViewModel{
    
    var delegate : ResponseProtocol?
    var available_balance = String()
    
    var transectionData = [[String:Any]]()
    
    func fatchWalletTransection(view: UIViewController) {
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .walletTransection,method: .get ,param: [:],header: true) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            if status == true{
                debugPrint(response)
                if let data = response as? [String:Any] {
                    if let data = data[CommonParam.DATA] as? [[String:Any]]{
                        self.transectionData = data.reversed()
                        self.delegate?.onSuccess()
                    }
                }
            }else{
                self.delegate?.onFail?(msg: msg)
            }
        }
    }
}
