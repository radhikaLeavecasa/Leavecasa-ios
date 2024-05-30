//
//  FareBrakeupVC.swift
//  LeaveCasa
//
//  Created by acme on 22/11/22.
//

import UIKit

class FareBrakeupVC: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblBaseFare: UILabel!
    
    //MARK: - Variables
    var dataFlight = Flight()
    var basePrice = Double()
    var discount = Double()
    var taxes = Double()
    var ssrModel : SsrFlightModel?
    var arrBaseFare = [("ic_meal","Meals"),("ic_baggage","Extra baggage"), ("ic_flightSeat","Seats"), ("ic_tax","Taxes & Fees"),("ic_convenienceFee","Convenience Fee (Incl. of GST)"),("ic_discount","Discount")]
    var convenientFee = Double()
    var conBirfurcation = Double()
    var seatPrice = Double()
    var baggagePrice = Double()
    var mealPrice = Double()
    var taxesK3 = Double()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblBaseFare.text = "₹\(Int(basePrice))" // BASE FEE NOT PUBLISHED PRICE
        tableViewHeight.constant = CGFloat(arrBaseFare.count*60)
        lblTotalPrice.text = "₹\(String(format: "%.0f", basePrice + convenientFee + seatPrice + baggagePrice + mealPrice + taxes - discount))"
        self.setupTableView()
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.ragisterNib(nibName: "AddOnXIB")
        self.tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
        
    }
    
    //MARK: Add Observer For TableView Height
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Strings.CONTENT_SIZE {
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                DispatchQueue.main.async {
                    self.tableViewHeight.constant = newsize.height
                }
            }
        }
    }
}

extension FareBrakeupVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBaseFare.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddOnXIB", for: indexPath) as! AddOnXIB
        cell.lblTitle.text = arrBaseFare[indexPath.row].1
        cell.lblPrice.textColor = arrBaseFare.count - 1 == indexPath.row ? .customPink() : .black
        cell.imgVwBaseFare.image = UIImage(named: arrBaseFare[indexPath.row].0)
        cell.imgVwInfo.isHidden = true
        
        switch indexPath.row {
        case 0:
            cell.lblPrice.text = "₹\(String(format: "%.0f", mealPrice))"
        case 1:
            cell.lblPrice.text = "₹\(String(format: "%.0f", baggagePrice))"
        case 2:
            cell.lblPrice.text = "₹\(String(format: "%.0f", seatPrice))"
        case 3:
            cell.lblPrice.text = "₹\(String(format: "%.0f", taxes))"
            cell.imgVwInfo.isHidden = false
        case 4:
            cell.lblPrice.text = "₹\(String(format: "%.0f", convenientFee))"
            cell.imgVwInfo.isHidden = false
        case 5:
            cell.lblPrice.text = "₹\(String(format: "%.0f", discount))"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 3 || indexPath.row == 4 {
            if let cell = tableView.cellForRow(at: indexPath) {
                if let vc = ViewControllerHelper.getViewController(ofType: .TaxBifurcationVC, StoryboardName: .Flight) as? TaxBifurcationVC {
                    if indexPath.row == 3 {
                        vc.otherChagerOrOT = "Other Taxes: ₹\((taxes-taxesK3).rounded())"
                        vc.tax = "K3 Tax: ₹\(taxesK3)"
                        vc.titleStr = "Taxes"
                    } else if indexPath.row == 4 {
                        vc.titleStr = "Convenience Fee Detail"
                        vc.tax = convenientFee == 236 ? "Convenience Fee: ₹200" : "Convenience Fee: ₹400" //\(convenientFee-conBirfurcation)"
                        vc.otherChagerOrOT = convenientFee == 236 ? "GST(18%): ₹36" : "GST(18%): ₹72" //\(conBirfurcation)"
                    }
                    LoaderClass.shared.presentPopover(self, vc, sender: cell, size: CGSize(width: 315, height: 120),arrowDirection: .any)
                }
            }
        }
    }
}
extension FareBrakeupVC: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
