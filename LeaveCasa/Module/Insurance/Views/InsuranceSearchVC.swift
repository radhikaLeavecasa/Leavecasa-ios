//
//  InsuranceSearchVC.swift
//  LeaveCasa
//
//  Created by acme on 06/05/24.
//

import UIKit
import SearchTextField
import DropDown
import IBAnimatable

class InsuranceSearchVC: UIViewController {
   
    //MARK: - @IBOutlets
    @IBOutlet weak var txtFldPlanCategory: SearchTextField!
    @IBOutlet weak var txtFldDepartureDate: UITextField!
    @IBOutlet weak var txtFldDestination: SearchTextField!
    @IBOutlet weak var txtFldReturn: UITextField!
    @IBOutlet weak var txtDuration: UITextField!
    @IBOutlet weak var collVwPassengerAge: UICollectionView!
    @IBOutlet weak var constCollVwHeight: NSLayoutConstraint!
    @IBOutlet var btnOptions: [AnimatableButton]!
    @IBOutlet weak var vwReturn: UIView!
    @IBOutlet weak var vwDuration: UIView!
    @IBOutlet weak var txtFldPassenger: UITextField!
    //MARK: - Variable
    
    var arrAge = [String]()
    var selectedDestination = Int()
    var selectedTab = 0
    var isFromCheckin = true
    var checkinDate = Date()
    var checkoutDate = Date()
    var arrPassenger = [String]()
    var viewModel = InsuranceSearchVM()
    var paxCount = Int()
    var selectedPlan = Int()
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        for i in 1..<10 {
            actionSingleMultiTrip(btnOptions[0])
            arrPassenger.append("\(i)")
        }
        setDates()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        constCollVwHeight.constant = collVwPassengerAge.contentSize.height
    }
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
    @IBAction func actionSingleMultiTrip(_ sender: UIButton) {
        selectedTab = sender.tag
        for btn in btnOptions {
            if btn.tag == sender.tag {
                btn.backgroundColor = .lightBlue()
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = .boldFont(size: 16)
            } else {
                btn.backgroundColor = .clear
                btn.setTitleColor(.black, for: .normal)
                btn.titleLabel?.font = .boldFont(size: 14)
            }
        }
        txtFldDestination.text = ""
        selectedDestination = 0
        vwReturn.isHidden = sender.tag == 1
        vwDuration.isHidden = sender.tag == 1
    }
    //MARK: - @IBActions
    @IBAction func actionSubmit(_ sender: Any) {
        if txtFldDestination.text != "" {
            if selectedPlan != 0 {
                if areAllTextFieldsFilled() {
                    arrAge = []
                    for index in 0..<collVwPassengerAge.numberOfItems(inSection: 0) {
                        let indexPath = IndexPath(item: index, section: 0)
                        if let cell = collVwPassengerAge.cellForItem(at: indexPath) as? PaxCVC {
                            let text = cell.txtFldCount.text ?? ""
                            arrAge.append(text)
                        }
                    }
                    let param = [WSRequestParams.WS_REQS_PARAM_PLANCATEGORY: selectedPlan,
                                 WSRequestParams.WS_REQS_PARAM_PLANCOVERAGE: selectedDestination,
                                 WSRequestParams.WS_REQS_PARAM_PLAN_TYPE: "\(selectedTab+1)",
                                 WSRequestParams.WS_REQS_PARAM_TRAVELSTART: convertDateFormat(date: txtFldDepartureDate.text ?? "", getFormat: "yyyy-MM-dd", dateFormat: "MMM dd, yyyy"),
                                 WSRequestParams.WS_REQS_PARAM_TRAVEL_END: selectedTab == 0 ? convertDateFormat(date: txtFldReturn.text ?? "", getFormat: "yyyy-MM-dd", dateFormat: "MMM dd, yyyy") : "",
                                 WSRequestParams.WS_REQS_PARAM_NO_OF_PAX: txtFldPassenger.text ?? "1",
                                 WSRequestParams.WS_REQS_PARAM_PAX_AGE: arrAge] as [String:AnyObject]
                    LoaderClass.shared.loadAnimation()
                    paxCount = Int(txtFldPassenger.text ?? "1") ?? 1
                    viewModel.insuranceApi(param: param, view: self)
                }
            } else {
                pushNoInterConnection(view: self, titleMsg: "Alert", msg: "Please choose plan category")
            }
        } else {
            pushNoInterConnection(view: self, titleMsg: "Alert", msg: "Please choose destination")
        }
    }
    func showShortDropDown(textFeild:UITextField? = nil,data:[String]){
        let dropDown = DropDown()
        textFeild?.resignFirstResponder()
        
        dropDown.anchorView = textFeild?.plainView
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.cellHeight = 55
        dropDown.dataSource = data
        dropDown.show()
   
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if textFeild == txtFldDestination {
                selectedDestination = index+1
                txtFldDestination.text = item
            } else if textFeild == txtFldPlanCategory {
                txtFldPlanCategory.text = item
                selectedPlan = index+1
            } else {
                txtFldPassenger.text = item
                collVwPassengerAge.reloadData()
                collVwPassengerAge.layoutIfNeeded()
                constCollVwHeight.constant = collVwPassengerAge.contentSize.height
            }
        }
    }
    func areAllTextFieldsFilled() -> Bool {
        for cell in collVwPassengerAge.visibleCells {
            if let myCell = cell as? PaxCVC {
                if myCell.txtFldCount.text?.isEmpty ?? true {
                    pushNoInterConnection(view: self, titleMsg: "Alert", msg: "Please enter all ages")
                    return false
                }
            }
        }
        return true
    }
    func setDates() {
        self.txtFldDepartureDate.text = setJournyDate(formate: DateFormat.monthDateYear)
        self.txtFldReturn.text = nextCheckOutDate(DateFormat.monthDateYear,Date())
    }
    func openDateCalendar(textFeild:UITextField) {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            if let calendar = UIStoryboard.init(name: ViewControllerType.WWCalendarTimeSelector.rawValue, bundle: nil).instantiateInitialViewController() as? WWCalendarTimeSelector {
                calendar.delegate = self
                calendar.optionCurrentDate = self.returnDate(self.txtFldDepartureDate.text ?? "", strFormat: "MMM dd, yyyy")
                calendar.optionShowTopPanel = true
                calendar.optionStyles.showDateMonth(true)
                calendar.optionStyles.showMonth(false)
                calendar.optionStyles.showYear(true)
                calendar.optionStyles.showTime(false)
                calendar.optionButtonShowCancel = true
                self.present(calendar, animated: true, completion: nil)
            }
        })
    }
    func updateCollectionViewHeight() {
        var totalHeight: CGFloat = 0
        for index in 0..<(Int(self.txtFldPassenger.text ?? "0") ?? 1) {
            let indexPath = IndexPath(item: index, section: 0)
            let cellHeight = collectionView(collVwPassengerAge, layout: collVwPassengerAge.collectionViewLayout, sizeForItemAt: indexPath).height
            totalHeight += cellHeight
        }
        constCollVwHeight.constant = totalHeight
    }
}

extension InsuranceSearchVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtFldDestination {
            self.showShortDropDown(textFeild: textField, data: GetData.share.getInsuranceDestination())
        } else if textField == self.txtFldPassenger {
            self.showShortDropDown(textFeild: textField, data: arrPassenger)
        } else if textField == self.txtFldPlanCategory {
            self.showShortDropDown(textFeild: textField, data: GetData.share.getPlanCategory())
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtFldDepartureDate || textField == self.txtFldReturn {
            if selectedTab == 1 {
                self.openDateCalendar(textFeild: textField)
                return false
            } else {
                if let vc = ViewControllerHelper.getViewController(ofType: .CalendarPopUpVC, StoryboardName: .Hotels) as? CalendarPopUpVC{
                    vc.firstDate = returnDate(txtFldDepartureDate.text ?? "", strFormat: "MMM dd, yyyy")
                    vc.lastDate = returnDate(txtFldReturn.text ?? "", strFormat: "MMM dd, yyyy")
                    
                    vc.doneCompletion = { [self]
                        firstDate, lastDate in
                        self.txtFldDepartureDate.text = self.convertDateFormat(date: firstDate, getFormat: "MMM dd, yyyy", dateFormat: "yyyy-MM-dd")
                        self.txtFldReturn.text = self.convertDateFormat(date: lastDate, getFormat: "MMM dd, yyyy", dateFormat: "yyyy-MM-dd")
                        let days = LoaderClass.shared.calculateDaysBetweenDates(dateString1: txtFldDepartureDate.text ?? "", dateString2: txtFldReturn.text ?? "", dateFormat: DateFormat.monthDateYear)
                        self.txtDuration.text = days ?? 0 > 1 ? "\((days ?? 0)) Days" : "\((days ?? 0)) Day"
                    }
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true)
                }
                self.isFromCheckin = textField == self.txtFldDepartureDate
                return false
            }
        } else if textField == txtDuration {
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let indexpath = IndexPath(row: textField.tag, section: 0)
        let cell = self.collVwPassengerAge.cellForItem(at: indexpath) as! PaxCVC
        if textField == cell.txtFldCount {
            // Get the resulting string after the replace operation
            let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            
            // Check if the resulting string is empty or not
            if updatedString.isEmpty {
                return true
            }
            
            // Check if the resulting string is a valid number
            guard let age = Int(updatedString) else {
                return false
            }
            return age <= 120
        }
        return true
    }
    
    
}
extension InsuranceSearchVC: WWCalendarTimeSelectorProtocol {
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        if date < Date() {
            return false
        } else if !isFromCheckin {
            if date < checkinDate {
                return false
            } else {
                return true
            }
        }else {
            return true
        }
    }
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        if self.isFromCheckin {
            checkinDate = date
            self.txtFldDepartureDate.text = self.convertDateWithDateFormater(DateFormat.monthDateYear, date)
            self.txtFldReturn.text = self.nextCheckOutDate(DateFormat.monthDateYear, date)
            self.checkoutDate = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? Date()
        } else {
            checkoutDate = date
            self.txtFldReturn.text = self.convertDateWithDateFormater(DateFormat.monthDateYear, date)
        }
        let days = LoaderClass.shared.calculateDaysBetweenDates(dateString1: txtFldDepartureDate.text ?? "", dateString2: txtFldReturn.text ?? "", dateFormat: DateFormat.monthDateYear)
        self.txtDuration.text = days ?? 0 > 1 ? "\(days ?? 0) Days" : "\(days ?? 1) Day"
    }
}

extension InsuranceSearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(self.txtFldPassenger.text ?? "0") ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaxCVC", for: indexPath) as! PaxCVC
        cell.lblPax.text = "Pax \(indexPath.row+1)"
        cell.txtFldCount.tag = indexPath.row
        cell.txtFldCount.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collVwPassengerAge.frame.size.width/3 - 5, height: 90)
    }
}

extension InsuranceSearchVC: ResponseProtocol{
    func onSuccess() {
        LoaderClass.shared.stopAnimation()
        if viewModel.insuranceModel?.responseStatus != 1 {
            self.pushNoInterConnection(view: self,titleMsg: "Alert!", msg: viewModel.insuranceModel?.error?.errorMessage ?? "")
        } else {
            if let vc = ViewControllerHelper.getViewController(ofType: .InsuranceListVC, StoryboardName: .Main) as? InsuranceListVC {
                vc.arrInsuranceList = viewModel.insuranceModel?.results ?? []
                vc.paxCount = paxCount
                vc.isDomesticType = selectedDestination == 4 ? true : false
                vc.traceId = viewModel.insuranceModel?.traceId ?? ""
                self.pushView(vc: vc)
            }
        }
    }
}
