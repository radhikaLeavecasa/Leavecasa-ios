//
//  GuestLoginVC.swift
//  LeaveCasa
//
//  Created by acme on 29/12/23.
//

import UIKit
import DropDown

class GuestLoginVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var txtFldType: UITextField!
    @IBOutlet weak var lblAgree: UILabel!
    @IBOutlet weak var txtFldBookingID: UITextField!
    //MARK: - Variables
    var attributedString = NSMutableAttributedString()
    let dropDown = DropDown()
    var selectedLineColor : UIColor = UIColor.darkGray
    var lineColor : UIColor = UIColor.darkGray
    let border = CALayer()
    var lineHeight : CGFloat = CGFloat(1.0)
    var objGuestLoginVM = GuestLoginViewModel()
    //MARK: - Lifecycle Memthods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.objGuestLoginVM.delegate = self
        attributedString = NSMutableAttributedString(string: "By logging in, I agree to LeaveCasa Terms & Conditions, Cancellation Policy and Privacy Policy.")
        attributedText()
        LoaderClass.shared.txtFldborder(txtFld: txtFldType)
        LoaderClass.shared.txtFldborder(txtFld: txtFldBookingID)
    }
    //MARK: - @IBActions
    @IBAction func actionBack(_ sender: Any) {
        if title == "tab" {
            let vc = ViewControllerHelper.getViewController(ofType: .TabbarVC, StoryboardName: .Main) as! TabbarVC
            self.setView(vc: vc,animation: false)
        } else {
            popView()
        }
    }
    @IBAction func actionSubmit(_ sender: Any) {
        if txtFldBookingID.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: "Please enter Booking Id")
        } else if txtFldType.text == "" {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: "Please choose Booking Type")
        } else {
            objGuestLoginVM.guestBookingDetail(type: txtFldType.text?.lowercased() ?? "", bookingId: txtFldBookingID.text ?? "", view: self)
        }
    }
    @IBAction func actionLogin(_ sender: Any) {
        let vc = ViewControllerHelper.getViewController(ofType: .PhoneLoginVC, StoryboardName: .Main) as! PhoneLoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func attributedText(){
        
        // Apply underline to a specific range
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 36, length: 18))
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 56, length: 19))
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 80, length: 14))
        
        // Apply bold to a specific range
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightBlue(), range: NSRange(location: 36, length: 18))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightBlue(), range: NSRange(location: 56, length: 19))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightBlue(), range: NSRange(location: 80, length: 14))
        lblAgree.attributedText = attributedString
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        lblAgree.addGestureRecognizer(tapGesture)
        lblAgree.isUserInteractionEnabled = true
    }
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
     
        let text = (lblAgree.attributedText)?.string ?? ""
        let tapLocation = gesture.location(in: lblAgree)
        
        // Determine which range was tapped
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: lblAgree.frame.size)
        let textStorage = NSTextStorage(attributedString: attributedString)
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let characterIndex = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // Handle the tap on the specific range
        if characterIndex >= 0 && characterIndex < 95 {
            if characterIndex >= 36 && characterIndex <= 55 {
                if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
                    self.pushView(vc: vc,title: "Terms and Conditions")
                }
            } else if characterIndex >= 56 && characterIndex <= 76 {
                if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
                    self.pushView(vc: vc,title: "Cancellation Policy")
                }
            } else if characterIndex >= 80 && characterIndex <= 95 {
                if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
                    self.pushView(vc: vc,title: "Privacy Policy")
                }
            }
        }
    }
}

extension GuestLoginVC: UITextFieldDelegate, ResponseProtocol {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFldType {
            showShortDropDown(textFeild: textField, data: GetData.share.guestBookngType(), dropDown: dropDown) {val,_ in
                self.txtFldType.text = val
            }
            return false
        } 
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFldType || textField == txtFldBookingID  {
            border.borderColor = UIColor.customPink().cgColor
            border.frame = CGRect(x: 0, y: textField.frame.size.height - lineHeight, width:  textField.frame.size.width, height: textField.frame.size.height)
            border.borderWidth = lineHeight
            textField.layer.addSublayer(border)
            textField.layer.masksToBounds = true
        }
    }
    func onSuccess() {
        
        if txtFldType.text! == "Hotel" {
            if let vc = ViewControllerHelper.getViewController(ofType: .HotelTripDetailVC, StoryboardName: .Main) as? HotelTripDetailVC {
                vc.hotelDetail = objGuestLoginVM.hotelDetail
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if txtFldType.text! == "Bus" {
            if let vc = ViewControllerHelper.getViewController(ofType: .BusTripDetailVC, StoryboardName: .Main) as? BusTripDetailVC {
                vc.busDetail = objGuestLoginVM.busDetail
                vc.doneCompletion = {
                    val in
                    if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
                        vc.bookingId = "\(self.objGuestLoginVM.busDetail?.id ?? 0)"
                        vc.type = 2
                        self.pushView(vc: vc,title: AlertMessages.INVOICE)
                    }
                }
                self.present(vc, animated: true)
            }
        } else if txtFldType.text! == "Flight" {
            if let vc = ViewControllerHelper.getViewController(ofType: .FlightTripDetailVC, StoryboardName: .Main) as? FlightTripDetailVC {
                vc.flightDetail = objGuestLoginVM.flightDetail
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if let vc = ViewControllerHelper.getViewController(ofType: .InsuranceDetailVC, StoryboardName: .Main) as? InsuranceDetailVC {
                vc.bookingId = objGuestLoginVM.insurance?.details?.response?.itinerary?.bookingId ?? 0
                vc.viewModel.insuranceDetailModel = objGuestLoginVM.insurance?.details?.response?.itinerary
                vc.status = objGuestLoginVM.insurance?.status ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
