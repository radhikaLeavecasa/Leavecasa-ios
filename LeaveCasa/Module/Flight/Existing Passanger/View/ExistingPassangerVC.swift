//
//  ExistingPassangerVC.swift
//  LeaveCasa
//
//  Created by acme on 25/01/23.
//

import UIKit
import SKCountryPicker

class ExistingPassangerVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Variables
    var passangerList = [PassangerData]()
    var passangerDetails = PassangerDetails()
    let country = CountryManager.shared.currentCountry
    var selectedIndex = -1
    var selectedPassengerIndex = -1
    typealias tableCellCompletion = (_ passengarDetail: PassangerDetails, _ index: Int, _ selectedIndex: Int) -> Void
    var tableCellDelegate: tableCellCompletion? = nil
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil

        self.setupTableView()
    }
    //MARK: - Custom methods
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.ragisterNib(nibName: ExistingPassangerXIB().identifire)
    }
    //MARK: - @IBActions
    @IBAction func backOnPress(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func doneClicked(_ sender: UIButton) {
        self.dismiss(animated: true) {
            guard let tableCell = self.tableCellDelegate else { return }
            tableCell(self.passangerDetails, self.selectedPassengerIndex, self.selectedIndex)
            
        }
    }
}

extension ExistingPassangerVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.passangerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExistingPassangerXIB().identifire, for: indexPath) as! ExistingPassangerXIB
        
        let dict = passangerList[indexPath.row]
        
        cell.imgCheckmark.image = indexPath.row == selectedIndex ? UIImage.checkMark() : UIImage.uncheckMark()
        cell.lblName.text = "\(dict.first_name ?? "") \(dict.last_name ?? "")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        passangerList[indexPath.row].isSelected = !passangerList[indexPath.row].isSelected
        
        let dict = passangerList[indexPath.row]
        var passanger = PassangerDetails()
        
        passanger.title = dict.title ?? "".capitalized
        passanger.firstName = dict.first_name ?? "".capitalized
        selectedIndex = indexPath.row
        passangerDetails = passanger
        tableView.reloadData()
    }
}
