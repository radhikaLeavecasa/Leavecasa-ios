//
//  FareXIB.swift
//  LeaveCasa
//
//  Created by acme on 01/12/22.
//

import UIKit

class FareXIB: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var actionMoreInfo: UIButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblfareName: UILabel!
    @IBOutlet weak var imgSelect: UIImageView!
    //MARK: - Variables
    let identifire = "FareXIB"
    var fareData = [String]()
    var airlineRemark = String()
    //MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTableView()
    }
    
    //MARK: Add Observer For TableView Height
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Strings.CONTENT_SIZE {
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                DispatchQueue.main.async {
                    self.tableViewHeight.constant = newsize.height
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func layoutSubviews() {
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }
    //MARK: - Custom methods
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.ragisterNib(nibName: FareListXIB().identifire)
        self.tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
    }
}

extension FareXIB:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.airlineRemark != "" ? self.fareData.count + 1 : self.fareData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FareListXIB().identifire, for: indexPath) as! FareListXIB
        if self.airlineRemark != "" {
            cell.lblTitle.text = indexPath.row == self.fareData.count ? self.airlineRemark : self.fareData[indexPath.row]
        } else {
            let indexData = self.fareData[indexPath.row]
            cell.lblTitle.text = indexData
        }
        cell.lblTitle.font = UIFont.regularFont(size: 15)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
