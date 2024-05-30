//
//  HotelRoomXIB.swift
//  LeaveCasa
//
//  Created by acme on 12/09/22.
//

import UIKit
import IBAnimatable

class HotelRoomXIB: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var btnCancellationPolicy: UIButton!
    @IBOutlet weak var backView: AnimatableView!
    @IBOutlet weak var btnMoreInfo: UIButton!
    @IBOutlet weak var lblTaxAndPernight: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgHotel: UIImageView!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Variables
    var modelData = [String]()
    var isRefund = false
    var identifire = "HotelRoomXIB"
    //MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 20, width: 200, height: 30)
        let attributedString = NSMutableAttributedString.init(string: "More Info")
        let attributedString2 = NSMutableAttributedString.init(string: "Cancellation Policy")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 2, range:
                                        NSRange.init(location: 0, length: attributedString.length));
        attributedString2.addAttribute(NSAttributedString.Key.underlineStyle, value: 2, range:
                                        NSRange.init(location: 0, length: attributedString2.length));
        btnMoreInfo.setAttributedTitle(attributedString, for: .normal)
        btnCancellationPolicy.setAttributedTitle(attributedString2, for: .normal)
        self.setupTableView()
    }
    //MARK: - Custom methods
    func setupData(data:[String],isrefund:Bool){
        if isrefund == true{
            self.modelData = data
            if self.modelData.contains(Strings.Non_Refundable){
                
            }else{
                self.modelData.append(Strings.Non_Refundable)
            }
            
            self.isRefund = isrefund
        }else{
            self.modelData = data
            //self.modelData.removeLast()
            self.isRefund = isrefund
        }
        self.tableViewHeight.constant = CGFloat(self.modelData.count*25)
        self.tableView.reloadData()
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.ragisterNib(nibName: HotelfacilityXIB().identifire)
    }
    
}

//MARK: UITableView Delegate & Datasource

extension HotelRoomXIB: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HotelfacilityXIB().identifire, for: indexPath) as! HotelfacilityXIB
        cell.lblTitle.text = self.modelData[indexPath.row]
        
        if self.isRefund == true{
            if (self.modelData.count - 1) == indexPath.row {
                cell.lblTitle.textColor = .cutomRedColor()
                cell.dotView.backgroundColor = .cutomRedColor()
            }else{
                cell.lblTitle.textColor = .theamColor()
                cell.dotView.backgroundColor = .theamColor()
            }
        }else{
            cell.lblTitle.textColor = .theamColor()
            cell.dotView.backgroundColor = .theamColor()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
}
