//
//  NoInternetVC.swift
//  LeaveCasa
//
//  Created by acme on 13/02/23.
//

import UIKit

class NoInternetVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var imgVwAlert: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    //MARK: - Variables
    typealias noInternet = () -> Void
    var noInternetDelegate: noInternet? = nil
    var image = String()
    var msgTitle = String()
    var msg = String()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        imgVwAlert.image = UIImage(named: "\(image)")
        lblMessage.text = msg
        lblTitle.text = msgTitle
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            if self.image == "Airplane" {
                LoaderClass.shared.setupGIF("Airplane", imgVW: self.imgVwAlert)
            } else if self.image == "Bus" {
                LoaderClass.shared.setupGIF("Bus", imgVW: self.imgVwAlert)
            } else if self.image == "Hotel" {
                LoaderClass.shared.setupGIF("Hotel", imgVW: self.imgVwAlert)
            }
        }
    }
    //MARK: - @IBActions
    @IBAction func backOnPress(_ sender: UIButton) {
        dismiss(animated: true) {
            guard let noInternet = self.noInternetDelegate else { return }
            noInternet()
        }
    }
}
