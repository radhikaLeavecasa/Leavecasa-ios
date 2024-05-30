//
//  MoreInfoVC.swift
//  LeaveCasa
//
//  Created by acme on 21/03/24.
//

import UIKit

class MoreInfoVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var txtFldMoreInfo: UILabel!
    var moreInfoText = String()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10 // adjust the value as needed

        // Create a NSAttributedString with the desired line spacing
        let attributedString = NSAttributedString(string: moreInfoText,
                                                  attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        // Set the attributedText property of the label with the attributedString
        txtFldMoreInfo.attributedText = attributedString
        
       // txtFldMoreInfo.text = moreInfoText
    }
    @IBAction func actionCross(_ sender: Any) {
        dismiss()
    }
}
