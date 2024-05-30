//
//  PackageFilterVC.swift
//  LeaveCasa
//
//  Created by acme on 04/04/24.
//

import UIKit

protocol PackageList {
    func packageList(withFlight: Bool, withOutFlight: Bool, twoN: Bool, threeN: Bool, fourN: Bool, fiveN: Bool)
}

class PackageFilterVC: UIViewController {
    //MARK: - @IBOutlets
    
    @IBOutlet weak var imgVw5D: UIImageView!
    @IBOutlet weak var imgVw4N: UIImageView!
    @IBOutlet weak var imgVw3N: UIImageView!
    @IBOutlet weak var imgVw2N: UIImageView!
    @IBOutlet weak var imgVwWithoutFlight: UIImageView!
    @IBOutlet weak var imgVwWithFlight: UIImageView!
    @IBOutlet weak var btnReset: UIButton!
    //MARK: - Variables
    var withFlight = Bool()
    var withOutFlight = Bool()
    var twoNights = Bool()
    var threeNights = Bool()
    var fourNights = Bool()
    var fiveNights = Bool()
    var delegate : PackageList?
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        imgVwWithFlight.image = withFlight ? .checkMark() : .uncheckMark()
        imgVwWithoutFlight.image = withOutFlight ? .checkMark() : .uncheckMark()
        imgVw2N.image = twoNights ? .checkMark() : .uncheckMark()
        imgVw3N.image = threeNights ? .checkMark() : .uncheckMark()
        imgVw4N.image = fourNights ? .checkMark() : .uncheckMark()
        imgVw5D.image = fiveNights ? .checkMark() : .uncheckMark()
    }
    //MARK: - @IBActions
    @IBAction func actionBack(_ sender: Any) {
        
        if let del = self.delegate {
            del.packageList(withFlight: withFlight, withOutFlight: withOutFlight, twoN: twoNights, threeN: threeNights, fourN: fourNights, fiveN: fiveNights)
        }
        self.popView()
        
        if withFlight != false || withOutFlight != false || twoNights != false || threeNights != false || fourNights != false || fiveNights != false {
            LoaderClass.shared.showSnackBar(message: "Filter applied successfully!")
        }
    }
    @IBAction func actionReset(_ sender: Any) {
        btnReset.isSelected = true
        self.imgVwWithFlight.image = .uncheckMark()
        self.imgVwWithoutFlight.image = .uncheckMark()
        self.imgVw2N.image = .uncheckMark()
        self.imgVw3N.image = .uncheckMark()
        self.imgVw4N.image = .uncheckMark()
        self.imgVw5D.image = .uncheckMark()
        withFlight = false
        withOutFlight = false
        twoNights = false
        threeNights = false
        fourNights = false
        fiveNights = false
    }
    
    @IBAction func actionFlight(_ sender: UIButton) {
        if sender.tag == 0 {
            self.imgVwWithFlight.image = sender.isSelected ? .uncheckMark() : .checkMark()
            withFlight = !sender.isSelected ? true : false
        } else {
            self.imgVwWithoutFlight.image = sender.isSelected ? .uncheckMark() : .checkMark()
            withOutFlight = !sender.isSelected ? true : false
        }
        sender.isSelected = !sender.isSelected
    }
    @IBAction func actionDaysNights(_ sender: UIButton) {
        if sender.tag == 0 {
            self.imgVw2N.image = sender.isSelected ? .uncheckMark() : .checkMark()
            twoNights = !sender.isSelected ? true : false
        } else if sender.tag == 1 {
            self.imgVw3N.image = sender.isSelected ? .uncheckMark() : .checkMark()
            threeNights = !sender.isSelected ? true : false
        } else if sender.tag == 2 {
            self.imgVw4N.image = sender.isSelected ? .uncheckMark() : .checkMark()
            fourNights = !sender.isSelected ? true : false
        } else if sender.tag == 3 {
            self.imgVw5D.image = sender.isSelected ? .uncheckMark() : .checkMark()
            fiveNights = !sender.isSelected ? true : false
        }
        sender.isSelected = !sender.isSelected
    }
    @IBAction func actionApply(_ sender: Any) {
        if let del = self.delegate {
            del.packageList(withFlight: withFlight, withOutFlight: withOutFlight, twoN: twoNights, threeN: threeNights, fourN: fourNights, fiveN: fiveNights)
        }
        self.popView()
    }
}
