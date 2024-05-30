//
//  OtpVC.swift
//  LeaveCasa
//
//  Created by acme on 13/09/22.
//

import UIKit
import IBAnimatable
import OTPFieldView

class OtpVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var otpTextFieldView: OTPFieldView!
    @IBOutlet weak var btnContinew: AnimatableButton!
    @IBOutlet weak var lblReverseCountDown: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var backView: AnimatableView!
    
    //MARK: - Variables
    var viewModel = OtpViewModel()
    var isOtpComplete = false
    var phoneNumber = String()
    var countryCode = String()
    var email = String()
    var timerValue = 30
    var timer = Timer()
    var otp = Int()
    var otpVerify = Int()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupOtpView()
        self.startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer.invalidate()
        self.timerValue = 0
    }
    //MARK: - Custom methods
    func startTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        
        if self.timerValue > 0 {
            self.timerValue -= 1
            self.lblReverseCountDown.isHidden = false
            self.lblReverseCountDown.text = "\(Strings.TIME_REMAINING) \(self.timeString(time: TimeInterval(timerValue)))"
            self.btnResend.alpha = 0.5
            self.btnResend.isUserInteractionEnabled = false
        }else{
            self.timer.invalidate()
            self.lblReverseCountDown.isHidden = true
            self.lblReverseCountDown.text = "\(Strings.TIME_REMAINING) 00:00"
            self.btnResend.alpha = 1
            self.btnResend.isUserInteractionEnabled = true
        }
    }
    
    func setupOtpView(){
        self.otpTextFieldView.fieldsCount = 4
        self.otpTextFieldView.fieldBorderWidth = 1
        self.otpTextFieldView.filledBackgroundColor = .white
        self.otpTextFieldView.defaultBackgroundColor = .white
        self.otpTextFieldView.defaultBorderColor = UIColor.clear
        self.otpTextFieldView.filledBorderColor = .lightBlue()
        self.otpTextFieldView.cursorColor = .theamColor()
        self.otpTextFieldView.displayType = .square
        self.otpTextFieldView.fieldSize = 64
        self.otpTextFieldView.separatorSpace = 10
        self.otpTextFieldView.shouldAllowIntermediateEditing = false
        self.otpTextFieldView.delegate = self
        self.otpTextFieldView.initializeUI()
    }
    //MARK: - @IBActions
    @IBAction func continewOnPress(_ sender: UIButton) {
        if self.isOtpComplete == true {
            if email == "demo@leavecasa.com" && self.otp == 1234 {
                LoaderClass.shared.loadAnimation()
                let param = ["email": self.email,
                             CommonParam.OTP: self.otp,
                             CommonParam.DEVICE_TOKEN: Cookies.getDeviceToken(),
                             CommonParam.DEVICE_TYPE: "0",
                             CommonParam.DEVICE_ID: "\(UIDevice.current.identifierForVendor?.uuidString ?? "")"] as [String : Any]
                self.viewModel.otpVerify(param: param, view: self, api: .emailVerifyOtp)
            } else if otpVerify != self.otp && email != "" {
                pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.INVALID_OTP)
            } else {
                LoaderClass.shared.loadAnimation()
                let param = email == "" ? [CommonParam.MOBILE_NUMBER: self.phoneNumber,
                                           CommonParam.COUNTY_CODE: self.countryCode,
                                           CommonParam.OTP: self.otp,
                                           CommonParam.DEVICE_TOKEN: Cookies.getDeviceToken(),
                                           CommonParam.DEVICE_TYPE: "0",
                                           CommonParam.DEVICE_ID: "\(UIDevice.current.identifierForVendor?.uuidString ?? "")"] as [String : Any] : ["email": self.email,
                                                                                                                                                    CommonParam.OTP: self.otp,
                                                                                                                                                    CommonParam.DEVICE_TOKEN: Cookies.getDeviceToken(),
                                                                                                                                                    CommonParam.DEVICE_TYPE: "0",
                                                                                                                                                    CommonParam.DEVICE_ID: "\(UIDevice.current.identifierForVendor?.uuidString ?? "")"]
                self.viewModel.otpVerify(param: param, view: self, api: email == "" ? .verifyOtp : .emailVerifyOtp)
            }
        } else {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: CommonMessage.ENTER_OTP)
        }
    }
    
    @IBAction func resendOnPress(_ sender: UIButton) {
        self.timerValue = 30
        self.startTimer()
        self.viewModel.resendOtp(param: [CommonParam.MOBILE_NUMBER:self.phoneNumber,CommonParam.COUNTY_CODE:self.countryCode], view: self)
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
    
}

extension OtpVC: OTPFieldViewDelegate {
    
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        //print("Has entered all OTP? \(hasEntered)")
        self.isOtpComplete = hasEntered
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        // print("OTPString: \(otpString)")
        self.otp = Int(otpString) ?? 0
    }
}
