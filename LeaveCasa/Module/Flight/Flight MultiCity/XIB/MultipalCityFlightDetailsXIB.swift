//
//  MultipalCityFlightDetailsXIB.swift
//  LeaveCasa
//
//  Created by acme on 17/11/22.
//

import UIKit

class MultipalCityFlightDetailsXIB: UITableViewCell {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblToTime: UILabel!
    @IBOutlet weak var lblToCode: UILabel!
    @IBOutlet weak var lblStops: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblFromTime: UILabel!
    @IBOutlet weak var lblFromCode: UILabel!
    @IBOutlet weak var imgAirlinse: UIImageView!
    @IBOutlet weak var lblAirlinse: UILabel!
    @IBOutlet weak var lblIndex: UILabel!
    //MARK: - Variables
    let identifire = "MultipalCityFlightDetailsXIB"
    //MARK: - Custom methods
    func setUp(flight: [FlightSegment]) {
        
        let flightSegment = flight
        
        if let firstSeg = flightSegment.first {
            _ = firstSeg.sOriginAirport.sCityName
            let sSourceCode = firstSeg.sOriginAirport.sCityCode
            let sAirlineName = firstSeg.sAirline.sAirlineName
            let sStartTime = firstSeg.sOriginDeptTime
            _ = firstSeg.sDuration
            _ = flightSegment.count - 1
            self.imgLogo.image = UIImage.init(named: firstSeg.sAirline.sAirlineCode)
            
            if let secondSeg = flightSegment.last {
                let sEndTime = secondSeg.sDestinationArrvTime
                _ = secondSeg.sDestinationAirport.sCityName
                let sDestinationCode = secondSeg.sDestinationAirport.sCityCode
                let sAccDuration = secondSeg.sAccDuration == 0 ? firstSeg.sDuration : secondSeg.sAccDuration
                
                self.lblFromTime.text = sStartTime.convertStoredDate()
                self.lblToTime.text = sEndTime.convertStoredDate()
                self.lblFromCode.text = "\(sSourceCode.uppercased())"
                self.lblToCode.text = "\(sDestinationCode.uppercased())"
                self.lblDuration.text = sAccDuration.getDuration()
                //                    self.lblRoute.text = sStopsCount == 0 ? "Non-stop" : "\(sStopsCount) stop(s)"
                self.lblAirlinse.text = sAirlineName
                
                //                    if let startTime = getStoredDate(sStartTime) {
                //                        let components = Calendar.current.dateComponents([ .hour, .minute], from: Date(), to: startTime)
                //
                //                        let hour = components.hour ?? 0
                //                        let minute = components.minute ?? 0
                //
                //                        if hour < 5 && hour > 0 {
                //                            self.lblFLightInfo.text = "< \(hour) hours"
                //                        } else if hour < 5 && minute > 0 {
                //                            self.lblFLightInfo.text = "< \(minute) minutes"
                //                        }
                //                    }
            }
        }
        
        var sStops = [FlightAirport]()
        
        for i in 1..<flightSegment.count {
            sStops.append(flightSegment[i].sOriginAirport)
        }
        
        //    var stops = ""
        
        //        if sStops.count == 1{
        //            stops = sStops[0].sCityName
        //        } else if sStops.count > 1{
        //            stops = "\(sStops[0].sCityName) + \(sStops.count)"
        //        }
        
        // self.lblStops.text = stops
        self.lblStops.text = sStops.count == 0 ? "Non-stop" : "\(sStops.count) stop(s)"
    }
}
