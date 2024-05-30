//
//  RequestCallBackVC.swift
//  LeaveCasa
//
//  Created by acme on 01/04/24.
//

import UIKit
import IQKeyboardManagerSwift

class RequestCallBackVC: UIViewController, UITextFieldDelegate {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var txtFldDestination: UITextField!
    @IBOutlet weak var txtFldMobile: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var vwDestination: UIView!
    @IBOutlet weak var txtVwMessage: IQTextView!
    
    //MARK: - Variables
    var viewModel = RequestCallBackVM()
    var param = [String:Any]()
    var destination = String()
    var selectedLineColor : UIColor = UIColor.darkGray
    var lineColor : UIColor = UIColor.darkGray
    let border = CALayer()
    var lineHeight : CGFloat = CGFloat(1.0)
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        vwDestination.isHidden = self.title == "Home"
        LoaderClass.shared.txtFldborder(txtFld: txtFldName)
        LoaderClass.shared.txtFldborder(txtFld: txtFldDestination)
        LoaderClass.shared.txtFldborder(txtFld: txtFldMobile)
        LoaderClass.shared.txtFldborder(txtFld: txtFldEmail)
        txtFldDestination.text = destination
        txtFldDestination.isUserInteractionEnabled = false
        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false {
            self.txtFldName.text = "\(Cookies.userInfo()?.name.components(separatedBy: " ")[0] ?? "") \(Cookies.userInfo()?.name.components(separatedBy: " ").count ?? 0 > 1 ? Cookies.userInfo()?.name.components(separatedBy: " ")[1] ?? "" : "")"
            self.txtFldMobile.text = Cookies.userInfo()?.mobile
            self.txtFldEmail.text = Cookies.userInfo()?.email
        }
    }
    //MARK: - @IBActions
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
   
    @IBAction func actionSendEnquiry(_ sender: UIButton) {
        if isValidateData() {
            LoaderClass.shared.loadAnimation()
            self.param = ["destination": txtFldDestination.text ?? "",
                          "customer_email": txtFldEmail.text ?? "",
                          "customer_phone":txtFldMobile.text ?? "",
                          "customer_name":txtFldName.text ?? "",
                          "customer_message":txtVwMessage.text ?? "",
                          "type":sender.tag == 0 ? "enquiry" : "callback"]
            
            viewModel.requestCallBackApi(param: self.param, view: self)
        }
    }
    func isValidateData() -> Bool {
        if txtFldName.text?.isEmptyCheck() == true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) \(CommonMessage.PLEASE_FILL_NAME)")
            return false
        } else if txtFldEmail.text?.isEmptyCheck() == true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) \(CommonMessage.PLEASE_FILL_EMAIL)")
            return false
        }else if txtFldEmail.text?.isValidEmail() == false {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) \(CommonMessage.PLEASE_FILL_VALID_EMAIL)")
            return false
        }else if txtVwMessage.text.isEmptyCheck() == true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: "\(CommonMessage.PLEASE_FILL) message")
            return false
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtFldMobile {
            let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            if newText.count > 15 {
                return false
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - lineHeight, width:  textField.frame.size.width, height: textField.frame.size.height)
        border.borderWidth = lineHeight
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        border.borderColor = UIColor.customPink().cgColor
        
        border.frame = CGRect(x: 0, y: textField.frame.size.height - lineHeight, width: textField.frame.size.width, height: textField.frame.size.height)
        border.borderWidth = lineHeight
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
}
