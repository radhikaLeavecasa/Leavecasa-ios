//
//  FillVisaDetailsVC.swift
//  LeaveCasa
//
//  Created by acme on 26/06/24.
//

import UIKit
import Razorpay

class FillVisaDetailsVC: UIViewController, RazorpayProtocol, ResponseProtocol {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var lblTermsCondition: UILabel!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPhoneNumber: UITextField!
    @IBOutlet weak var txtFldFullName: UITextField!
    //MARK: - Variables
    var paramImg = [String: UIImage]()
    var paramUrls = [String: URL]()
    var param = [String: Any]()
    var viewModel = FillVisaDetailsVM()
    var termsText = String()
    var amount = Double()
    typealias Razorpay = RazorpayCheckout
    var razorpay: RazorpayCheckout!
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.razorpay = RazorpayCheckout.initWithKey(RazorpayKeys.Test, andDelegate: self)
        
        
        let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldFont(size: 14)]
        
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightBlue(), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,  NSAttributedString.Key.font: UIFont.boldFont(size: 14)] as [NSAttributedString.Key : Any]

        let partOne = NSMutableAttributedString(string: "Terms & Conditions ", attributes: yourOtherAttributes)
        let partTwo = NSMutableAttributedString(string: "of visa", attributes: yourAttributes)

        partOne.append(partTwo)
        lblTermsCondition.attributedText = partOne
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        lblTermsCondition.addGestureRecognizer(tapGesture)
    }
    //MARK: - @IBActions
    @IBAction func actionPayNow(_ sender: Any) {
        if isValidatePassanger() {
            param["phone"] = txtFldPhoneNumber.text
            param["email"] = txtFldEmail.text
            param["username"] = txtFldFullName.text
            
            self.showPaymentForm(currency: "INR", amount: self.amount, name: txtFldPhoneNumber.text!, description: "", contact: txtFldPhoneNumber.text!, email: txtFldEmail.text!)
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
    //MARK: - Custom method
    internal func showPaymentForm(currency : String, amount: Double, name: String, description : String, contact: String, email: String ,isForWallet:Bool = false){
        let options: [String:Any] = [
            "amount": "\(amount * 100)", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": "INR",//We support more that 92 international currencies.
            //                    "description": description,
            "name": name,
            "prefill": [
                "contact": contact,
                "email": email
            ],
            "theme": [
                "color": "#E30166"
            ]
        ]
        DispatchQueue.main.async {
            self.razorpay.open(options)
        }
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
       let tapLocation = gesture.location(in: lblTermsCondition)

           let layoutManager = NSLayoutManager()
           let textContainer = NSTextContainer(size: lblTermsCondition.bounds.size)

           let range = NSRange(location: 0, length: 19)
           let textBoundingRect = layoutManager.boundingRect(forGlyphRange: range, in: textContainer)

           if textBoundingRect.contains(tapLocation) {
               let characterIndex = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
               if characterIndex >= 0 && characterIndex <= 19 {
                   if let vc = ViewControllerHelper.getViewController(ofType: .VisaTermsConditionPopVC, StoryboardName: .Main) as? VisaTermsConditionPopVC {
                       vc.modalPresentationStyle = .overFullScreen
                       vc.modalTransitionStyle = .crossDissolve
                       vc.termsCondText = termsText
                       self.present(vc, animated: true)
                   }
               }
           }
    }
    
    func isValidatePassanger() -> Bool {
        
        if txtFldFullName.text?.isEmptyCheck() == true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.FULL_NAME)
            return false
        } else if txtFldPhoneNumber.text?.isEmptyCheck() == true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.MOBILE)
            return false
        }  else if txtFldEmail.text?.isEmptyCheck() == true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.EMAIL_ENTER)
            return false
        } else if txtFldEmail.text?.isValidEmail() == false {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.VALID_EMAIL)
            return false
        }
        return true
    }
    
    func onSuccess() {
        LoaderClass.shared.pushNoInterConnection(view: self, image: "", titleMsg: "",  msg: "") {
            if let vc = ViewControllerHelper.getViewController(ofType: .TabbarVC, StoryboardName: .Main) as? TabbarVC {
                vc.Index = UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false ? 2 : 1
                self.pushView(vc: vc)
            }
        }
    }
}

extension FillVisaDetailsVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFldPhoneNumber {
            let newText = (txtFldPhoneNumber.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            if newText.count > 15 {
                return false
            }
        }
        return true
    }
}

extension FillVisaDetailsVC : RazorpayPaymentCompletionProtocol {
    
    func onPaymentError(_ code: Int32, description str: String) {
        debugPrint("error: ", code, str)
        pushNoInterConnection(view: self,titleMsg: "Alert", msg: str)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        debugPrint("success: ", payment_id)
        LoaderClass.shared.loadAnimation()
        viewModel.applyVisaApi(param: param, paramImg: paramImg, paramUrl: paramUrls, view: self)
    }
}

extension FillVisaDetailsVC: RazorpayPaymentCompletionProtocolWithData {
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        debugPrint("error: ", code)
        pushNoInterConnection(view: self,titleMsg: "Alert", msg: str)
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        debugPrint("success: ", payment_id)
    }
}
