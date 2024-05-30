//
//  LowerBerthCVC.swift
//  LeaveCasa
//
//  Created by acme on 25/08/23.
//

import UIKit

protocol TVCDelegate: AnyObject {
    func didFinishSelectingData(_ selectedSeatCount: [BusSeat], cvc: String)
}

class LowerBerthCVC: UICollectionViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var btnFooter: UIButton!
    @IBOutlet weak var cnstHeightFooter: NSLayoutConstraint!
    @IBOutlet weak var lblSleeperPrice: UILabel!
    @IBOutlet weak var imgVwSleeper: UIImageView!
    @IBOutlet weak var vwFooter: UIView!
    @IBOutlet weak var constCollVwHeight: NSLayoutConstraint!
    @IBOutlet weak var lblLowerBerth: UILabel!
    @IBOutlet weak var collvwUpperSeats: UICollectionView!
    //MARK: - Variables
    weak var delegate: TVCDelegate?
    var numberOfSection = Int()
    var numberOfRows = Int()
    var arrSeats = [BusSeat]()
    var footerSeat = [BusSeat]()
    lazy var selectedSeats = [BusSeat]()
    lazy var seatPrice = 0.0
    lazy var upperSeats = Int()
    lazy var totalSeats = Int()
    lazy var lowerSeatsCount = Int()
    var view: UIViewController?
    var rowDictionary = [Int: [BusSeat]]()
    var sortedRowDictionary = [Int: [BusSeat]]()
    var maxCount: Int = 0
    var missingNumbers = Int()
    //MARK: - Custom methods
    func reloadData(_ numberOfSection: Int, numberOfRows: Int, arrSeats: [BusSeat], seatPrice: Double, upperSeats: Int, totalSeats: Int, selectedSeats: [BusSeat], view: UIViewController) {
        self.numberOfSection = numberOfSection
        self.numberOfRows = numberOfRows
        self.arrSeats = arrSeats
        self.seatPrice = seatPrice
        self.upperSeats = upperSeats
        self.totalSeats = totalSeats
        self.selectedSeats = selectedSeats
        self.collvwUpperSeats.ragisterNib(nibName: SeatXIB().identifire)
        self.view = view
        btnFooter.addTarget(self, action: #selector(actionFooterSeat), for: .touchUpInside)
        rowDictionary = [:]
        for dict in arrSeats {
            let row = dict.sRow
            if rowDictionary[row] == nil {
                rowDictionary[row] = [dict]
            } else {
                rowDictionary[row]?.append(dict)
            }
        }
        
        let sortedRowDictionary2 = rowDictionary.sorted(by: { $0.key > $1.key })
        
        
        footerSeat = arrSeats.filter({$0.sWidth == 2})
        if footerSeat.count == 1 {
            vwFooter.isHidden = false
            cnstHeightFooter.constant = 70
            lblSleeperPrice.text = "₹\(footerSeat[0].sFare)"
            if footerSeat[0].sAvailable == true{
                imgVwSleeper.image = UIImage.init(named: footerSeat[0].sLadiesSeat == true ? "ic_sleeper_female_seats" : "ic_green_avlable_landscape_sleeper")
            }else{
                imgVwSleeper.image = UIImage.init(named: footerSeat[0].sLadiesSeat == true ? "ic_selected_sleeper_female_seats" : "ic_gray_sleeper_landscape_seat")
            }
            
            for index in self.selectedSeats{
                if footerSeat[0].sColumn == index.sColumn && footerSeat[0].sName == index.sName {
                    imgVwSleeper.image = UIImage.init(named: "ic_green_landscape_sleeper")
                }
            }
        } else if footerSeat.count == 0 {
            vwFooter.isHidden = true
            cnstHeightFooter.constant = 0
        }
        
        
        DispatchQueue.main.async {
            for (key, seats) in sortedRowDictionary2 {
                let sortedSeats = seats.sorted(by: { $0.sColumn < $1.sColumn })
                self.sortedRowDictionary[key] = sortedSeats
            }
            
            for (_, seats) in self.sortedRowDictionary {
                if seats.count > self.maxCount {
                    self.maxCount = seats.count
                }
            }
            
            let chairs = arrSeats.filter({$0.sWidth == 1 && $0.sLength == 1})
            let sleepers = arrSeats.filter({$0.sWidth == 1 && $0.sLength == 2})
            
            if chairs.count > sleepers.count {
                self.constCollVwHeight.constant = CGFloat(self.maxCount*70)
            } else {
                self.constCollVwHeight.constant = CGFloat(self.maxCount*155)
            }
            
            self.collvwUpperSeats.updateConstraintsIfNeeded()
            if let flowLayout = self.collvwUpperSeats.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            }
            self.collvwUpperSeats.delegate = self
            self.collvwUpperSeats.dataSource = self
            self.collvwUpperSeats.reloadData()
            
            
            let dictionaryKeysArray = Array(self.sortedRowDictionary.keys)
            self.missingNumbers = self.findMissingNumbers(in: dictionaryKeysArray)
        }
    }
    @objc func actionFooterSeat(_ sender: UIButton) {
        if footerSeat[0].sAvailable == true {
            if self.selectedSeats.contains(where: {$0.sColumn == footerSeat[0].sColumn && $0.sName == footerSeat[0].sName}){
                let index = self.selectedSeats.firstIndex{$0 === footerSeat[0]} ?? 0
                self.selectedSeats.remove(at: index)
                
                imgVwSleeper.image = UIImage.init(named: footerSeat[0].sLadiesSeat == true ? "ic_sleeper_female_seats" : "ic_green_avlable_landscape_sleeper")
                delegate?.didFinishSelectingData(selectedSeats, cvc: "lower")
            }else{
                if totalSeats == ((self.selectedSeats.count) + upperSeats) {
                    view!.pushNoInterConnection(view: view!, titleMsg: "Alert", msg: "You can selected maximum \(totalSeats) seats")
                } else {
                    self.selectedSeats.append(footerSeat[0])
                    imgVwSleeper.image = UIImage.init(named: "ic_green_landscape_sleeper")
                    delegate?.didFinishSelectingData(selectedSeats, cvc: "lower")
                }
            }
        }
    }
    func findMissingNumbers(in dictionaryKeys: [Int]) -> Int {
        // Find the maximum key present in the dictionary
        guard let maxKey = dictionaryKeys.max() else {
            return -1
        }
        
        var missingNumbers: Int = -1
        
        // Iterate through the sequence from 0 to maxKey
        for number in 0...maxKey {
            // If the number is not present in the dictionary keys, add it to the missing numbers
            if !dictionaryKeys.contains(number) {
                missingNumbers = number
            }
        }
        
        return missingNumbers
    }
    
    override func layoutSubviews() {
        self.collvwUpperSeats.updateConstraintsIfNeeded()
        if let flowLayout = self.collvwUpperSeats.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        self.collvwUpperSeats.layoutIfNeeded()
        self.collvwUpperSeats.reloadData()
    }
}

extension LowerBerthCVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sortedRowDictionary.keys.count
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if sortedRowDictionary.keys.max() ?? 0 > 0 {
            let reversedSection = sortedRowDictionary.keys.sorted(by: >)[section]
            return sortedRowDictionary[reversedSection]?.count ?? 0 == 1 ? maxCount : sortedRowDictionary[reversedSection]?.count ?? 0
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeatXIB().identifire, for: indexPath) as! SeatXIB
        let reversedSection = sortedRowDictionary.keys.sorted(by: >)[indexPath.section]
        var rowDict = self.sortedRowDictionary
        if self.sortedRowDictionary[reversedSection]?.count == 1 {
            if let sectionItems = rowDict[reversedSection] {
                for _ in 0..<self.maxCount {
                    rowDict[reversedSection]?.append(sectionItems.first ?? BusSeat())
                }
            }
        }
        
        if let index = rowDict[reversedSection]?[indexPath.row] {
            cell.imgBusSeat.isHidden = false
            cell.lblSeatPrice.text = "100"
            cell.vwTop.isHidden = false
            if indexPath.row == index.sColumn && sortedRowDictionary[reversedSection]?.count == 1 {
                cell.imgBusSeat.isHidden = false
                cell.lblSeatPrice.isHidden = false
                cell.height.constant = 35
                cell.vwTop.isHidden = true
                if index.sLength == 1 && index.sWidth == 1 {
                    if index.sAvailable == true {
                        cell.imgBusSeat.image = UIImage.init(named: index.sLadiesSeat == true ? "ic_seat_female" : "ic_bus_seat_green")
                        for index2 in self.selectedSeats {
                            if reversedSection == index.sRow && index.sName == index2.sName {
                                cell.imgBusSeat.image = UIImage.init(named: "ic_green_selected_seat")
                            }
                        }
                        cell.lblSeatPrice.text = "₹\(index.sFare)"
                    }else{
                        cell.imgBusSeat.image = UIImage.init(named: index.sLadiesSeat == true ? "ic_female_seat_booked" : "ic_seat_booked")
                        cell.lblSeatPrice.text = "₹\(index.sFare)"
                    }
                    
                }else if index.sLength == 2 && index.sWidth == 1 {
                    cell.height.constant = 90
                    if index.sAvailable == true{
                        cell.imgBusSeat.image = UIImage.init(named: "ic_avlable_sleeper")
                        cell.lblSeatPrice.text = "₹\(index.sFare)"
                        for index2 in self.selectedSeats {
                            if reversedSection == index.sRow && index.sName == index2.sName {
                                cell.imgBusSeat.image = UIImage.init(named: "ic_green_sleeper")
                            }
                        }
                    }else{
                        cell.lblSeatPrice.text = "₹\(index.sFare)"
                        cell.imgBusSeat.image = UIImage.init(named: "ic_gray_sleeper_seat")
                    }
                    
                }
            } else if sortedRowDictionary[reversedSection]?.count != 1 {
                cell.vwTop.isHidden = true
                cell.imgBusSeat.isHidden = false
                cell.height.constant = 35
                if index.sLength == 1 && index.sWidth == 1 {
                    if index.sAvailable == true {
                        cell.imgBusSeat.image = UIImage.init(named: index.sLadiesSeat == true ? "ic_seat_female" : "ic_bus_seat_green")
                        for index2 in self.selectedSeats {
                            if reversedSection == index.sRow && index.sName == index2.sName {
                                cell.imgBusSeat.image = UIImage.init(named: "ic_green_selected_seat")
                            }
                        }
                        cell.lblSeatPrice.text = "₹\(index.sFare)"
                    }else{
                        
                        cell.imgBusSeat.image = UIImage.init(named: index.sLadiesSeat == true ? "ic_female_seat_booked" : "ic_seat_booked")
                        cell.lblSeatPrice.text = "₹\(index.sFare)"
                    }
                    
                }else if index.sLength == 2 && index.sWidth == 1 {
                    cell.height.constant = 90
                    if index.sAvailable == true{
                        cell.imgBusSeat.image = UIImage.init(named: "ic_avlable_sleeper")
                        cell.lblSeatPrice.text = "₹\(index.sFare)"
                        for index2 in self.selectedSeats {
                            if reversedSection == index.sRow && index.sName == index2.sName {
                                cell.imgBusSeat.image = UIImage.init(named: "ic_green_sleeper")
                            }
                        }
                        
                    }else{
                        cell.lblSeatPrice.text = "₹\(index.sFare)"
                        cell.imgBusSeat.image = UIImage.init(named: "ic_gray_sleeper_seat")
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let reversedSection = sortedRowDictionary.keys.sorted(by: >)[indexPath.section]
        var rowDict = self.sortedRowDictionary
        if self.sortedRowDictionary[reversedSection]?.count == 1 {
            if let sectionItems = rowDict[reversedSection] {
                for _ in 0..<self.maxCount {
                    rowDict[reversedSection]?.append(sectionItems.first ?? BusSeat())
                }
            }
        }
        if sortedRowDictionary[reversedSection]?.count == 1 {
            if let data = rowDict[reversedSection]?[indexPath.row] {
                if data.sLength == 2 {
                    return CGSize(width: (Int(self.collvwUpperSeats.frame.width) / ((sortedRowDictionary.keys.max() ?? 0)+1)), height: 142)
                } else {
                    let height = Int(self.collvwUpperSeats.frame.height)/((rowDict[reversedSection]?.count ?? 0))
                    return CGSize(width: (Int(self.collvwUpperSeats.frame.width) / ((sortedRowDictionary.keys.max() ?? 0)+1)), height: height)
                }
            }
        } else {
            if let data = rowDict[reversedSection]?[indexPath.row] {
                if missingNumbers != -1 {
                    if reversedSection == missingNumbers - 1 {
                        if data.sLength == 2 {
                            return CGSize(width: 2*(Int(self.collvwUpperSeats.frame.width) / ((sortedRowDictionary.keys.max() ?? 0)+1)), height: 142)
                        } else {
                            return CGSize(width: 2*(Int(self.collvwUpperSeats.frame.width) / ((sortedRowDictionary.keys.max() ?? 0)+1)), height: 50)
                        }
                    } else {
                        if data.sLength == 2 {
                            return CGSize(width: (Int(self.collvwUpperSeats.frame.width) / ((sortedRowDictionary.keys.max() ?? 0)+1)), height: 142)
                        } else {
                            return CGSize(width: (Int(self.collvwUpperSeats.frame.width) / ((sortedRowDictionary.keys.max() ?? 0)+1)), height: 50)
                        }
                    }
                } else {
                    if data.sLength == 2 {
                        return CGSize(width: (Int(self.collvwUpperSeats.frame.width) / ((sortedRowDictionary.keys.max() ?? 0)+1)), height: 142)
                    } else {
                        return CGSize(width: (Int(self.collvwUpperSeats.frame.width) / ((sortedRowDictionary.keys.max() ?? 0)+1)), height: 50)
                    }
                }
            }
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reversedSection = sortedRowDictionary.keys.sorted(by: >)[indexPath.section]
        var rowDict = self.sortedRowDictionary
        if self.sortedRowDictionary[reversedSection]?.count == 1 {
            if let sectionItems = rowDict[reversedSection] {
                for _ in 0..<self.maxCount {
                    rowDict[reversedSection]?.append(sectionItems.first ?? BusSeat())
                }
            }
        }
        
        if let index = rowDict[reversedSection]?[indexPath.row] {
            if indexPath.row == index.sColumn && sortedRowDictionary[reversedSection]?.count == 1 {
                if index.sAvailable == true {
                    if self.selectedSeats.contains(where: {$0.sColumn == index.sColumn && $0.sName == index.sName}){
                        let index = self.selectedSeats.firstIndex{$0 === index} ?? 0
                        self.selectedSeats.remove(at: index)
                        delegate?.didFinishSelectingData(selectedSeats, cvc: "lower")
                    }else{
                        if totalSeats == ((self.selectedSeats.count) + upperSeats) {
                            view!.pushNoInterConnection(view: view!, titleMsg: "Alert", msg: "You can selected maximum \(totalSeats) seats")
                        } else {
                            self.selectedSeats.append(index)
                            delegate?.didFinishSelectingData(selectedSeats, cvc: "lower")
                        }
                    }
                }
            } else if sortedRowDictionary[reversedSection]?.count != 1 {
                if reversedSection == index.sRow {
                    if index.sAvailable == true {
                        if self.selectedSeats.contains(where: {$0.sColumn == index.sColumn && $0.sName == index.sName}){
                            let index = self.selectedSeats.firstIndex{$0 === index} ?? 0
                            self.selectedSeats.remove(at: index)
                            delegate?.didFinishSelectingData(selectedSeats, cvc: "lower")
                        }else{
                            if totalSeats == ((self.selectedSeats.count) + upperSeats) {
                                view!.pushNoInterConnection(view: view!, titleMsg: "Alert", msg: "You can selected maximum \(totalSeats) seats")
                            } else {
                                self.selectedSeats.append(index)
                                delegate?.didFinishSelectingData(selectedSeats, cvc: "lower")
                            }
                        }
                    }
                }
            }
        }
        collvwUpperSeats.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
