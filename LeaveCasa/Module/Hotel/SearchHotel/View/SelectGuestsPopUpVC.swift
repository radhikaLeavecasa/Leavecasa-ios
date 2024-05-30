//
//  SelectGuestsPopUpVC.swift
//  LeaveCasa
//
//  Created by acme on 11/03/24.
//

import UIKit

class SelectGuestsPopUpVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var tblVwGuests: UITableView!
    @IBOutlet weak var btnAddRoom: UIButton!
    @IBOutlet weak var cnstTblVwHeight: NSLayoutConstraint!
    //MARK: - Variables
    var tblVwCount = 1
    var hotelData = [HotelRoomDetail]()
    var ageOfChildren: [Int] = []
    var finalRooms = [[String: AnyObject]]()
    typealias completion = (_ finalRoom: [[String: AnyObject]], _ hotelData: [HotelRoomDetail], _ tblVwCount: Int) -> Void
    var doneCompletion: completion? = nil
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
            if self.cnstTblVwHeight.constant < 530 {
                self.tblVwGuests.isScrollEnabled = false
                self.cnstTblVwHeight?.constant = self.tblVwGuests.contentSize.height + 30
            } else {
                self.tblVwGuests.isScrollEnabled = true
            }
        })
    }
    //MARK: - @IBActions
    @IBAction func actionCross(_ sender: Any) {
        dismiss()
    }
    @IBAction func actionDone(_ sender: Any) {
        var params: [String: AnyObject] = [:]

        for i in 0..<self.tblVwCount{
            if self.hotelData[i].children == 1 {
                self.ageOfChildren.append(self.hotelData[i].childOne)
            } else if self.hotelData[i].children == 2 {
                self.ageOfChildren.append(self.hotelData[i].childOne)
                self.ageOfChildren.append(self.hotelData[i].childTwo)
            }
            params[WSRequestParams.WS_REQS_PARAM_ADULTS] = self.hotelData[i].adults as AnyObject
            params[WSRequestParams.WS_REQS_PARAM_CHILDREN_AGES] = self.ageOfChildren as AnyObject
            self.finalRooms.append(params)
            self.ageOfChildren = []
        }
        
        self.dismiss(animated: true) {
            guard let okButton = self.doneCompletion else { return }
            okButton(self.finalRooms, self.hotelData, self.tblVwCount)
        }
    }
    
    @IBAction func actionAddRooms(_ sender: Any) {
        if tblVwCount < 4 {
            tblVwCount = tblVwCount + 1
            var data = HotelRoomDetail()
            data.adults = 1
            data.children = 0
            data.childOne = 0
            data.childTwo = 0
            self.hotelData.append(data)
            btnAddRoom.isHidden = tblVwCount == 4
            tblVwGuests.reloadData()
            self.viewWillLayoutSubviews()
        }
    }
}

extension SelectGuestsPopUpVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tblVwCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomsTVC") as! RoomsTVC
        cell.lblRoom.tag = indexPath.row
        cell.lblAdults.tag = indexPath.row
        cell.lblChildren.tag = indexPath.row
        cell.lblChildOne.tag = indexPath.row
        cell.btnDelete.isHidden = indexPath.row != hotelData.count - 1 || indexPath.row == 0
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(actionDelete), for: .touchUpInside)
        btnAddRoom.isHidden = tblVwCount == 4
        if hotelData.count > 0 {
            
            cell.vwChildrenSection.isHidden = hotelData[indexPath.row].children == 0
            cell.vwChildTwo.isHidden = hotelData[indexPath.row].children == 1 || hotelData[indexPath.row].children == 0
            cell.vwChildOne.isHidden = hotelData[indexPath.row].children == 0
            cell.lblAdults.text = "\(hotelData[indexPath.row].adults)"
            cell.lblChildOne.text = "\(hotelData[indexPath.row].childOne)"
            cell.lblChildTwo.text = "\(hotelData[indexPath.row].childTwo)"
            cell.lblChildren.text = "\(hotelData[indexPath.row].children)"
        }
        cell.lblRoom.text = "ROOM \(indexPath.row+1)"
        cell.btnPlusMinusChild[0].accessibilityIdentifier = "\(indexPath.row) 44"
        cell.btnPlusMinusChild[1].accessibilityIdentifier = "\(indexPath.row) 444"
        cell.btnPlusMinusAdults[0].accessibilityIdentifier = "\(indexPath.row) 55"
        cell.btnPlusMinusAdults[1].accessibilityIdentifier = "\(indexPath.row) 555"
        cell.btnPlusMinusChildOne[0].accessibilityIdentifier = "\(indexPath.row) 66"
        cell.btnPlusMinusChildOne[1].accessibilityIdentifier = "\(indexPath.row) 666"
        cell.btnPlusMinusChildTwo[0].accessibilityIdentifier = "\(indexPath.row) 77"
        cell.btnPlusMinusChildTwo[1].accessibilityIdentifier = "\(indexPath.row) 777"
        cell.btnPlusMinusChild[0].addTarget(self, action: #selector(actionAddChild), for: .touchUpInside)
        cell.btnPlusMinusChild[1].addTarget(self, action: #selector(actionAddChild), for: .touchUpInside)
        cell.btnPlusMinusAdults[0].addTarget(self, action: #selector(actionAddAdults), for: .touchUpInside)
        cell.btnPlusMinusAdults[1].addTarget(self, action: #selector(actionAddAdults), for: .touchUpInside)
        cell.btnPlusMinusChildOne[0].addTarget(self, action: #selector(actionAddChildOne), for: .touchUpInside)
        cell.btnPlusMinusChildOne[1].addTarget(self, action: #selector(actionAddChildOne), for: .touchUpInside)
        cell.btnPlusMinusChildTwo[0].addTarget(self, action: #selector(actionAddChildTwo), for: .touchUpInside)
        cell.btnPlusMinusChildTwo[1].addTarget(self, action: #selector(actionAddChildTwo), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        debugPrint("HeighhhhtttttttttForrrrrrROwAt")
        return hotelData[indexPath.row].children == 0 ? 150 : hotelData[indexPath.row].children == 1 ? 190 : 225
    }
    
    @objc func actionAddChild(_ sender: UIButton) {
        let cell = tblVwGuests.cellForRow(at: IndexPath(row: Int(sender.accessibilityIdentifier!.components(separatedBy: " ")[0]) ?? 0, section: 0)) as! RoomsTVC
        var noOfChildren = Int(cell.lblChildren.text ?? "0")
        if sender.accessibilityIdentifier!.contains("444") {
            if noOfChildren! >= 0 && noOfChildren != 2 {
                noOfChildren = noOfChildren! + 1
                cell.lblChildren.text = "\(noOfChildren ?? 0)"
            }
        } else {
            if noOfChildren! >= 1 {
                noOfChildren = noOfChildren! - 1
                cell.lblChildren.text = "\(noOfChildren ?? 0)"
            }
        }
        cell.vwChildrenSection.isHidden = noOfChildren ?? 0 == 0
        cell.vwChildTwo.isHidden = noOfChildren == 1
        hotelData[Int(sender.accessibilityIdentifier!.components(separatedBy: " ")[0]) ?? 0].children = noOfChildren ?? 0
        tblVwGuests.reloadData()
        tblVwGuests.layoutIfNeeded()
        self.viewWillLayoutSubviews()
    }
    @objc func actionAddAdults(_ sender: UIButton) {
        let cell = tblVwGuests.cellForRow(at: IndexPath(row: Int(sender.accessibilityIdentifier!.components(separatedBy: " ")[0]) ?? 0, section: 0)) as! RoomsTVC
        var noOFAdults = Int(cell.lblAdults.text ?? "0")
        if sender.accessibilityIdentifier!.contains("555") {
            if noOFAdults! >= 1 && noOFAdults != 12{
                noOFAdults = noOFAdults! + 1
                cell.lblAdults.text = "\(noOFAdults ?? 0)"
            }
        } else {
            if noOFAdults! > 1 {
                noOFAdults = noOFAdults! - 1
                cell.lblAdults.text = "\(noOFAdults ?? 0)"
            }
        }
        hotelData[Int(sender.accessibilityIdentifier!.components(separatedBy: " ")[0]) ?? 0].adults = noOFAdults ?? 0
        self.viewWillLayoutSubviews()
    }
    @objc func actionAddChildOne(_ sender: UIButton) {
        let cell = tblVwGuests.cellForRow(at: IndexPath(row: Int(sender.accessibilityIdentifier!.components(separatedBy: " ")[0]) ?? 0, section: 0)) as! RoomsTVC
        var ageChildOne = Int(cell.lblChildOne.text ?? "0")
        if sender.accessibilityIdentifier!.contains("666") {
            if ageChildOne! >= 0 && ageChildOne != 12{
                ageChildOne = ageChildOne! + 1
                cell.lblChildOne.text = "\(ageChildOne ?? 0)"
            }
        } else {
            if ageChildOne! >= 1 {
                ageChildOne = ageChildOne! - 1
                cell.lblChildOne.text = "\(ageChildOne ?? 0)"
            }
        }
        hotelData[Int(sender.accessibilityIdentifier!.components(separatedBy: " ")[0]) ?? 0].childOne = ageChildOne ?? 0
        self.viewWillLayoutSubviews()
    }
    @objc func actionAddChildTwo(_ sender: UIButton) {
        let cell = tblVwGuests.cellForRow(at: IndexPath(row: Int(sender.accessibilityIdentifier!.components(separatedBy: " ")[0]) ?? 0, section: 0)) as! RoomsTVC
        var ageChildTwo = Int(cell.lblChildTwo.text ?? "0")
        if sender.accessibilityIdentifier!.contains("777") {
            if ageChildTwo! >= 0 && ageChildTwo != 12{
                ageChildTwo = ageChildTwo! + 1
                cell.lblChildTwo.text = "\(ageChildTwo ?? 0)"
            }
        } else {
            if ageChildTwo! >= 1 {
                ageChildTwo = ageChildTwo! - 1
                cell.lblChildTwo.text = "\(ageChildTwo ?? 0)"
            }
        }
        hotelData[Int(sender.accessibilityIdentifier!.components(separatedBy: " ")[0]) ?? 0].childTwo = ageChildTwo ?? 0
        self.viewWillLayoutSubviews()
    }
    
    @objc func actionDelete(_ sender: UIButton) {
        if tblVwCount != 1 {
            tblVwCount = tblVwCount - 1
            hotelData.removeLast()
        }
        btnAddRoom.isHidden = tblVwCount == 4
        tblVwGuests.reloadData()
        self.viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}
