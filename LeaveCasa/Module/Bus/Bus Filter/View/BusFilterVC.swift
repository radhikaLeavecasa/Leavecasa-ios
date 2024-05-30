//
//  BusFilterVC.swift
//  LeaveCasa
//
//  Created by acme on 05/12/22.
//

import UIKit
import IBAnimatable

protocol BusFilterData {
    func BusFilterData(isSleeper: Bool, isSeater: Bool, isAC: Bool, befor6: Bool, after6to12: Bool, after12To18: Bool, after18To24: Bool, cheapestFirst: Bool, earlyDeparture: Bool, lateDeparture: Bool, isNonAc: Bool)
}

class BusFilterVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lbl6to12: UILabel!
    @IBOutlet weak var moonView: AnimatableView!
    
    @IBOutlet weak var lblTime12To6: UILabel!
    @IBOutlet weak var sun12to6View: AnimatableView!
    
    @IBOutlet weak var sunView: AnimatableView!
    @IBOutlet weak var lblSunTime: UILabel!
    
    @IBOutlet weak var sunWakeupView: AnimatableView!
    @IBOutlet weak var lblSunWakeup: UILabel!
    
    @IBOutlet weak var lblAC: UILabel!
    @IBOutlet weak var acView: AnimatableView!
    
    @IBOutlet weak var lblSeater: UILabel!
    @IBOutlet weak var seaterView: AnimatableView!
    
    @IBOutlet weak var sleeperView: AnimatableView!
    @IBOutlet weak var lblSleeper: UILabel!
    
    @IBOutlet weak var lblCheapestFirst: UILabel!
    @IBOutlet weak var cheapestFirstView: AnimatableView!
    
    @IBOutlet weak var lblEarlyDeparture: UILabel!
    @IBOutlet weak var earlyDepartureView: AnimatableView!
    
    @IBOutlet weak var lblLateDeparture: UILabel!
    @IBOutlet weak var lateDepartureView: AnimatableView!
    
    @IBOutlet weak var btnAc: UIButton!
    @IBOutlet weak var btnSleeper: UIButton!
    @IBOutlet weak var btnSeater: UIButton!
    
    @IBOutlet weak var btnBefore6: UIButton!
    @IBOutlet weak var btnAfter6To12: UIButton!
    @IBOutlet weak var btnAfter12To18: UIButton!
    @IBOutlet weak var btnAfter18To24: UIButton!
    
    @IBOutlet weak var btnCheapestFirst: UIButton!
    @IBOutlet weak var btnEarlyDeparture: UIButton!
    @IBOutlet weak var btnLateDeparture: UIButton!
    
    //MARK: - Variables
    var delegate: BusFilterData?
    var isNonAC = false
    var isAC = false
    var isSleeper = false
    var isSeater = false
    
    var befor6 = false
    var after6to12 = false
    var after12To18 = false
    var after18To24 = false
    
    var cheapestFirst = false
    var earlyDeparture = false
    var lateDeparture = false
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil

        if cheapestFirst == true {
            btnCheapestFirst.isSelected = false
            cheapestFirstView(sender: btnCheapestFirst)
        }

        if earlyDeparture == true {
            btnEarlyDeparture.isSelected = false
            earlyDepartureView(sender: btnEarlyDeparture)
        }

        if lateDeparture == true {
            btnLateDeparture.isSelected = false
            lateDepartureView(sender: btnLateDeparture)
        }

        if isAC == true {
            btnAc.isSelected = false
            acPress(sender: btnAc)
        }

        if isSeater == true {
            btnSeater.isSelected = false
            seaterPress(sender: btnSeater)
        }

        if isSleeper == true {
            btnSleeper.isSelected = false
            sleeperPress(sender: btnSleeper)
        }

        if befor6 == true {
            btnBefore6.isSelected = false
            befor6OnPress(sender: btnBefore6)
        }

        if after6to12 == true {
            btnAfter6To12.isSelected = false
            sunView(sender: btnAfter6To12)
        }

        if after12To18 == true {
            btnAfter12To18.isSelected = false
            sun12to6(sender: btnAfter12To18)
        }

        if after18To24 == true {
            btnAfter18To24.isSelected = false
            moonView(sender: btnAfter18To24)
        }
        
        self.view.bringSubviewToFront(self.btnEarlyDeparture)
        self.view.bringSubviewToFront(self.btnLateDeparture)
    }
    
    //MARK: - @IBActions
    @IBAction func sunWakeupOnPress(_ sender: UIButton) {
        befor6OnPress(sender: sender)
    }
    
    @IBAction func sunSetOnPress(_ sender: UIButton) {
        sunView(sender: sender)
    }
    
    @IBAction func sunOnPress(_ sender: UIButton) {
        sun12to6(sender: sender)
    }
    
    @IBAction func monnOnPress(_ sender: UIButton) {
        moonView(sender: sender)
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        if let del = delegate {
            del.BusFilterData(isSleeper: isSleeper, isSeater: isSeater, isAC: isAC , befor6: befor6, after6to12: after6to12, after12To18: after12To18, after18To24: after18To24, cheapestFirst: cheapestFirst, earlyDeparture: earlyDeparture, lateDeparture: lateDeparture, isNonAc: isNonAC)
            self.popView()
        }
    }
    
    @IBAction func cheapestFirstOnPress(_ sender: UIButton) {
        cheapestFirstView(sender: sender)
        
        btnEarlyDeparture.isSelected = true
        earlyDepartureView(sender: btnEarlyDeparture)
        
        btnLateDeparture.isSelected = true
        lateDepartureView(sender: btnLateDeparture)
    }
    
    @IBAction func earlyDepartureOnPress(_ sender: UIButton) {
        btnCheapestFirst.isSelected = true
        cheapestFirstView(sender: btnCheapestFirst)
        
        earlyDepartureView(sender: sender)
        
        btnLateDeparture.isSelected = true
        lateDepartureView(sender: btnLateDeparture)
    }
    
    @IBAction func lateDepartureOnPress(_ sender: UIButton) {
        btnCheapestFirst.isSelected = true
        cheapestFirstView(sender: btnCheapestFirst)
        
        btnEarlyDeparture.isSelected = true
        earlyDepartureView(sender: btnEarlyDeparture)
        
        lateDepartureView(sender: sender)
    }
    
    @IBAction func resetOnPress(_ sender: UIButton) {
        resetPassword()
        if let del = delegate {
            del.BusFilterData(isSleeper: false, isSeater: false, isAC: false , befor6: false, after6to12: false, after12To18: false, after18To24: false, cheapestFirst: false, earlyDeparture: false, lateDeparture: false, isNonAc: isNonAC)
          
        }
    }
    
    
    @IBAction func applyOnPress(_ sender: UIButton) {
        if let del = delegate {
            del.BusFilterData(isSleeper: isSleeper, isSeater: isSeater, isAC: isAC , befor6: befor6, after6to12: after6to12, after12To18: after12To18, after18To24: after18To24, cheapestFirst: cheapestFirst, earlyDeparture: earlyDeparture, lateDeparture: lateDeparture, isNonAc: isNonAC)
            self.popView()
        }
    }
    
    @IBAction func seaterOnPress(_ sender: UIButton) {
        self.seaterPress(sender: sender)
    }
    
    @IBAction func acOnPress(_ sender: UIButton) {
        self.acPress(sender: sender)
    }
    
    @IBAction func sleepOnPress(_ sender: UIButton) {
        self.sleeperPress(sender: sender)
    }
    
    func resetPassword() {
        if cheapestFirst == true {
            cheapestFirstView(sender: btnCheapestFirst)
        }
        
        if earlyDeparture == true {
            earlyDepartureView(sender: btnEarlyDeparture)
        }
        
        if lateDeparture == true {
            lateDepartureView(sender: btnLateDeparture)
        }
        
        if isAC == true {
            acPress(sender: btnAc)
        }
        
        if isSeater == true {
            seaterPress(sender: btnSeater)
        }
        
        if isSleeper == true {
            sleeperPress(sender: btnSleeper)
        }
        
        if befor6 == true {
            befor6OnPress(sender: btnBefore6)
        }
        
        if after6to12 == true {
            sunView(sender: btnAfter6To12)
        }
        
        if after12To18 == true {
            sun12to6(sender: btnAfter12To18)
        }
        
        if after18To24 == true {
            moonView(sender: btnAfter18To24)
        }
    }
    
    func sleeperPress(sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.lblSleeper.textColor = .cutomRedColor()
            self.sleeperView.borderColor = .cutomRedColor()
            self.sleeperView.borderWidth = 1
            self.isSleeper = true
        }
        else {
            sender.isSelected = false
            self.lblSleeper.textColor = .theamColor()
            self.sleeperView.borderColor = .clear
            self.sleeperView.borderWidth = 0
            self.isSleeper = false
        }
    }
    
    func moonView(sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.lbl6to12.textColor = .cutomRedColor()
            self.moonView.borderColor = .cutomRedColor()
            self.moonView.borderWidth = 1
            self.after18To24 = true
        }
        else {
            sender.isSelected = false
            self.lbl6to12.textColor = .theamColor()
            self.moonView.borderColor = .clear
            self.moonView.borderWidth = 0
            self.after18To24 = false
        }
    }
    
    func sun12to6(sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.lblTime12To6.textColor = .cutomRedColor()
            self.sun12to6View.borderColor = .cutomRedColor()
            self.sun12to6View.borderWidth = 1
            self.after12To18 = true
        }
        else{
            sender.isSelected = false
            self.lblTime12To6.textColor = .theamColor()
            self.sun12to6View.borderColor = .clear
            self.sun12to6View.borderWidth = 0
            self.after12To18 = false
        }
    }
    
    func sunView(sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.lblSunTime.textColor = .cutomRedColor()
            self.sunView.borderColor = .cutomRedColor()
            self.sunView.borderWidth = 1
            self.after6to12 = true
        }
        else {
            sender.isSelected = false
            self.lblSunTime.textColor = .theamColor()
            self.sunView.borderColor = .clear
            self.sunView.borderWidth = 0
            self.after6to12 = false
        }
    }
    
    func befor6OnPress(sender: UIButton) {
        if sender.isSelected == false{
            sender.isSelected = true
            self.lblSunWakeup.textColor = .cutomRedColor()
            self.sunWakeupView.borderColor = .cutomRedColor()
            self.sunWakeupView.borderWidth = 1
            self.befor6 = true
        }
        else {
            sender.isSelected = false
            self.lblSunWakeup.textColor = .theamColor()
            self.sunWakeupView.borderColor = .clear
            self.sunWakeupView.borderWidth = 0
            self.befor6 = false
        }
    }
    
    func seaterPress(sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.lblSeater.textColor = .cutomRedColor()
            self.seaterView.borderColor = .cutomRedColor()
            self.seaterView.borderWidth = 1
            self.isSeater = true
        }
        else {
            sender.isSelected = false
            self.lblSeater.textColor = .theamColor()
            self.seaterView.borderColor = .clear
            self.seaterView.borderWidth = 0
            self.isSeater = false
        }
    }
    
    func acPress(sender:UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.lblAC.textColor = .cutomRedColor()
            self.acView.borderColor = .cutomRedColor()
            self.acView.borderWidth = 1
            self.isAC = true
        }
        else {
            sender.isSelected = false
            self.lblAC.textColor = .theamColor()
            self.acView.borderColor = .clear
            self.acView.borderWidth = 0
            self.isAC = false
        }
    }
    
    func cheapestFirstView(sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.lblCheapestFirst.textColor = .cutomRedColor()
            self.cheapestFirstView.borderColor = .cutomRedColor()
            self.cheapestFirstView.backgroundColor = .clear
            self.cheapestFirstView.borderWidth = 1
            self.cheapestFirst = true
        } else {
            sender.isSelected = false
            self.cheapestFirstView.backgroundColor = .systemGray5
            self.lblCheapestFirst.textColor = .theamColor()
            self.cheapestFirstView.borderColor = .clear
            self.cheapestFirstView.borderWidth = 0
            self.cheapestFirst = false
        }
    }
    
    func earlyDepartureView(sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.lblEarlyDeparture.textColor = .cutomRedColor()
            self.earlyDepartureView.borderColor = .cutomRedColor()
            self.earlyDepartureView.backgroundColor = .clear
            self.earlyDepartureView.borderWidth = 1
            self.earlyDeparture = true
        } else {
            sender.isSelected = false
            self.earlyDepartureView.backgroundColor = .systemGray5
            self.lblEarlyDeparture.textColor = .theamColor()
            self.earlyDepartureView.borderColor = .clear
            self.earlyDepartureView.borderWidth = 0
            self.earlyDeparture = false
        }
    }
    
    func lateDepartureView(sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.lateDepartureView.backgroundColor = .clear
            self.lblLateDeparture.textColor = .cutomRedColor()
            self.lateDepartureView.borderColor = .cutomRedColor()
            self.lateDepartureView.borderWidth = 1
            self.lateDeparture = true
        } else {
            sender.isSelected = false
            self.lblLateDeparture.textColor = .theamColor()
            self.lateDepartureView.borderColor = .clear
            self.lateDepartureView.backgroundColor = .systemGray5
            self.lateDepartureView.borderWidth = 0
            self.lateDeparture = false
        }
    }
}
