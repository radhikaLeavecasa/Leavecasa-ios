//
//  VisaDetailsVC.swift
//  LeaveCasa
//
//  Created by acme on 25/06/24.
//

import UIKit
import SearchTextField
import DropDown

class VisaDetailsVC: UIViewController, ResponseProtocol {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var txtFldStayPeroid: UITextField!
    @IBOutlet weak var txtFldValidity: UITextField!
    @IBOutlet weak var txtFldVisaType: UITextField!
    @IBOutlet weak var txtFldPassenger: UITextField!
    @IBOutlet weak var txtFldDestination: UITextField!
    //MARK: - Variables
    var viewModel = VisaDetailsVM()
    let dropDown = DropDown()
    var visaType = [String]()
    var arrPassenger = [String]()
    var selectedIndex = -1
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        LoaderClass.shared.loadAnimation()
        viewModel.getVisaCountries(self)
        for i in 1..<10 {
            arrPassenger.append("\(i)")
        }
    }
    //MARK: - @IBActions
    @IBAction func actionStayPeriod(_ sender: Any) {
        txtFldStayPeroid.becomeFirstResponder()
    }
    
    @IBAction func actionValidity(_ sender: Any) {
        txtFldValidity.becomeFirstResponder()
    }
    
    @IBAction func actionPassengers(_ sender: Any) {
        txtFldPassenger.becomeFirstResponder()
    }
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
    @IBAction func actionCountry(_ sender: Any) {
        txtFldDestination.becomeFirstResponder()
    }
    @IBAction func actionVisaType(_ sender: Any) {
        txtFldVisaType.becomeFirstResponder()
    }
    @IBAction func actionSearch(_ sender: Any) {
        view.endEditing(true)
        if self.txtFldDestination.text == "" {
            LoaderClass.shared.showSnackBar(message: "Please select the destination")
        } else if txtFldVisaType.text == "" {
            LoaderClass.shared.showSnackBar(message: "Please select the visa type")
        } else if txtFldValidity.text == "" {
            LoaderClass.shared.showSnackBar(message: "Please select the validity")
        } else if txtFldStayPeroid.text == "" {
            LoaderClass.shared.showSnackBar(message: "Please select the stay period")
        } else if txtFldPassenger.text == "" {
            LoaderClass.shared.showSnackBar(message: "Please select the no. of passenger")
        } else {
            let param = ["visa_id": viewModel.arrCountryDetails[selectedIndex].id ?? 0,
                         "validity": txtFldValidity.text!,
                         "stay_period": txtFldStayPeroid.text!,
                         "pax": txtFldPassenger.text!,
                         "user_id": UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false ? "\(Cookies.userInfo()?.id ?? 0)" : ""] as [String : Any]
            
            if let vc = ViewControllerHelper.getViewController(ofType: .CountryVisaDetailVC, StoryboardName: .Visa) as? CountryVisaDetailVC {
                vc.param = param
                vc.termsText = viewModel.termsData
                vc.visaDetails = viewModel.arrCountryDetails[selectedIndex]
                self.pushView(vc: vc)
            }
        }
    }
    //MARK: - Custom methods
    func onSuccess() {
        visaType = []
        for i in viewModel.arrCountryDetails {
            visaType.append(i.visaType ?? "")
        }
    }
}

extension VisaDetailsVC: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtFldDestination {
            self.showShortDropDown(textFeild: self.txtFldDestination, data: viewModel.arrCountries, dropDown: dropDown) { val, index in
                self.txtFldDestination.text = val
                self.txtFldVisaType.text = ""
                self.txtFldValidity.text = ""
                self.txtFldStayPeroid.text = ""
                LoaderClass.shared.loadAnimation()
                self.viewModel.getCountryDetails(self.txtFldDestination.text ?? "", view: self)
            }
        } else if textField == txtFldVisaType {
            if self.txtFldDestination.text == "" {
                LoaderClass.shared.showSnackBar(message: "Please select destination first")
            } else {
                self.showShortDropDown(textFeild: txtFldVisaType, data: self.visaType, dropDown: dropDown) { val, index in
                    self.txtFldVisaType.text = val
                    self.selectedIndex = index
                }
            }
        } else if textField == txtFldValidity {
            if self.txtFldVisaType.text == "" {
                LoaderClass.shared.showSnackBar(message: "Please select visa type first")
            } else {
                self.showShortDropDown(textFeild: txtFldValidity, data: viewModel.arrCountryDetails[selectedIndex].validity ?? [], dropDown: dropDown) { val, index in
                    self.txtFldValidity.text = val
                }
            }
        } else if textField == txtFldStayPeroid {
            if self.txtFldVisaType.text == "" {
                LoaderClass.shared.showSnackBar(message: "Please select visa type first")
            } else {
                self.showShortDropDown(textFeild: txtFldStayPeroid, data: viewModel.arrCountryDetails[selectedIndex].stayPeriod ?? [], dropDown: dropDown) { val, index in
                    self.txtFldStayPeroid.text = val
                }
            }
        } else if textField == self.txtFldPassenger {
            self.showShortDropDown(textFeild: txtFldPassenger, data: arrPassenger, dropDown: dropDown) { val, index in
                self.txtFldPassenger.text = val
            }
        }
        return false
    }
}
