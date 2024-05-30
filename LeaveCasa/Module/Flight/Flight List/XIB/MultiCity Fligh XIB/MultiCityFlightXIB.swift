//
//  MultiCityFlightXIB.swift
//  LeaveCasa
//
//  Created by acme on 17/11/22.
//

import UIKit

class MultiCityFlightXIB: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblPaxCount: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Variables
    var segmentData = [[FlightSegment]]()
    var markups = [Markup]()
    let identifire = "MultiCityFlightXIB"
    var flights = [Flight]()
    var logId = 0
    var tokenId = ""
    var traceId = ""
    var searchFlight = [FlightStruct]()
    
    var numberOfAdults = 1
    var numberOfChildren = 0
    var numberOfInfants = 0
    
    var view: UIViewController?
    var viewModel = MultiCityViewModel()
    var selectedIndex = Int()
    //MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTableView()
        self.viewModel.delegate = self
    }
    //MARK: - Custom methods
    func setupData(data:[[FlightSegment]]){
        self.segmentData = data
        self.tableView.reloadData()
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.ragisterNib(nibName: MultipalCityFlightDetailsXIB().identifire)
        self.tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
    }
    
    //MARK: Add Observer For Tableview Height
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

extension MultiCityFlightXIB:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.segmentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MultipalCityFlightDetailsXIB().identifire, for: indexPath) as! MultipalCityFlightDetailsXIB
        cell.setUp(flight: self.segmentData[indexPath.row])
        cell.lblIndex.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MultiCityFlightXIB:ResponseProtocol {
    func onSuccess() {
        if let vc = ViewControllerHelper.getViewController(ofType: .PassangerDetailsVC, StoryboardName: .Flight) as? PassangerDetailsVC {
            vc.dataFlight = self.flights[self.selectedIndex]
            vc.passangerList = self.searchFlight
            vc.numberOfChildren = self.numberOfChildren
            vc.numberOfAdults = self.numberOfAdults
            vc.numberOfInfants = self.numberOfInfants
            vc.ssrData = self.viewModel.ssrModel
            vc.tokenId = self.tokenId
            vc.traceId = self.traceId
            vc.logId = self.logId
            self.view?.pushView(vc: vc)
        }
    }
}
