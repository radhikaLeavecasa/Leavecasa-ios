//
//  BusOperatorVC.swift
//  LeaveCasa
//
//  Created by acme on 07/12/22.
//

import UIKit

protocol BusOperatorList{
    func BusOperatorList(data:[String])
}

class BusOperatorVC: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var busOperaterList = [String]()
    var selectedBus = [String]()
    var searchData = [String]()
    
    var delegate : BusOperatorList?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchData = self.busOperaterList
        self.txtSearch.addTarget(self, action: #selector(searchWorkersAsPerText(_ :)), for: .editingChanged)

        self.setupTableView()
    }
    
    
    @objc func searchWorkersAsPerText(_ textfield:UITextField) {
        self.searchData.removeAll()

        debugPrint("Filtering with:", textfield.text ?? "")
        if textfield.text?.count == 0{
            self.searchData = self.busOperaterList
            self.tableView.reloadData()
        }else{
            self.searchData.removeAll()
            self.searchData = self.busOperaterList.filter { thing in
                return "\(thing.lowercased())".contains(textfield.text?.lowercased() ?? "")
            }
        }
        self.tableView.reloadData()
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.ragisterNib(nibName: BusOperatorXIB().identifire)
        self.tableView.tableFooterView = UIView()
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
    
    @IBAction func doneOnPress(_ sender: UIButton) {
        self.popView()
        if let del = self.delegate{
            del.BusOperatorList(data: self.selectedBus)
        }
    }
    
}

extension BusOperatorVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusOperatorXIB().identifire, for: indexPath) as! BusOperatorXIB
        
        let indexData = self.searchData[indexPath.row]
        cell.lblTitle.text = indexData
        
        if self.selectedBus.contains(indexData){
            cell.imgCheck.image = .checkMark()
        }else{
            cell.imgCheck.image = .uncheckMark()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexData = self.searchData[indexPath.row]
        if self.selectedBus.contains(indexData) {
            let index = self.selectedBus.firstIndex(of: indexData) ?? 0
            self.selectedBus.remove(at: index)
        }else{
            self.selectedBus.append(indexData)
        }
        self.tableView.reloadData()
    }
}
