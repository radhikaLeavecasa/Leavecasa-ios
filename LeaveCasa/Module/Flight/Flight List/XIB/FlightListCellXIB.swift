//
//  FlightListCellXIB.swift
//  LeaveCasa
//
//  Created by acme on 01/11/22.
//

import UIKit
import IBAnimatable

class FlightListCellXIB: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblFlightNumber: UILabel!
    @IBOutlet weak var btnFareRule: UIButton!
    @IBOutlet weak var btnSeatLeft: UIButton!
    @IBOutlet weak var imgBG: UIView!
    @IBOutlet weak var imgDotted: UIImageView!
    @IBOutlet weak var imgBlackPlane: UIImageView!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFLightInfo: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblRoute: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblStops: UILabel!
    @IBOutlet weak var lblAirline: UILabel!
    @IBOutlet weak var lblHaultTime: UILabel!
    @IBOutlet weak var mainView: AnimatableView!
    //MARK: - Variables
    let identifire = "FlightListCellXIB"
    
    //MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Custom methods
    func setUp(indexPath: IndexPath, flight: Flight, paxNumber: Int) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedPrice = numberFormatter.string(from: NSNumber(value: (Int(flight.sPrice))))

        self.lblPrice.text = "₹\n\(formattedPrice ?? "")\n\nfor \(paxNumber) \(paxNumber == 1 ? "Pax" : "Paxes")"
        
        if let flightSegment = flight.sSegments[0] as? [FlightSegment] {
            
         //   self.imgDotted.isHidden = flight.sSegments.count - 1 == indexPath.row
            
            self.btnSeatLeft.setTitle("\(flightSegment.first?.sNoOfSeatAvailable ?? 0) seat(s) left", for: .normal)
            
            if let firstSeg = flightSegment.first {
                let sSourceCode = firstSeg.sOriginAirport.sCityCode
                let sAirlineName = firstSeg.sAirline.sAirlineName
                let sStartTime = firstSeg.sOriginDeptTime
                let sStopsCount = flightSegment.count - 1
                lblFlightNumber.text = "\(firstSeg.sAirline.sAirlineCode) - \(firstSeg.sAirline.sFlightNumber) \(firstSeg.sAirline.sFareClass)"
                self.imgLogo.image = UIImage.init(named: firstSeg.sAirline.sAirlineCode) == nil ? .placeHolder() : UIImage.init(named: firstSeg.sAirline.sAirlineCode)
                
                if let secondSeg = flightSegment.last {
                    let sEndTime = secondSeg.sDestinationArrvTime
                    let sDestinationCode = secondSeg.sDestinationAirport.sCityCode
                    let sAccDuration = secondSeg.sAccDuration == 0 ? firstSeg.sDuration : secondSeg.sAccDuration
                    
                    self.lblStartTime.text = sStartTime.convertStoredDate()
                    self.lblEndTime.text = sEndTime.convertStoredDate()
                    self.lblSource.text = "\(sSourceCode.uppercased())"
                    self.lblDestination.text = "\(sDestinationCode.uppercased())"
                    
                    let date2 =  LoaderClass.shared.calculateDaysBetweenDates(dateString1: firstSeg.sOriginDeptTime.components(separatedBy: "T")[0], dateString2: secondSeg.sDestinationArrvTime.components(separatedBy: "T")[0])
                    
                    self.lblDuration.text = "\(sAccDuration.getDuration()) \(date2 ?? 0 > 0 ? "+\(date2 ?? 0)D" : "")"
                    
                   // self.lblDuration.text = sAccDuration.getDuration()
                    self.lblStops.text = sStopsCount == 0 ? "Non-stop" : "\(sStopsCount) stop(s)"
                    var haultTime = Int()
                    if (secondSeg.sAccDuration - secondSeg.sDuration - firstSeg.sDuration) < 0 {
                        haultTime = (secondSeg.sAccDuration - secondSeg.sDuration - firstSeg.sDuration) * -1
                    } else {
                        haultTime = (secondSeg.sAccDuration - secondSeg.sDuration - firstSeg.sDuration)
                    }
                    self.lblHaultTime.text = sStopsCount == 0 ? "" : sStopsCount == 1 ? "\(haultTime.getDuration()) layover at \(secondSeg.sOriginAirport.sCityName)" : "Multiple layovers"
                    
                    self.lblAirline.text = sAirlineName
                }
            }
        }
    }
}
