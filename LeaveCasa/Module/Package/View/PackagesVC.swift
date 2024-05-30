//
//  PackagesVC.swift
//  LeaveCasa
//
//  Created by acme on 01/04/24.
//

import UIKit
import IBAnimatable
import SearchTextField

class PackagesVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var txtFldDestination: SearchTextField!
    @IBOutlet weak var imgVwPackage: AnimatableImageView!
    //MARK: - Variables
    var cityName1 = String()
    var imgPackage = String()
   // lazy var cityName = [String]()
    var objSearchViewModel = SearchViewModel()
    var viewModel = PackagesVM()
    var selectedLineColor : UIColor = UIColor.darkGray
    var lineColor : UIColor = UIColor.darkGray
    let border = CALayer()
    var lineHeight : CGFloat = CGFloat(1.0)
    var param = [String:Any]()
    var citCountryName = [String]()
    var selectedCode = String()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if LoaderClass.shared.arrSearchResultAll.count == 0 {
            LoaderClass.shared.loadAnimation()
            self.objSearchViewModel.searchPackageCity(view: self)
        }
        self.objSearchViewModel.delegate = self
       // self.viewModel.delegate = self
        txtFldDestination.text = cityName1
        viewModel.destination = cityName1
        imgVwPackage.sd_setImage(with: URL(string: imgPackage), placeholderImage: .placeHolder())
        self.txtFldDestination.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
        LoaderClass.shared.txtFldborder(txtFld: txtFldDestination)
    }
    //MARK: - Custom methods
    @objc func searchCity(_ sender: UITextField) {
        apiReload()
//        if self.cityName.count > 0 {
//            self.cityName.removeAll()
//        }
    }
    //MARK: - @IBActions
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
    @IBAction func actionSearch(_ sender: Any) {
        if txtFldDestination.text != "" || selectedCode != "" {
            LoaderClass.shared.loadAnimation()
            self.param = ["destination": txtFldDestination.text?.components(separatedBy: ",").count ?? 0 > 0 ? txtFldDestination.text!.components(separatedBy: ",")[0] : txtFldDestination.text!]
            viewModel.destination = txtFldDestination.text?.components(separatedBy: ",").count ?? 0 > 0 ? txtFldDestination.text!.components(separatedBy: ",")[0] : txtFldDestination.text!
            viewModel.searchByDestinationApi(param: param, view: self)
        } else {
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: "Please choose destination from dropdown")
        }
    }
}
extension PackagesVC: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        apiReload()
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

extension PackagesVC:ResponseProtocol{
    func onSuccess() {
        
    }
    
        
    func apiReload() {
        if citCountryName.count == 0 {
            for i in LoaderClass.shared.arrSearchResultAll {
                if i.city == nil {
                    citCountryName.append(i.country ?? "")
                } else {
                    citCountryName.append("\(i.city ?? ""),\(i.country ?? "")")
                }
            }
        }
        txtFldDestination.theme = SearchTextFieldTheme.lightTheme()
        txtFldDestination.theme.font = .systemFont(ofSize: 12)
        txtFldDestination.theme.bgColor = UIColor.white
        txtFldDestination.theme.fontColor = UIColor.black
        txtFldDestination.theme.cellHeight = 40
        txtFldDestination.filterStrings(self.citCountryName)
        txtFldDestination.isFilter = true
        txtFldDestination.itemSelectionHandler = { filteredResults, itemPosition in
            if filteredResults.count > 0 {
                let item = filteredResults[itemPosition]
                self.txtFldDestination.text = item.title
                self.selectedCode = item.title
                self.txtFldDestination.resignFirstResponder()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            LoaderClass.shared.stopAnimation()
        })
    }
}
