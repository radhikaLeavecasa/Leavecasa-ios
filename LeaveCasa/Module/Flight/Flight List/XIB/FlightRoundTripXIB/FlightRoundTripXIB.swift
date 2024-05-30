//
//  FlightRoundTripXIB.swift
//  LeaveCasa
//
//  Created by acme on 16/11/22.
//

import UIKit

class FlightRoundTripXIB: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblLayoverTime: UILabel!
    @IBOutlet weak var lblFlightNumber: UILabel!
    @IBOutlet weak var lblOnwordFlight: UILabel!
    @IBOutlet weak var lblOnwordFlightCode: UILabel!
    @IBOutlet weak var lblOnwordFlightFromTime: UILabel!
    @IBOutlet weak var lblOnwordFlighToCode: UILabel!
    @IBOutlet weak var lblOnwordFlightToTime: UILabel!
    @IBOutlet weak var lblOnwordFlightDuratIon: UILabel!
    @IBOutlet weak var lblOnwordFlightStops: UILabel!
    @IBOutlet weak var lblLayoverReturn: UILabel!
    //MARK: Return Flight
    @IBOutlet weak var lblFlightNumberReturn: UILabel!
    @IBOutlet weak var lblReturnFlight: UILabel!
    @IBOutlet weak var lblReturnFlightCode: UILabel!
    @IBOutlet weak var lblReturnFlightFromTime: UILabel!
    @IBOutlet weak var lblReturnFlighToCode: UILabel!
    @IBOutlet weak var lblReturnFlightToTime: UILabel!
    @IBOutlet weak var lblReturnFlightDuratIon: UILabel!
    @IBOutlet weak var lblReturnFlightStops: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgReturnFlight: UIImageView!
    @IBOutlet weak var imgFirstFlight: UIImageView!
    //MARK: - Variables
    let identifire = "FlightRoundTripXIB"
    //MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    //MARK: - Custom methods
    func setUp(indexPath: IndexPath, flight: Flight, paxNumber: Int) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedPrice = numberFormatter.string(from: NSNumber(value: flight.sFare.sPublishedFare))
        
        self.lblPrice.text = "₹\n\(formattedPrice ?? "")\n\nfor \(paxNumber) \(paxNumber == 1 ? "Pax" : "Paxes")"

        if let flightSegment = flight.sSegments as? [[FlightSegment]] {
            if let firstSeg = flightSegment[0].first  {
                let secondSeg = flightSegment[0].last
                
                var haultTime = Int()
                if ((secondSeg?.sAccDuration ?? 0) - (secondSeg?.sDuration ?? 0) - (firstSeg.sDuration)) < 0 {
                    haultTime = ((secondSeg?.sAccDuration ?? 0) - (secondSeg?.sDuration ?? 0) - (firstSeg.sDuration)) * -1
                } else {
                    haultTime = ((secondSeg?.sAccDuration ?? 0) - (secondSeg?.sDuration ?? 0) - (firstSeg.sDuration))
                }
                
                self.lblLayoverTime.text = ((flightSegment.first?.count ?? 0) - 1) == 0 ? "" : ((flightSegment.first?.count ?? 0) - 1) == 1 ? "\(haultTime.getDuration()) layover at \(secondSeg?.sOriginAirport.sCityName ?? "")" : "Multiple layovers"
            }
            if let firstSeg = flightSegment.last?.first  {
                let secondSeg = flightSegment.last?.last
                
                var haultTime = Int()
                if ((secondSeg?.sAccDuration ?? 0) - (secondSeg?.sDuration ?? 0) - (firstSeg.sDuration)) < 0 {
                    haultTime = ((secondSeg?.sAccDuration ?? 0) - (secondSeg?.sDuration ?? 0) - (firstSeg.sDuration)) * -1
                } else {
                    haultTime = ((secondSeg?.sAccDuration ?? 0) - (secondSeg?.sDuration ?? 0) - (firstSeg.sDuration))
                }
                
                self.lblLayoverReturn.text = ((flightSegment.first?.count ?? 0) - 1) == 0 ? "" : ((flightSegment.first?.count ?? 0) - 1) == 1 ? "\(haultTime.getDuration()) layover at \(secondSeg?.sOriginAirport.sCityName ?? "")" : "Multiple layovers"
            }
            
            if let firstSeg = flightSegment.first {
                self.imgFirstFlight.image = UIImage.init(named: firstSeg.first?.sAirline.sAirlineCode ?? "")
                
                let sSourceCode = firstSeg.first?.sOriginAirport.sCityCode
                let sOnwordTOCode = firstSeg.last?.sDestinationAirport.sCityCode
                let sAirlineName = firstSeg.first?.sAirline.sAirlineName
                let sStartTime = firstSeg.first?.sOriginDeptTime
                let sOnwordEndTime = firstSeg.last?.sDestinationArrvTime
                let sStopsCount = firstSeg.count - 1
                lblOnwordFlightStops.text = sStopsCount == 0 ? "Non-stop" : "\(sStopsCount) stop(s)"
                
                lblFlightNumber.text = "\(firstSeg.first?.sAirline.sAirlineCode ?? "") - \(firstSeg.first?.sAirline.sFlightNumber ?? "") \(firstSeg.first?.sAirline.sFareClass ?? "")"
                
                if let secondSeg = flightSegment.last {
                    self.imgReturnFlight.image = UIImage.init(named: secondSeg.first?.sAirline.sAirlineCode ?? "")
                    let sReturnEndTime = secondSeg.first?.sOriginDeptTime
                    let sEndTime = secondSeg.last?.sDestinationArrvTime
                    let sReturnSourceCode = secondSeg.first?.sOriginAirport.sCityCode
                    let sDestinationCode = secondSeg.last?.sDestinationAirport.sCityCode
                    let sReturnAirlineName = secondSeg.first?.sAirline.sAirlineName
                    let sStopsCount = secondSeg.count - 1
                    lblReturnFlightStops.text = sStopsCount == 0 ? "Non-stop" : "\(sStopsCount) stop(s)"
                    lblFlightNumberReturn.text = "\(secondSeg.first?.sAirline.sAirlineCode ?? "") - \(secondSeg.first?.sAirline.sFlightNumber ?? "") \(secondSeg.first?.sAirline.sFareClass ?? "")"
                    
                    
                    self.lblOnwordFlightFromTime.text = sStartTime?.convertStoredDate()
                    self.lblOnwordFlightToTime.text = sOnwordEndTime?.convertStoredDate()
                    self.lblOnwordFlightCode.text = sSourceCode?.uppercased()
                    self.lblOnwordFlighToCode.text = sOnwordTOCode?.uppercased()
                    self.lblOnwordFlight.text = sAirlineName
                    

                    let sAccDuration = secondSeg.last?.sAccDuration == 0 ? secondSeg.first?.sDuration : secondSeg.last?.sAccDuration
                    
                    let date1 =  LoaderClass.shared.calculateDaysBetweenDates(dateString1: secondSeg.first?.sOriginDeptTime.components(separatedBy: "T")[0] ?? "", dateString2: secondSeg.last?.sDestinationArrvTime.components(separatedBy: "T")[0] ?? "")
                    
                    self.lblReturnFlightDuratIon.text = "\(sAccDuration?.getDuration() ?? "") \(date1 ?? 0 > 0 ? "+\(date1 ?? 0)D" : "")"
                    
                  
                    self.lblReturnFlightFromTime.text = sReturnEndTime?.convertStoredDate()
                    self.lblReturnFlightToTime.text = sEndTime?.convertStoredDate()
                    self.lblReturnFlightCode.text = sReturnSourceCode?.uppercased()
                    self.lblReturnFlighToCode.text = sDestinationCode?.uppercased()
                    self.lblReturnFlight.text = sReturnAirlineName
                    
                    let sAccDuration1 = firstSeg.last?.sAccDuration == 0 ? firstSeg.first?.sDuration : firstSeg.last?.sAccDuration
                    
                    let date2 =  LoaderClass.shared.calculateDaysBetweenDates(dateString1: firstSeg.first?.sOriginDeptTime.components(separatedBy: "T")[0] ?? "", dateString2: firstSeg.last?.sDestinationArrvTime.components(separatedBy: "T")[0] ?? "")
                    
                    self.lblOnwordFlightDuratIon.text = "\(sAccDuration1?.getDuration() ?? "") \(date2 ?? 0 > 0 ? "+\(date2 ?? 0)D" : "")"
                }
            }
        }
    }
}
