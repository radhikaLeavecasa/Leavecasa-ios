//
//  FlightSeatsTVC.swift
//  LeaveCasa
//
//  Created by acme on 04/03/24.
//

import UIKit
import Popover

protocol CollectionViewCellDelegate: AnyObject {
    func collectionViewCellDidClick(_ seatPrice: Double, cell1: UICollectionViewCell, indexPath: IndexPath, isDeselected: Bool)
}

//protocol CollectionViewDelegate {
//    func collectionViewCellTapped(indexPath: IndexPath)
//}

class FlightSeatsTVC: UITableViewCell {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var lblExit2: UILabel!
    @IBOutlet weak var lblExit1: UILabel!
    @IBOutlet weak var collVwRowSeats: UICollectionView!
    
    //MARK: - Variables
    var rowCount = Int()
    var arr = [SegmentSeat]()
    var tblSection = Int()
    var arrSeatTypes = [String]()
    var seatType = ""
    var viewController = UIViewController()
    var missingSeatIndex = [Int]()
   // var arrSelectedSeat = [[Seats]]()
    //var seletedSeats = [String]()
    var seatPrice = Double()
    var priceData = 0.0
    weak var delegate: CollectionViewCellDelegate?
    var finalSeletedSeats = [String]()
    var numberOfSeat = 0
    var selectedCityCode = 0
    var totalNumberofSeatsWithMissingChar = Int()
    var indexPath: IndexPath?
    var isDelesected = false
    //MARK: - Lifecycle methods
    override func awakeFromNib() {
        collVwRowSeats.delegate = self
        collVwRowSeats.dataSource = self
        self.collVwRowSeats.ragisterNib(nibName: FlightSeatXIB().identifier)
        
        
        //self.collVwRowSeats.register(UINib(nibName: "HCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HCollectionReusableView")
        
    }
//    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
//        let location = sender.location(in: collVwRowSeats)
//        
//        if let indexPath = collVwRowSeats.indexPathForItem(at: location) {
//            LoaderClass.shared.tapLocation = location
//            // Handle the tap on the cell at indexPath
//        }
//    }
    func reloadData(_ noOfRows: Int, arrSeatSegment: [SegmentSeat], section: Int, arrSeatTypes: [String], vc: UIViewController, missingSeatIndex: [Int], numberOfSeat: Int, selectedCityCode: Int, totalNumberofSeatsWithMissingChar: Int, indexPath: IndexPath){
        rowCount = noOfRows
        arr = arrSeatSegment
        tblSection = section
        self.arrSeatTypes = arrSeatTypes
        viewController = vc
        self.indexPath = indexPath
        self.missingSeatIndex = missingSeatIndex
        self.numberOfSeat = numberOfSeat
        self.selectedCityCode = selectedCityCode
        self.totalNumberofSeatsWithMissingChar = totalNumberofSeatsWithMissingChar
        collVwRowSeats.reloadData()
    //   collVwRowSeats.setContentOffset(CGPoint.zero, animated: false)
        LoaderClass.shared.stopAnimation()
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: collVwRowSeats)
        let indexPath = collVwRowSeats.indexPathForItem(at: location)

        if let indexPath = indexPath {
            let cell = collVwRowSeats.cellForItem(at: indexPath)
            let cellLocation = gesture.location(in: cell)
            print("Tap location in collectionView cell: \(cellLocation)")
        }
    }
}

extension FlightSeatsTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //  arr[stopNumber].rowSeats?[tblSection].seats?.filter({$.code})
        //rowCount
        
        totalNumberofSeatsWithMissingChar == 0 ? rowCount : totalNumberofSeatsWithMissingChar
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlightSeatXIB().identifier, for: indexPath) as! FlightSeatXIB
        //cell.delegate = self
        //if indexPath.row < rowCount {
        self.lblExit2.isHidden = true
        self.lblExit1.isHidden = true
        
        
        for i in 0...arrSeatTypes.count {
            if i == arr[selectedCityCode].rowSeats?[tblSection].seats?[0].seatType {
                seatType = arrSeatTypes[i]
                break
            }
        }
        
        if (self.seatType.contains("not set") || self.seatType.contains("Not set") && (self.arr[selectedCityCode].rowSeats?[self.tblSection].seats?.count == 1)) || self.seatType.contains("NoSeat") {
            cell.imgSeat.isHidden = true
            cell.lblSeatNumber.isHidden = true
            self.lblExit2.isHidden = true
            self.lblExit1.isHidden = true
        } else if self.seatType.contains("Exit"){
            self.lblExit2.isHidden = false
            self.lblExit1.isHidden = false
        } else {
            cell.imgSeat.isHidden = false
            cell.lblSeatNumber.isHidden = false
            self.lblExit2.isHidden = true
            self.lblExit1.isHidden = true
        }
        switch indexPath.row {
            
        case 0:
            cell.lblSeatNumber.isHidden = false
            
            let code = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "A"})
            if code?.count ?? 0 > 0 {
                cell.lblSeatNumber.text = code?[0].code
                if code?.first!.availablityType == 1 {
                    if LoaderClass.shared.arrSelectedSeat.count > 0 {
                        cell.imgSeat.image = .busUnSelectSeat()
                        LoaderClass.shared.arrSelectedSeat[selectedCityCode].forEach { val in
                            if val.code == code?[0].code {
                                cell.imgSeat.image = .flightSelectSeat()
                            }
                        }
                    } else {
                        cell.imgSeat.image = .busUnSelectSeat()
                    }
                } else {
                    cell.imgSeat.image = .flightBookSeat()
                }
            } else {
                cell.lblSeatNumber.isHidden = true
                cell.imgSeat.isHidden = true
            }
        case 1:
            cell.lblSeatNumber.isHidden = false
            let code = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "B"})
            if code?.count ?? 0 > 0 {
                cell.lblSeatNumber.text = code?[0].code
                if code?.first!.availablityType == 1 {
                    
                    if LoaderClass.shared.arrSelectedSeat.count > 0 {
                        cell.imgSeat.image = .busUnSelectSeat()
                        LoaderClass.shared.arrSelectedSeat[selectedCityCode].forEach { val in
                            if val.code == code?[0].code {
                                cell.imgSeat.image = .flightSelectSeat()
                            }
                        }
                    } else {
                        cell.imgSeat.image = .busUnSelectSeat()
                    }
                } else {
                    cell.imgSeat.image = .flightBookSeat()
                }
            } else {
                cell.lblSeatNumber.isHidden = true
                cell.imgSeat.isHidden = true
            }
        case 2:
            cell.lblSeatNumber.isHidden = false
            let code = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "C"})
            if code?.count ?? 0 > 0 {
                cell.lblSeatNumber.text = code?[0].code
                if code?.first!.availablityType == 1 {
                    if LoaderClass.shared.arrSelectedSeat.count > 0 {
                        cell.imgSeat.image = .busUnSelectSeat()
                        LoaderClass.shared.arrSelectedSeat[selectedCityCode].forEach { val in
                            if val.code == code?[0].code {
                                cell.imgSeat.image = .flightSelectSeat()
                            }
                        }
                    } else {
                        cell.imgSeat.image = .busUnSelectSeat()
                    }
                } else {
                    cell.imgSeat.image = .flightBookSeat()
                }
            } else {
                cell.lblSeatNumber.isHidden = true
                cell.imgSeat.isHidden = true
            }
            
        case 3:
            cell.lblSeatNumber.isHidden = false
            let code = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "D"})
            if code?.count ?? 0 > 0 {
                cell.lblSeatNumber.text = code?[0].code
                if code?.first!.availablityType == 1 {
                    if LoaderClass.shared.arrSelectedSeat.count > 0 {
                        cell.imgSeat.image = .busUnSelectSeat()
                        LoaderClass.shared.arrSelectedSeat[selectedCityCode].forEach { val in
                            if val.code == code?[0].code {
                                cell.imgSeat.image = .flightSelectSeat()
                            }
                        }
                    } else {
                        cell.imgSeat.image = .busUnSelectSeat()
                    }
                } else {
                    cell.imgSeat.image = .flightBookSeat()
                }
            } else {
                cell.lblSeatNumber.isHidden = true
                cell.imgSeat.isHidden = true
            }
            
        case 4:
            cell.lblSeatNumber.isHidden = false
            let code = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "E"})
            if code?.count ?? 0 > 0 {
                cell.lblSeatNumber.text = code?[0].code
                if code?.first!.availablityType == 1 {
                    if LoaderClass.shared.arrSelectedSeat.count > 0 {
                        cell.imgSeat.image = .busUnSelectSeat()
                        LoaderClass.shared.arrSelectedSeat[selectedCityCode].forEach { val in
                            if val.code == code?[0].code {
                                cell.imgSeat.image = .flightSelectSeat()
                            }
                        }
                    } else {
                        cell.imgSeat.image = .busUnSelectSeat()
                    }
                } else {
                    cell.imgSeat.image = .flightBookSeat()
                }
            } else {
                cell.lblSeatNumber.isHidden = true
                cell.imgSeat.isHidden = true
            }
            
        case 5:
            cell.lblSeatNumber.isHidden = false
            //cell.imgSeat.image = indexData?.availablityType == 1 ? .busUnSelectSeat() : .flightBookSeat()
            let code = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "F"})
            if code?.count ?? 0 > 0 {
                cell.lblSeatNumber.text = code?[0].code
                if code?.first!.availablityType == 1 {
                    if LoaderClass.shared.arrSelectedSeat.count > 0 {
                        cell.imgSeat.image = .busUnSelectSeat()
                        LoaderClass.shared.arrSelectedSeat[selectedCityCode].forEach { val in
                            if val.code == code?[0].code {
                                cell.imgSeat.image = .flightSelectSeat()
                            }
                        }
                    } else {
                        cell.imgSeat.image = .busUnSelectSeat()
                    }
                } else {
                    cell.imgSeat.image = .flightBookSeat()
                }
            } else {
                cell.lblSeatNumber.isHidden = true
                cell.imgSeat.isHidden = true
            }
            
        case 6:
            cell.lblSeatNumber.isHidden = false
            let code = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "G"})
            if code?.count ?? 0 > 0 {
                cell.lblSeatNumber.text = code?[0].code
                if code?.first!.availablityType == 1 {
                    if LoaderClass.shared.arrSelectedSeat.count > 0 {
                        cell.imgSeat.image = .busUnSelectSeat()
                        LoaderClass.shared.arrSelectedSeat[selectedCityCode].forEach { val in
                            if val.code == code?[0].code {
                                cell.imgSeat.image = .flightSelectSeat()
                            }
                        }
                    } else {
                        cell.imgSeat.image = .busUnSelectSeat()
                    }
                } else {
                    cell.imgSeat.image = .flightBookSeat()
                }
            } else {
                cell.lblSeatNumber.isHidden = true
                cell.imgSeat.isHidden = true
            }
            
        case 7:
            cell.lblSeatNumber.isHidden = false
            //cell.imgSeat.image = indexData?.availablityType == 1 ? .busUnSelectSeat() : .flightBookSeat()
            let code = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "H"})
            if code?.count ?? 0 > 0 {
                cell.lblSeatNumber.text = code?[0].code
                if code?.first!.availablityType == 1 {
                    if LoaderClass.shared.arrSelectedSeat.count > 0 {
                        cell.imgSeat.image = .busUnSelectSeat()
                        LoaderClass.shared.arrSelectedSeat[selectedCityCode].forEach { val in
                            if val.code == code?[0].code {
                                cell.imgSeat.image = .flightSelectSeat()
                            }
                        }
                    } else {
                        cell.imgSeat.image = .busUnSelectSeat()
                    }
                } else {
                    cell.imgSeat.image = .flightBookSeat()
                }
            } else {
                cell.lblSeatNumber.isHidden = true
                cell.imgSeat.isHidden = true
            }
            
        case 8:
            cell.lblSeatNumber.isHidden = false
            //cell.imgSeat.image = indexData?.availablityType == 1 ? .busUnSelectSeat() : .flightBookSeat()
            let code = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "I"})
            if code?.count ?? 0 > 0 {
                cell.lblSeatNumber.text = code?[0].code
                if code?.first!.availablityType == 1 {
                    if LoaderClass.shared.arrSelectedSeat.count > 0 {
                        cell.imgSeat.image = .busUnSelectSeat()
                        LoaderClass.shared.arrSelectedSeat[selectedCityCode].forEach { val in
                            if val.code == code?[0].code {
                                cell.imgSeat.image = .flightSelectSeat()
                            }
                        }
                    } else {
                        cell.imgSeat.image = .busUnSelectSeat()
                    }
                } else {
                    cell.imgSeat.image = .flightBookSeat()
                }
            } else {
                cell.lblSeatNumber.isHidden = true
                cell.imgSeat.isHidden = true
            }
            
        case 9:
            cell.lblSeatNumber.isHidden = false
            //cell.imgSeat.image = indexData?.availablityType == 1 ? .busUnSelectSeat() : .flightBookSeat()
            let code = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "J"})
            if code?.count ?? 0 > 0 {
                cell.lblSeatNumber.text = code?[0].code
                if code?.first!.availablityType == 1 {
                    if LoaderClass.shared.arrSelectedSeat.count > 0 {
                        cell.imgSeat.image = .busUnSelectSeat()
                        LoaderClass.shared.arrSelectedSeat[selectedCityCode].forEach { val in
                            if val.code == code?[0].code {
                                cell.imgSeat.image = .flightSelectSeat()
                            }
                        }
                    } else {
                        cell.imgSeat.image = .busUnSelectSeat()
                    }
                } else {
                    cell.imgSeat.image = .flightBookSeat()
                }
            } else {
                cell.lblSeatNumber.isHidden = true
                cell.imgSeat.isHidden = true
            }
            
        case 10:
            cell.lblSeatNumber.isHidden = false
            // cell.imgSeat.image = indexData?.availablityType == 1 ? .busUnSelectSeat() : .flightBookSeat()
            let code = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "K"})
            if code?.count ?? 0 > 0 {
                cell.lblSeatNumber.text = code?[0].code
                if code?.first!.availablityType == 1 {
                    if LoaderClass.shared.arrSelectedSeat.count > 0 {
                        cell.imgSeat.image = .busUnSelectSeat()
                        LoaderClass.shared.arrSelectedSeat[selectedCityCode].forEach { val in
                            if val.code == code?[0].code {
                                cell.imgSeat.image = .flightSelectSeat()
                            }
                        }
                    } else {
                        cell.imgSeat.image = .busUnSelectSeat()
                    }
                } else {
                    cell.imgSeat.image = .flightBookSeat()
                }
            } else {
                cell.lblSeatNumber.isHidden = true
                cell.imgSeat.isHidden = true
            }
            
        case 11:
            cell.lblSeatNumber.isHidden = false
            let code = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "L"})
            if code?.count ?? 0 > 0 {
                cell.lblSeatNumber.text = code?[0].code
                if code?.first!.availablityType == 1 {
                    if LoaderClass.shared.arrSelectedSeat.count > 0 {
                        cell.imgSeat.image = .busUnSelectSeat()
                        LoaderClass.shared.arrSelectedSeat[selectedCityCode].forEach { val in
                            if val.code == code?[0].code {
                                cell.imgSeat.image = .flightSelectSeat()
                            }
                        }
                    } else {
                        cell.imgSeat.image = .busUnSelectSeat()
                    }
                } else {
                    cell.imgSeat.image = .flightBookSeat()
                }
            } else {
                cell.lblSeatNumber.isHidden = true
                cell.imgSeat.isHidden = true
            }
            
        default:
            break
        }
        LoaderClass.shared.stopAnimation()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return viewController.returnCGSize(collectionView: collVwRowSeats, indexPath: indexPath, seatCount: rowCount, missingSeatIndex: missingSeatIndex)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let tableView = self.superview as? UITableView,
           let cellIndexPath = tableView.indexPath(for: self) {
            // Print the index paths
            // let cellIndexPath = IndexPath(row: cellIndexPath1.row-1, section: cellIndexPath1.section)
            print("Table view cell index path: \(cellIndexPath)")
            print("Collection view cell index path: \(indexPath)")
            
            
            LoaderClass.shared.loadAnimation()
            if LoaderClass.shared.arrSelectedSeat.count != arr.count {
                LoaderClass.shared.arrSelectedSeat = Array(repeating: [Seats](), count: arr.count)
            }
            let cell = collectionView.cellForItem(at: indexPath) as! FlightSeatXIB
            
            switch indexPath.row {
                
            case 0:
                let seat = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "A"})
                showSelectedData(seat ?? [], cell: cell, indexPath: indexPath)
                self.delegate?.collectionViewCellDidClick(self.priceData, cell1: cell, indexPath: cellIndexPath, isDeselected: isDelesected)
            case 1:
                let seat = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "B"})
                showSelectedData(seat ?? [], cell: cell, indexPath: indexPath)
                self.delegate?.collectionViewCellDidClick(self.priceData, cell1: cell, indexPath: cellIndexPath, isDeselected: isDelesected)
            case 2:
                let seat = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "C"})
                showSelectedData(seat ?? [], cell: cell, indexPath: indexPath)
                self.delegate?.collectionViewCellDidClick(self.priceData, cell1: cell, indexPath: cellIndexPath, isDeselected: isDelesected)
            case 3:
                let seat = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "D"})
                showSelectedData(seat ?? [], cell: cell, indexPath: indexPath)
                self.delegate?.collectionViewCellDidClick(self.priceData, cell1: cell, indexPath: cellIndexPath, isDeselected: isDelesected)
            case 4:
                let seat = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "E"})
                showSelectedData(seat ?? [], cell: cell, indexPath: indexPath)
                self.delegate?.collectionViewCellDidClick(self.priceData, cell1: cell, indexPath: cellIndexPath, isDeselected: isDelesected)
            case 5:
                let seat = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "F"})
                showSelectedData(seat ?? [], cell: cell, indexPath: indexPath)
                self.delegate?.collectionViewCellDidClick(self.priceData, cell1: cell, indexPath: cellIndexPath, isDeselected: isDelesected)
            case 6:
                let seat = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "G"})
                showSelectedData(seat ?? [], cell: cell, indexPath: indexPath)
                self.delegate?.collectionViewCellDidClick(self.priceData, cell1: cell, indexPath: cellIndexPath, isDeselected: isDelesected)
            case 7:
                let seat = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "H"})
                self.delegate?.collectionViewCellDidClick(self.priceData, cell1: cell, indexPath: cellIndexPath, isDeselected: isDelesected)
                showSelectedData(seat ?? [], cell: cell, indexPath: indexPath)
            case 8:
                let seat = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "I"})
                self.delegate?.collectionViewCellDidClick(self.priceData, cell1: cell, indexPath: cellIndexPath, isDeselected: isDelesected)
                showSelectedData(seat ?? [], cell: cell, indexPath: indexPath)

            case 9:
                let seat = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "J"})
                showSelectedData(seat ?? [], cell: cell, indexPath: indexPath)
                self.delegate?.collectionViewCellDidClick(self.priceData, cell1: cell, indexPath: cellIndexPath, isDeselected: isDelesected)
            case 10:
                let seat = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "K"})
                showSelectedData(seat ?? [], cell: cell, indexPath: indexPath)
                self.delegate?.collectionViewCellDidClick(self.priceData, cell1: cell, indexPath: cellIndexPath, isDeselected: isDelesected)
            case 11:
                let seat = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "L"})
                showSelectedData(seat ?? [], cell: cell, indexPath: indexPath)
                self.delegate?.collectionViewCellDidClick(self.priceData, cell1: cell, indexPath: cellIndexPath, isDeselected: isDelesected)
            case 12:
                let seat = arr[selectedCityCode].rowSeats?[tblSection].seats?.filter({$0.seatNo == "M"})
                showSelectedData(seat ?? [], cell: cell, indexPath: indexPath)
                self.delegate?.collectionViewCellDidClick(self.priceData, cell1: cell, indexPath: cellIndexPath, isDeselected: isDelesected)
            default:
                break
            }
            LoaderClass.shared.loadAnimation()
        }
        
        
    }
    func showSelectedData(_ seat: [Seats], cell: UICollectionViewCell, indexPath: IndexPath){
        if seat.count > 0 {
            LoaderClass.shared.seletedSeatIndex = LoaderClass.shared.arrSelectedSeat[selectedCityCode]
            if seat[0].availablityType == 1 {
                if LoaderClass.shared.seletedSeatIndex.contains(where: {$0.code == seat[0].code}) {
                    LoaderClass.shared.seletedSeatIndex.removeAll(where: { $0.code == seat[0].code })
                    isDelesected = true
                }else{
                    if LoaderClass.shared.seletedSeatIndex.count >= numberOfSeat {
                        LoaderClass.shared.seletedSeatIndex.removeFirst()
                    }
                    isDelesected = false
                    
                    // SHOW POPOVER
                    let label = UILabel()
                    label.text = "Seat No. : \(seat[0].code)\n ₹ : \(seat[0].price)"
                    label.numberOfLines = 0 // Allow the label to wrap text
                    label.textAlignment = .center
                    label.font = UIFont(name: "Metropolis-Regular",size: 13.0)// Center the text
                    let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
                    let aView = UIView(frame: CGRect(x: 0, y: 0, width: labelSize.width+15, height: labelSize.height+10))
                    label.frame = CGRect(x: 0, y: 10, width: aView.frame.size.width, height: aView.frame.size.height)
                    aView.addSubview(label)
                    let popover = Popover()
                    if cell.contentView.frame.width > 50 {
                        cell.contentView.frame = CGRect(x: cell.contentView.frame.origin.x - 20, y: cell.contentView.frame.origin.y, width: cell.contentView.frame.size.width, height: cell.contentView.frame.size.height)
                    }
                    popover.show(aView, fromView: cell.contentView)
                    DispatchQueue.main.asyncAfter(deadline: .now()+3) { popover.dismiss() }
                    
                    LoaderClass.shared.seletedSeatIndex.append(seat[0])
                   
                    self.seatPrice = Double(seat[0].price)
                    self.priceData = Double(Int(self.priceData) + Int(seat[0].price)).rounded()
                }
            }
            LoaderClass.shared.arrSelectedSeat[selectedCityCode] = LoaderClass.shared.seletedSeatIndex
        }
    }
}
