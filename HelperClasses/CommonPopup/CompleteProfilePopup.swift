//
//  CompleteProfilePopup.swift
//  LeaveCasa
//
//  Created by acme on 07/10/22.
//

import UIKit
import IBAnimatable

class CompleteProfilePopup: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var imgLogo: AnimatableImageView!
    @IBOutlet weak var btnYess: AnimatableButton!
    @IBOutlet weak var btnNo: AnimatableButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    //MARK: - Variables
    var isNoHide = false
    var yesTitle = ""
    var noTitle = ""
    var tapCallback: (() -> Void)?
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 20, width: 200, height: 30)
        let attributedString = NSMutableAttributedString.init(string: "Skip Now")
        
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 2, range:
                                        NSRange.init(location: 0, length: attributedString.length));
        btnNo.setAttributedTitle(attributedString, for: .normal)
        btnNo.addSubview(label)
        self.btnYess.cornerRadius = 10
        self.btnYess.setTitle(self.yesTitle, for: .normal)
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
