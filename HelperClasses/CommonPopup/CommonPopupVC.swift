//
//  CommonPopupVC.swift
//  LeaveCasa
//
//  Created by acme on 07/10/22.
//

import UIKit
import IBAnimatable

class CommonPopupVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var imgLogo: AnimatableImageView!
    @IBOutlet weak var btnYess: AnimatableButton!
    @IBOutlet weak var btnNo: AnimatableButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    //MARK: - Variables
    var isNoHide = false
    var yesTitle = ""
    var noTitle = ""
    var msg = "Logout"
    var tapCallback: (() -> Void)?
    var type = ""
    var titleStr = ""
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNote.isHidden = type != "Hotel Cancel" && type != "Bus Cancel" && type != "Flight Cancel"
        lblNote.text = "Note: Cancellation of this booking will cost ₹\(type == "Hotel Cancel" || type == "Flight Cancel" ? 200 : 50)(+18% GST) as service charges."
        self.btnYess.setTitle(self.yesTitle, for: .normal)
        self.btnNo.setTitle(self.noTitle, for: .normal)
        self.lblMsg.text = titleStr
        self.lblTitle.text = msg
        self.imgLogo.isHidden = isNoHide
        
        if type == "delete" {
            self.imgLogo.image = UIImage(named: "ic_delAccount")
            self.lblMsg.text = "Are you sure you want to delete the account?"
            self.lblTitle.text = "Comeback Soon!"
        } else if type == "logout" {
            self.imgLogo.image = UIImage(named: "ic_logout_red")
            self.lblMsg.text = "Are you sure you want to logout?"
            self.lblTitle.text = "Logout"
        } else if type == "Insurance Cancel" {
            self.imgLogo.image = UIImage(named: "ic_insurance")
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            if self.type != "delete" && self.type != "logout" && self.type != "Insurance Cancel" {
                LoaderClass.shared.setupGIF(self.type == "Hotel Cancel" ? "Hotel" : self.type == "Bus Cancel" ? "Bus" : "Airplane", imgVW: self.imgLogo)
            }
        }
    }
    //MARK: - @IBActions
    @IBAction func yesOnPress(_ sender: UIButton) {
        self.dismiss()
        self.tapCallback?()
    }
    
    @IBAction func noOnPress(_ sender: UIButton) {
        self.dismiss()
    }
}
