//
//  BusTicketDetailsVC.swift
//  LeaveCasa
//
//  Created by acme on 28/10/22.
//

import UIKit

class BusTicketDetailsVC: UIViewController {
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableview()
    }
    
    func setupTableview(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.ragisterNib(nibName: PassangerDetailsXIB().identifire)
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.tableView.layer.removeAllAnimations()
        self.tableViewHeight.constant = self.tableView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
}

extension BusTicketDetailsVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PassangerDetailsXIB().identifire, for: indexPath) as! PassangerDetailsXIB
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
}
