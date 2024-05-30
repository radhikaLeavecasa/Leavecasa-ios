//
//  BusSeatViewModel.swift
//  LeaveCasa
//
//  Created by acme on 11/10/22.
//

import Foundation
import ObjectMapper

class BusSeatViewModel{
    
    var delegate : ResponseProtocol?
    var seatsLower = [BusSeat]()
    var seatsUpper = [BusSeat]()
    var rowsOfSeats = [Int]()
    var columnsOfSeats = [Int]()
    var rowsOfSeatsUpper = [Int]()
    var columnsOfSeatsUpper = [Int]()
    var isZIndex = false
    var busLayout: BusLayout?
    
    func callApiSeat(param:[String:Any],view:UIViewController){
        LoaderClass.shared.loadAnimation()
        WebService.callApi(api: .busSeatLayout, param: param) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            let response = response as? [String:Any] ?? [:]
            self.seatsLower.removeAll()
            self.seatsUpper.removeAll()
            if status == true{
                if let layouts = response[WSResponseParams.WS_RESP_PARAM_LAYOUT] as? [String: Any] , let layout = Mapper<BusLayout>().map(JSON: layouts) as BusLayout? {
                    DispatchQueue.main.async {
                        self.busLayout = layout
                        
                        for index in layout.sSeats {
                            if index.sZIndex == 0{
                                self.seatsLower.append(index)
                            }else{
                                self.seatsUpper.append(index)
                            }
                        }
                        
                        self.seatsLower = (self.seatsLower).sorted(by: { s1, s2 in
                            return s1.sRow < s2.sRow
                        })
                        
                        
                        self.seatsUpper = (self.seatsUpper).sorted(by: { s1, s2 in
                            return s1.sRow < s2.sRow
                        })
                        
//                        .sorted(by: { s1, s2 in
//                            return s1.sColumn < s2.sColumn
//                        })
//                        //
//                        self.rowsOfSeats = Array(Set(self.seatsLower.map { bus in
//                            bus.sRow
//                        })).sorted(by: { s1, s2 in
//                            return s1 < s2
//                        })
//                        self.columnsOfSeats = Array(Set(self.seatsLower.map { bus in
//                            bus.sColumn
//                        })).sorted(by: { s1, s2 in
//                            return s1 < s2
//                        })
                        
                        
//                        self.seatsLower = (self.seatsLower).sorted(by: { s1, s2 in
//                            if let r1 = Int(s1.sName), let r2 = Int(s2.sName) {
//                                return r1 < r2
//                            }
//                            return s1.sName < s2.sName
//                        })
//                        .sorted(by: { s1, s2 in
//                            return s1.sRow < s2.sRow
//                        })
//                        .sorted(by: { s1, s2 in
//                            return s1.sColumn < s2.sColumn
//                        })
//                        //
//                        self.rowsOfSeats = Array(Set(self.seatsLower.map { bus in
//                            bus.sRow
//                        })).sorted(by: { s1, s2 in
//                            return s1 < s2
//                        })
//                        self.columnsOfSeats = Array(Set(self.seatsLower.map { bus in
//                            bus.sColumn
//                        })).sorted(by: { s1, s2 in
//                            return s1 < s2
//                        })
                        
//                        self.seatsUpper = (self.seatsUpper).sorted(by: { s1, s2 in
//                            if let r1 = Int(s1.sName), let r2 = Int(s2.sName) {
//                                return r1 < r2
//                            }
//                            return s1.sName < s2.sName
//                        })
//                        .sorted(by: { s1, s2 in
//                            return s1.sRow < s2.sRow
//                        })
//                        .sorted(by: { s1, s2 in
//                            return s1.sColumn < s2.sColumn
//                        })
//                        //
//                        self.rowsOfSeatsUpper = Array(Set(self.seatsUpper.map { bus in
//                            bus.sRow
//                        })).sorted(by: { s1, s2 in
//                            return s1 < s2
//                        })
//                        self.columnsOfSeatsUpper = Array(Set(self.seatsUpper.map { bus in
//                            bus.sColumn
//                        })).sorted(by: { s1, s2 in
//                            return s1 < s2
//                        })
                        
//                        print(self.columnsOfSeats.count)
//                        print(self.rowsOfSeats.count)
//                        
//                        print(self.columnsOfSeatsUpper.count)
//                        print(self.rowsOfSeatsUpper.count)
//                        
//                        print(self.findMissingNo(arrA: self.rowsOfSeats))
                        self.rowsOfSeats = (self.findMissingNo(arrA: self.rowsOfSeats) + self.rowsOfSeats).sorted(by: { (index1, index2) -> Bool in
                            return index1 < index2
                        })
                        
                        self.rowsOfSeatsUpper = (self.findMissingNo(arrA: self.rowsOfSeatsUpper) + self.rowsOfSeatsUpper).sorted(by: { (index1, index2) -> Bool in
                            return index1 < index2
                        })
                        
                        self.delegate?.onSuccess()
                        
                    }
                }
            }else{
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    LoaderClass.shared.stopAnimation()
                    view.pushNoInterConnection(view: view, titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
    
    func findMissingNo(arrA: [Int]) -> [Int] {
        let firstIndex = arrA.first ?? 0
        let lastIndex = arrA.last ?? 0
        let rslt = Array(firstIndex...lastIndex)
        let missingNoArray = rslt.filter{ !arrA.contains($0)}
        return missingNoArray
    }
}
