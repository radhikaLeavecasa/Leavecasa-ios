//
//  ReturnTripFlightXIB.swift
//  LeaveCasa
//
//  Created by acme on 01/02/23.
//

import UIKit
import IBAnimatable

class ReturnTripFlightXIB: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblLayoverTime: UILabel!
    @IBOutlet weak var lblFlightNumber: UILabel!
    @IBOutlet weak var lblStop: UILabel!
    @IBOutlet weak var lblTimeDiff: UILabel!
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
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var mainView: AnimatableView!
    //MARK: - Variables
    let identifire = "ReturnTripFlightXIB"
    
    //MARK: - Custom methods
    func setUp(indexPath: IndexPath, flight: Flight) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedPrice = numberFormatter.string(from: NSNumber(value: (Int(flight.sFare.sPublishedFare.rounded()))))

        self.lblPrice.text = "₹\(flight.sFare.sPublishedFare)"
        
        if let flightSegment = flight.sSegments[indexPath.row] as? [FlightSegment]{
            if let firstSeg = flightSegment.first {
                
                let sSourceCode = firstSeg.sOriginAirport.sCityCode
                let sAirlineName = firstSeg.sAirline.sAirlineName
                let sStartTime = firstSeg.sOriginDeptTime
                let sStopsCount = flightSegment.count - 1
                
                
                self.lblStop.text = sStopsCount == 0 ? "Non-stop" : "\(sStopsCount) stop(s)"
                self.btnSeatLeft.setTitle("\(flightSegment.first?.sNoOfSeatAvailable ?? 0) seat(s) left", for: .normal)
                lblFlightNumber.text = "\(firstSeg.sAirline.sAirlineCode) - \(firstSeg.sAirline.sFlightNumber) \(firstSeg.sAirline.sFareClass)"
                
                if let secondSeg = flightSegment.last {
                    let sEndTime = secondSeg.sDestinationArrvTime
                    let sDestinationCode = secondSeg.sDestinationAirport.sCityCode
                    self.lblStartTime.text = sStartTime.convertStoredDate()
                    self.lblEndTime.text = sEndTime.convertStoredDate()
                    self.lblSource.text = "\(sSourceCode.uppercased())"
                    self.lblDestination.text = "\(sDestinationCode.uppercased())"
                    self.lblAirline.text = sAirlineName
                    
                    var haltTime = Int()
                    if ((secondSeg.sAccDuration) - (secondSeg.sDuration) - (firstSeg.sDuration)) < 0 {
                        haltTime = ((secondSeg.sAccDuration) - (secondSeg.sDuration) - (firstSeg.sDuration)) * -1
                    } else {
                        haltTime = ((secondSeg.sAccDuration) - (secondSeg.sDuration) - (firstSeg.sDuration))
                    }
                    
                    self.lblLayoverTime.text = sStopsCount == 0 ? "" : sStopsCount == 1 ? "\(haltTime.getDuration()) layover at \(secondSeg.sOriginAirport.sCityName)" : "Multiple layovers"
                    
                    let sAccDuration = secondSeg.sAccDuration == 0 ? firstSeg.sDuration : secondSeg.sAccDuration
                    
                    let date1 =  LoaderClass.shared.calculateDaysBetweenDates(dateString1: firstSeg.sOriginDeptTime.components(separatedBy: "T")[0], dateString2: secondSeg.sDestinationArrvTime.components(separatedBy: "T")[0])
                    self.lblTimeDiff.text = "\(sAccDuration.getDuration()) \(date1 ?? 0 > 0 ? "+\(date1 ?? 0)D" : "")"
                }
            }
        }
    }
}

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: self)
    }
}
