//
//  PaxPopUpVC.swift
//  LeaveCasa
//
//  Created by acme on 08/07/24.
//

import UIKit
import DropDown

class PaxPopUpVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var txtFldPax: UITextField!
    //MARK: - Variables
    var arrPassenger = [String]()
    let dropDown = DropDown()
    typealias completion = (_ count: String) -> Void
    var doneCompletion: completion? = nil
    //MARK: - Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1..<10 {
            arrPassenger.append("\(i)")
        }
    }
    //MARK: - @IBActions
    @IBAction func actionContinue(_ sender: UIButton) {
        if txtFldPax.text != "" {
            self.dismiss(animated: true) {
                guard let doneButton = self.doneCompletion else { return }
                doneButton(self.txtFldPax.text!)
            }
        } else {
            LoaderClass.shared.showSnackBar(message: "Please select the no. of pax")
        }
    }
    @IBAction func actionDropDown(_ sender: Any) {
        txtFldPax.becomeFirstResponder()
    }
}
extension PaxPopUpVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.showShortDropDown(textFeild: txtFldPax, data: arrPassenger, dropDown: dropDown) { val, index in
            self.txtFldPax.text = val
        }
        return false
    }
}
