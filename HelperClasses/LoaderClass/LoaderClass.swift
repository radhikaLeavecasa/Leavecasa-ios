//
//  LoaderClass.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 02/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import TTGSnackbar

class LoaderClass: UIViewController, NVActivityIndicatorViewable,UIPopoverPresentationControllerDelegate {
    
    static let shared = LoaderClass()
   
    var snackBar : TTGSnackbar?
    var timer: Timer?
    var sourceSestination : String?
    var dateTime: String?
    var isFareScreen = false
    var params1: [String: Any] = [:]
    var array = [FlightStruct]()
    var seletedSeats = [String]()
    var seletedSeatIndex = [Seats]()
    var arrSelectedSeat = [[Seats]]()
    var arrSelectedMealDynamic = [[MealDynamic]]()
    var arrSelectedMeal = [[Meal]]()
    var arrSelectedBaggageDynamic = [[Baggage]]()
    var tapLocation = CGPoint()
    var arrSearchResultAll = [CitySearchModel]()
    var arrDomesticSearches = [CitySearchModel]()
    var arrInternationalSearches = [CitySearchModel]()
    var passengerReturn: [String: Any] = [:]
    var numberOfAdults = 0
    var numberOfChildren = 0
    var numberOfInfants = 0
    var ownwardMobileCode = String()
    var isFirstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showSnackBar(message: String) {
        view.endEditing(true)
        snackBar?.dismiss()
        snackBar = TTGSnackbar(message: message, duration: .middle)
        snackBar?.backgroundColor = UIColor(named: "TEXT_BLACK_COLOR")!
        snackBar?.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.white
    }
    
    func loadAnimation() {
        self.startAnimating(CGSize(width: 60, height: 60), message:"", messageFont: UIFont(name: "Montserrat Regular",size: 12.0), type: .lineSpinFadeLoader, color: .lightBlue(), padding: 5, displayTimeThreshold: 5, minimumDisplayTime: 5, backgroundColor: .black.withAlphaComponent(0.2), textColor: .darkGray, fadeInAnimation: nil)
    }
    func stopAnimation(){
        self.stopAnimating()
    }
    
    func calculateAge(from dateString: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: date, to: Date())
            return ageComponents.year
        }
        
        return nil
    }
    
    func presentPopover(_ parentViewController: UIViewController, _ viewController: UIViewController, sender: UIView, size: CGSize, arrowDirection: UIPopoverArrowDirection = .any, frame: CGRect = .zero) {
        viewController.preferredContentSize = size
        viewController.modalPresentationStyle = .popover
        if let pres = viewController.popoverPresentationController {
            pres.delegate = self
            //parentViewController as? any UIAdaptivePresentationControllerDelegate
        }
        parentViewController.present(viewController, animated: true)
        if let pop = viewController.popoverPresentationController {
            pop.sourceView = sender
            pop.sourceRect = sender.bounds
            pop.backgroundColor = .white
            pop.permittedArrowDirections = arrowDirection
            pop.sourceRect = frame
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    func calculateWidthForCell(at indexPath: IndexPath, arr:[String]) -> CGFloat {
        let content = arr[indexPath.row] // Get the content for this cell
        let textWidth = content.size(withAttributes: [NSAttributedString.Key.font: UIFont.regularFont(size: 12)]).width // Calculate the width of the content
        
        // You can also add some extra padding if needed
        let cellWidth = textWidth + 20
        
        return cellWidth
    }
    func presentPopover2(_ parentViewController: UIViewController, _ viewController: UIViewController, collectionViewCell: UICollectionViewCell, collectionViewIndexPath: IndexPath, tableViewCell: UITableViewCell, tableViewIndexPath: IndexPath, size: CGSize, arrowDirection: UIPopoverArrowDirection = .any, frame: CGRect = .zero) {
        viewController.preferredContentSize = size
        viewController.modalPresentationStyle = .popover
        
        if let pres = viewController.popoverPresentationController {
            pres.delegate = self
        }
        UIApplication.topViewController()?.present(viewController, animated: true)
        //parentViewController.present(viewController, animated: true)
        
        if let pop = viewController.popoverPresentationController {
            if let collectionView = collectionViewCell.superview as? UICollectionView {
                let rectInCollectionView = collectionView.layoutAttributesForItem(at: collectionViewIndexPath)?.frame
                let rectInSuperview = collectionView.convert(rectInCollectionView ?? .zero, to: collectionView.superview)
                pop.sourceRect = rectInSuperview
                pop.sourceView = collectionView.superview
            }
            
            if let tableView = tableViewCell.superview as? UITableView {
                let rectInTableView = tableView.rectForRow(at: tableViewIndexPath)
                let rectInSuperview = tableView.convert(rectInTableView, to: tableView.superview)
                pop.sourceRect = rectInSuperview
                pop.sourceView = tableView.superview
            }
            
            pop.backgroundColor = .white
            pop.permittedArrowDirections = arrowDirection
            pop.sourceRect = frame
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    func calculateDaysBetweenDates(dateString1: String, dateString2: String, dateFormat: String = "yyyy-MM-dd") -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat // Adjust the date format according to your string format
        
        if let date1 = dateFormatter.date(from: dateString1), let date2 = dateFormatter.date(from: dateString2) {
            let timeInterval = date2.timeIntervalSince(date1)
            let days = Int(timeInterval / 86400)
            return abs(days) // Use abs() to get the absolute value in case the dates are in different orders
        }
        return nil // Return nil if the date conversion fails
    }
    
    //Textfield underline
    func txtFldborder(txtFld: UITextField){
        let border = CALayer()
        let lineHeight : CGFloat = CGFloat(1.0)
        
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: txtFld.frame.size.height - lineHeight, width:  txtFld.frame.size.width, height: txtFld.frame.size.height)
        border.borderWidth = lineHeight
        txtFld.layer.addSublayer(border)
        txtFld.layer.masksToBounds = true
        txtFld.borderStyle = .none
        
    }
    
    func commaSeparatedPrice(val: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedPrice = numberFormatter.string(from: NSNumber(value: val)) ?? ""
        return formattedPrice
    }
    
    func setupGIF(_ gif: String, imgVW: UIImageView) {
        guard let gifURL = Bundle.main.url(forResource: gif, withExtension: "gif") else {
            return
        }
        
        guard let gifData = try? Data(contentsOf: gifURL) else {
            return
        }
        
        guard let source = CGImageSourceCreateWithData(gifData as CFData, nil) else {
            return
        }
        
        let frameCount = CGImageSourceGetCount(source)
        var frames = [UIImage]()
        for index in 0..<frameCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) else {
                continue
            }
            
            let frameImage = UIImage(cgImage: cgImage)
            frames.append(frameImage)
        }
        imgVW.animationImages = frames
        imgVW.animationDuration = 5
        imgVW.animationRepeatCount = 50
        imgVW.startAnimating()
    }
    
    func dateComparision(date1: Date, date2: Date) -> Bool {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        
            let calendar = Calendar.current
            let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
            let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
            
        if let parsedDate1 = calendar.date(from: components1), let parsedDate2 = calendar.date(from: components2) {
            let result = calendar.compare(parsedDate1, to: parsedDate2, toGranularity: .day)
            
            switch result {
            case .orderedSame:
                return true
            case .orderedAscending:
                return false
            case .orderedDescending:
                return false
            }
        }
        return true
    }
}
