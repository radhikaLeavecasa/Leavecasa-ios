//
//  WalletVC.swift
//  LeaveCasa
//
//  Created by acme on 30/09/22.
//

import UIKit
import Razorpay
import IBAnimatable

class WalletVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblTransactionHistory: UILabel!
//    @IBOutlet weak var txtMoney: UITextField!
//    @IBOutlet weak var addMoneyView: AnimatableView!
//    @IBOutlet weak var lblWalletBalance: UILabel!
    @IBOutlet weak var tableVIew: UITableView!
//    @IBOutlet weak var btnAddMoney: AnimatableButton!
//    @IBOutlet weak var lblCurrency: UILabel!
    //MARK: - Variables
    var viewModel = WalletViewModel()
    typealias Razorpay = RazorpayCheckout
    var razorpay: RazorpayCheckout!
    let refreshControl = UIRefreshControl()
    //MARK: - Custom methods
    internal func showPaymentForm(currency : String, amount: Double, name: String, description : String, contact: String, email: String ,isForWallet:Bool = false){
        let options: [String:Any] = [
            "amount": "\(amount * 100)", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": "INR", //We support more that 92 international currencies.
            //                    "description": description,
            "name": Cookies.userInfo()?.name ?? "",
            "prefill": [
                "contact": Cookies.userInfo()?.mobile ?? "",
                "email": Cookies.userInfo()?.email ?? ""
            ],
            "theme": [
                "color": "#FF2D55"
            ]
        ]
        
        self.razorpay.open(options)
    }
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.interactivePopGestureRecognizer?.delegate = nil

    }
    override func viewWillAppear(_ animated: Bool) {
        //MARK: CAll API
        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false {
            self.viewModel.delegate = self
            self.setupTableView()
            self.lblTransactionHistory.isHidden = self.viewModel.transectionData.count == 0
        } else {
            self.tableVIew.ragisterNib(nibName: WalletTransectionXIB().identifier)
            self.tableVIew.ragisterNib(nibName: NoDataFoundXIB().identifire)
        }
    }
  
    //MARK: - Custom methods
    func setupTableView(){
        self.tableVIew.ragisterNib(nibName: WalletTransectionXIB().identifier)
        self.tableVIew.ragisterNib(nibName: NoDataFoundXIB().identifire)
        self.tableVIew.tableFooterView = UIView()
        self.viewModel.fatchWalletTransection(view: self)
        tableVIew.reloadData()
        self.lblTransactionHistory.isHidden = self.viewModel.transectionData.count == 0
      //  self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
       // self.tableVIew.addSubview(refreshControl) // not required when using UITableViewController
        
    }
    
//    @objc func refresh(_ sender: AnyObject) {
//        self.viewModel.fatchWalletTransection(view: self)
//        self.lblTransactionHistory.isHidden = self.viewModel.transectionData.count == 0
//    }
    //MARK: - @IBActions
//    @IBAction func addMoney(_ sender: UIButton) {
//        view.endEditing(true)
//        self.showPaymentForm(currency: "INR", amount: round(Double(Int(self.txtMoney.text ?? "") ?? 0)), name: "", description: "", contact: "", email: "")
//    }
//
//    @IBAction func closeOnPress(_ sender: UIButton) {
//        self.addMoneyView.isHidden = true
//    }
//
//    @IBAction func addMoneyOnPress(_ sender: UIButton) {
//        self.addMoneyView.isHidden = false
//    }
    
}

extension WalletVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.transectionData.count == 0 || WebService.isConnectedToInternet() == false{
            return 1
        }else{
            return self.viewModel.transectionData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.transectionData.count == 0 || WebService.isConnectedToInternet() == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundXIB().identifire, for: indexPath) as! NoDataFoundXIB
            if WebService.isConnectedToInternet() == false {
                cell.img.image = .internetConnection()
                cell.lblTitleMsg.text = AlertMessages.NOT_CONNECTED_TO_INTERNET
                cell.lblMsg.text = AlertMessages.DISCONNECTED
                cell.lblSubTitleMsg.text = ""
            } else {
                cell.cnstImgVwTop.constant = 0
                cell.img.image =  UIImage(named: "ic_transaction_history")
                cell.imgVwNoData.constant = 200
                cell.lblTitleMsg.text = ""
                cell.lblMsg.text = AlertMessages.NO_HISTORY_FOUND
                cell.lblSubTitleMsg.text = ""
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletTransectionXIB().identifier, for: indexPath) as! WalletTransectionXIB
            let indexdata = self.viewModel.transectionData[indexPath.row]
            cell.lblDate.text = self.setStartDate(date: indexdata["date_of_transaction"] as? String ?? "")
            cell.lblTitle.text = "\(indexdata["type"] as? String ?? "")".capitalized
            
            if (indexdata["credited"] as? Double) != nil {
                cell.lblPrice.text = "₹\(String(format: "%g", indexdata["credited"] as? Double ?? 0.0))"
                cell.imgType.image = UIImage(named: "ic_credit")
            }
            else if (indexdata["debited"] as? Double) != nil {
                cell.lblPrice.text = "₹\(String(format: "%g", indexdata["debited"] as? Double ?? 0.0))"
                cell.imgType.image = UIImage(named: "ic_debit")
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 90
        return UITableView.automaticDimension
    }
}

extension WalletVC:ResponseProtocol{
    func onSuccess() {
      //  self.refreshControl.endRefreshing()
        self.lblTransactionHistory.isHidden = self.viewModel.transectionData.count == 0
//        self.addMoneyView.isHidden = true
//        self.lblWalletBalance.text = "₹\(self.viewModel.available_balance)"
        self.tableVIew.reloadData()
    }
    
    func onFail(msg: String) {
        if msg == CommonError.INTERNET {
            self.refreshControl.endRefreshing()
            self.tableVIew.reloadData()
        }
        else {
            LoaderClass.shared.stopAnimation()
            pushNoInterConnection(view: self,titleMsg: "Alert", msg: msg)
        }
    }
}

extension WalletVC: RazorpayPaymentCompletionProtocolWithData {
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        debugPrint("error: ", code)
        pushNoInterConnection(view: self,titleMsg: "Alert", msg: str)
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        debugPrint("success: ", payment_id)
    }
}

//extension WalletVC : RazorpayPaymentCompletionProtocol {
//
//    func onPaymentError(_ code: Int32, description str: String) {
//        debugPrint("error: ", code, str)
//        pushNoInterConnection(view: self,titleMsg: "Alert", msg: str)
//    }
//
//    func onPaymentSuccess(_ payment_id: String) {
//        debugPrint("success: ", payment_id)
//        let param = ["credited":self.txtMoney.text ?? "","type":"credit by wallet","payment_id":payment_id]
//        self.viewModel.addWalletBalance(param: param,view: self)
//    }
//}
