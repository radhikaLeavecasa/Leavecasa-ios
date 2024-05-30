//
//  FlightReviewDetailsVC.swift
//  LeaveCasa
//
//  Created by acme on 22/02/24.
//

import UIKit

class FlightReviewDetailsVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var tblVwReview: UITableView!
    //MARK: - Variables
    @IBOutlet weak var cnstTblVwHeight: NSLayoutConstraint!
    typealias completion = (_ tag: Int) -> Void
    var doneCompletion: completion? = nil
    var passengerDetails = [PassangerDetails]()
    var numberOfAdults = 1
    var numberOfChildren = 0
    var numberOfInfants = 0
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVwReview.isScrollEnabled = passengerDetails.count > 4
        if passengerDetails.count > 4 {
            cnstTblVwHeight.constant = 290
        }
        
    }
    //MARK: - @IBActions
    @IBAction func actionEditConfirm(_ sender: UIButton) {
        if sender.tag == 0 {
            dismiss()
        } else {
            self.dismiss(animated: true) {
                guard let doneButton = self.doneCompletion else { return }
                doneButton(sender.tag)
            }
        }
    }
}

extension FlightReviewDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        passengerDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewDetailTVC") as! ReviewDetailTVC
        cell.lblTitle.text = passengerDetails[indexPath.row].title
        cell.lblName.text = passengerDetails[indexPath.row].firstName
        cell.lblLastName.text = passengerDetails[indexPath.row].lastName
        if indexPath.row+1 <= self.numberOfAdults{
            cell.lblPassenger.text = "Adult \(indexPath.row+1)"
        }else if indexPath.row+1 > self.numberOfAdults && indexPath.row+1 <= (self.numberOfAdults + self.numberOfChildren){
            cell.lblPassenger.text = "Child \(indexPath.row-numberOfAdults+1)"
        }else{
            cell.lblPassenger.text = "Infant \(indexPath.row-numberOfAdults-numberOfChildren+1)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if passengerDetails.count <= 4 {
         //   if indexPath.row == (passengerDetails.count - 1) {
                var totalHeight: CGFloat = 0
                
                for section in 0..<tableView.numberOfSections {
                    for row in 0..<tableView.numberOfRows(inSection: section) {
                        let indexPath = IndexPath(row: row, section: section)
                        totalHeight += tableView.rectForRow(at: indexPath).height
                    }
                }
                cnstTblVwHeight.constant = totalHeight
            }
        //}
    }
}
