//
//  BoardingDroppingVC.swift
//  LeaveCasa
//
//  Created by acme on 17/10/22.
//

import UIKit

protocol selectedBoarding {
    func selectedBoarding(_ boarding:BusBoarding,_ dropping : BusBoarding)
}
class BoardingDroppingVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var droppingDropImage: UIImageView!
    @IBOutlet weak var droppingRedBottomView: UIView!
    @IBOutlet weak var droppingView: UIView!
    @IBOutlet weak var boardingDropImage: UIImageView!
    @IBOutlet weak var boardingRedBottomView: UIView!
    @IBOutlet weak var boardingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Variables
    var isBoarding = true
    var bus = Bus()
    var isBoaringSelected = true
    
    var delegate : selectedBoarding?
    lazy var busDropping = BusBoarding()
    lazy var busBoarding = BusBoarding()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isBoarding == true{
            self.setBoardingData()
        }else{
            self.setDroppingData()
        }
        
        self.setupTableView()
    }
    
    //MARK: - @IBActions
    @IBAction func droppingOnPress(_ sender: UIButton) {
        self.setDroppingData()
    }
    @IBAction func closeOnPress(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let del = self.delegate{
                del.selectedBoarding(self.busBoarding, self.busDropping)
            }
        }
        
    }
    
    @IBAction func boardingOnPress(_ sender: UIButton) {
        self.setBoardingData()
    }
    //MARK: - Custom methods
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.ragisterNib(nibName: BoardingXIB().identifire)
    }
    func setBoardingData(){
        self.boardingView.backgroundColor = UIColor.customLightRedColor()
        self.boardingDropImage.isHidden = false
        self.boardingRedBottomView.isHidden = false
        
        self.droppingView.backgroundColor = .white
        self.droppingDropImage.isHidden = true
        self.droppingRedBottomView.isHidden = true
        
        self.isBoaringSelected = true
        self.tableView.reloadData()
    }
    
    func setDroppingData(){
        self.droppingView.backgroundColor = UIColor.customLightRedColor()
        self.droppingDropImage.isHidden = false
        self.droppingRedBottomView.isHidden = false
        
        self.boardingView.backgroundColor = .white
        self.boardingDropImage.isHidden = true
        self.boardingRedBottomView.isHidden = true
        
        self.isBoaringSelected = false
        self.tableView.reloadData()
    }
}

extension BoardingDroppingVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isBoaringSelected == true{
            return self.bus.sBusBoardingArr.count
        }else{
            return self.bus.sBusDroppingArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BoardingXIB().identifire, for: indexPath) as! BoardingXIB
        
        if self.isBoaringSelected == true{
            let indexData =  self.bus.sBusBoardingArr[indexPath.row]
            cell.lblAddress.text = indexData.sLandmark
            cell.lblLandmark.text = indexData.sAddress
            
            if self.busBoarding.sBpId == indexData.sBpId{
                cell.imgCheck.image = .checkMark()
            }else{
                cell.imgCheck.image = .uncheckMark()
            }
        }else{
            let index =  self.bus.sBusDroppingArr[indexPath.row]
            cell.lblAddress.text = index.sLandmark
            cell.lblLandmark.text = index.sAddress
            
            if self.busDropping.sBpId == index.sBpId{
                cell.imgCheck.image = .checkMark()
            }else{
                cell.imgCheck.image = .uncheckMark()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isBoaringSelected == true{
            self.busBoarding = self.bus.sBusBoardingArr[indexPath.row]
//            self.isBoarding = false
//            self.setDroppingData()
//            tableView.reloadData()
        }else{
            self.busDropping = self.bus.sBusDroppingArr[indexPath.row]
            //del.selectedBoarding(self.busBoarding, self.busDropping)
        }
        // del.selectedBoarding(self.busBoarding, self.busDropping)
        //                    }
        //                }
        tableView.reloadData()
    }
    
}
