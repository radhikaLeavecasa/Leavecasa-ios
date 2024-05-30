//
//  FlightListTableViewXIB.swift
//  LeaveCasa
//
//  Created by acme on 15/11/22.
//

import UIKit

class FlightListTableViewXIB: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var blueBG: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Variables
    var dataFlight = [Flight]()
    var view : UIViewController?
    let identifire = "FlightListTableViewXIB"
    var logId = 0
    var tokenId = ""
    var traceId = ""
    var searchFlight = [FlightStruct]()
    var numberOfAdults = 1
    var numberOfChildren = 0
    var numberOfInfants = 0
    //MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTableview()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.tableView.layer.removeAllAnimations()
        self.tableViewHeight.constant = self.tableView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    //MARK: - Custom methods
    func setupData(data:[Flight]) {
        self.tableViewHeight.constant = self.tableView.contentSize.height
        if self.dataFlight.count <= 0 {
            self.dataFlight = data
            self.tableView.reloadData()
        }
    }
    
    func setupTableview() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.ragisterNib(nibName: FlightListCellXIB().identifire)
        self.tableView.ragisterNib(nibName: NoDataFoundXIB().identifire)
        self.tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: NSKeyValueObservingOptions.new, context: nil)
    }
}

extension FlightListTableViewXIB:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataFlight.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataFlight[section].sSegments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FlightListCellXIB().identifire, for: indexPath) as! FlightListCellXIB
        
        let flight = self.dataFlight[indexPath.section]
        cell.setUp(indexPath: indexPath, flight: flight, paxNumber: numberOfAdults+numberOfInfants+numberOfChildren)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = self.dataFlight.filter {
            $0.sSegments.first?.first?.sAirline.sFlightNumber == self.dataFlight[indexPath.section].sSegments[indexPath.row].first?.sAirline.sFlightNumber ?? ""
        }
        
        if let vc = ViewControllerHelper.getViewController(ofType: .FareDetailsVC, StoryboardName: .Flight) as? FareDetailsVC {
            vc.dataFlight = data
            vc.logId = self.logId
            vc.tokenId = self.tokenId
            vc.traceId = self.traceId
            vc.searchFlight = self.searchFlight
            vc.numberOfAdults = self.numberOfAdults
            vc.numberOfChildren = self.numberOfChildren
            vc.numberOfInfants = self.numberOfInfants
            //            vc.searchParams = searchParams
            //            vc.calenderParam = calenderParam
            //            vc.selectedTab = selectedTab
            self.view?.pushView(vc: vc)
        }
    }
}
