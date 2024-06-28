//
//  UIViewController.swift
//  Josh
//
//  Created by Esfera-Macmini on 31/03/22.

import UIKit
import SideMenu
import DropDown

extension UIViewController{

    func returnCGSize(collectionView:UICollectionView,indexPath:IndexPath,seatCount:Int, missingSeatIndex: [Int]) -> CGSize {
        
        if seatCount / 2 == 2 {
            if indexPath.row == 1 {
                return CGSize(width: 65, height: 60)
            }else{
                if missingSeatIndex.contains(indexPath.row) {
                    return CGSize(width: 0, height: 60)
                } else {
                    return CGSize(width: (Int(collectionView.frame.width) / Int(5)), height: 60)
                }
            }
        } else if seatCount / 2 == 5 {
            if indexPath.row == 2 || indexPath.row == 6 {
                return CGSize(width: 65, height: 60)
            }else{
                if missingSeatIndex.contains(indexPath.row) {
                    return CGSize(width: 0, height: 60)
                } else {
                    return CGSize(width: 40, height: 60)
                }
            }
        } else if seatCount / 2 == 0 {
            if indexPath.row == 2 {
                return CGSize(width: 90, height: 60)
            }else{
                if missingSeatIndex.contains(indexPath.row) {
                    return CGSize(width: 0, height: 60)
                } else {
                    return CGSize(width: (Int(300) / Int(8)), height: 60)
                }
            }
        } else {
            if indexPath.row == 2 {
                return CGSize(width: 80, height: 60)
            }else{
                if missingSeatIndex.contains(indexPath.row) {
                    return CGSize(width: 0, height: 60)
                } else {
                    return CGSize(width: (Int(300) / Int(7)), height: 60)
                }
            }
        }
    }
    
    func showSideMenu(){
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        let menuLeftNavigationController = ViewControllerHelper.getViewController(ofType: .SideMenuNavigationController, StoryboardName: .Bus) as! SideMenuNavigationController
        SideMenuManager.default.leftMenuNavigationController = menuLeftNavigationController
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        //        SideMenuManager.default.menuFadeStatusBar = false
        menuLeftNavigationController.presentationStyle = .menuSlideIn
        //        SideMenuManager.default.menuPresentMode = .menuSlideIn
        menuLeftNavigationController.menuWidth = self.view.frame.size.width
        present(menuLeftNavigationController, animated: true, completion: nil)
        
    }
    func hideSideMenu(){
        let menuLeftNavigationController = ViewControllerHelper.getViewController(ofType: .SideMenuNavigationController, StoryboardName: .Bus) as! SideMenuNavigationController
        menuLeftNavigationController.menuWidth = 0.0
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    func openGoogleMap(latDouble:Double,longDouble:Double) {
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latDouble),\(longDouble)&zoom=14&views=traffic&q=\(latDouble),\(longDouble)")!, options: [:], completionHandler: nil)
        } else {
            debugPrint("Can't use comgooglemaps://")
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latDouble),\(longDouble)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
        
    }
    
    func checkTime() -> String{
        
        let hour = Calendar.current.component(.hour, from: Date())
        if ((Cookies.userInfo()?.name.rangeOfCharacter(from: CharacterSet.decimalDigits)) == nil) {
            return "Hi \(Cookies.userInfo()?.name ?? "")"
        }else{
            if hour >= 0 && hour < 12 {
                return "Hi, Good Morning"
            } else if hour >= 12 && hour < 17 {
                return "Hi, Good Afternoon"
            } else if hour >= 17 {
                return "Hi, Good Evening"
            } else {
                return ""
            }
        }
    }
    
    func getTimeFilter(time: String) -> Date {
        let time = Int(time) ?? 60
        let hours = time / 60
        let minutes = (time % 60)
        
        var date = Date()
        
        date = date.change(year: 0, month: 0, day: 0, hour: hours, minute: minutes, second: 0)
        return date
    }
    
    func getTimeStringFilter(time: String) -> Bool {
        let time = Int(time) ?? 60
        let hours = time / 60
        let minutes = (time % 60)
        
        var date = Date()
        
        date = date.change(year: 0, month: 0, day: 0, hour: hours, minute: minutes, second: 0)
        return false
    }
    
    func convertToNextDate(date:String,value: Int) -> (dateString:String,date:Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM dd, yyyy"
        let myDate = dateFormatter.date(from: date) ?? Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: value, to: myDate)
        return (dateFormatter.string(from: tomorrow!),myDate)
    }
    
    func setCheckInDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
    
    func setJournyDate(formate:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        return dateFormatter.string(from: Date())
    }
    
    func setStartDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func getCancellationDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "dd MMM, yyyy hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    func convertTraveDate(date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: date)
    }
    func convertDateFormat(date: String, getFormat:String, dateFormat: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = getFormat
        return dateFormatter.string(from: date)
    }
    func addDate(fromDate: String, daysToAdd:Int) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Set date format
        
        if let inputDate = dateFormatter.date(from: fromDate) { // Specify the specific date
            let calendar = Calendar.current
            if let newDate = calendar.date(byAdding: .day, value: daysToAdd, to: inputDate) {
                let newDateString = dateFormatter.string(from: newDate)
                return newDateString
            }
        }
        return ""
    }
    
    func getTimeString(time: String) -> String {
        let time = Int(time) ?? 60
        let hours = time / 60
        let minutes = (time % 60)
        
        var date = Date()
        
        date = date.change(year: 0, month: 0, day: 0, hour: hours, minute: minutes, second: 0)
        return convertDate(date, format: "hh:mm a")
    }
    
    func updateHeight(tableView:UITableView) {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    func convertDate(_ date: Date, format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func setCheckOutDate() -> String {
        let today = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: today)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: nextDate ?? Date())
    }
    
    func changeCurrentDateIntoNextDate(date:Date) -> Date{
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
        return nextDate ?? Date()
    }
    
    func convertDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func returnDate(_ date: String, strFormat: String = "HH:mm a") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        return dateFormatter.date(from: date)!
    }
    
    func convertDateWithDateFormater(_ formate:String,_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        return dateFormatter.string(from: date)
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i",minutes, seconds)
    }
    
    func nextCheckOutDate( _ format: String,_ date: Date) -> String {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: nextDate ?? Date())
    }
    
    func convertStoredDate(_ dateString: String, _ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        
        if let date = date {
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = format
            return newDateFormatter.string(from: date)
        }
        return ""
    }
    
    func getDuration(minutes: Int) -> String {
        let hours = minutes / 60
        let minutes = (minutes % 60)
        
        let hoursString = hours < 10 ? "0\(hours)" : "\(hours)"
        let minuteString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        
        return "\(hoursString)h \(minuteString)m"
    }
    
    func popView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func pushView(vc:UIViewController, title: String = "", animated: Bool = true){
        DispatchQueue.main.async {
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func pushNoInterConnection(view:UIViewController, image: String = "ic_no_internet", titleMsg: String = "No Internet Connection", msg: String = "Please retry internet connection not available",completion: (() -> Void)? = nil) {
        if let vc = ViewControllerHelper.getViewController(ofType: .NoInternetVC, StoryboardName: .Main) as? NoInternetVC {
            vc.image = image
            vc.msg = msg
            vc.msgTitle = titleMsg
            vc.noInternetDelegate = {
                completion?()
            }
           
            self.present(vc,animated: true)
        }
    }
    
    func refreshController(tableView:UITableView,refreshControl:UIRefreshControl,selector:Selector) {
        refreshControl.addTarget(self, action: selector, for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    func setView(vc: UIViewController, animation: Bool = true){
        DispatchQueue.main.async {
            self.navigationController?.setViewControllers([vc], animated: animation)
        }
    }
    
    func dismiss(){
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func unauthorisedUser(){
        //        let vc = ViewControllerHelper.getViewController(ofType: .TutorialVC, StoryboardName: .Main) as! TutorialVC
        //        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
    func onfail(msg:String){
        DispatchQueue.main.async {
            if msg == CommonError.UNAUTHORIESED || msg == CommonError.INVALID_TOKEN || msg == CommonError.EXPIRED{
                Alert.showSimple(msg){
                }
            }else{
                Alert.showSimple(msg)
            }
        }
    }
    
    func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }
        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            ctx.cgContext.drawPDFPage(page)
        }
        
        return img
    }
    
    func isProfileComplete() -> Bool{
        if Cookies.userInfo()?.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            return false
        }else if Cookies.userInfo()?.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            return false
        }else if Cookies.userInfo()?.mobile.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            return false
        }else if Cookies.userInfo()?.marital_status.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            return false
        }else if Cookies.userInfo()?.city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            return false
        }else if Cookies.userInfo()?.nationality.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            return false
        }else if Cookies.userInfo()?.gender.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            return false
        }else{
            return true
        }
    }
    func showShortDropDown(textFeild:UITextField,data:[String],dropDown: DropDown, completion: @escaping(String,Int)->()) {
        DispatchQueue.main.async {
            textFeild.resignFirstResponder()
            
            dropDown.anchorView = textFeild.plainView
            dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
            
            dropDown.dataSource = data
            dropDown.separatorColor = .gray
            dropDown.selectionAction = { (index: Int, item: String) in
                completion(item, index)
            }
            dropDown.show()
        }
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        )
        let locationOfTouchInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - textContainerOffset.x,
            y: locationOfTouchInLabel.y - textContainerOffset.y
        )
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension Date{
    
    func convertStoredDate() -> String {
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "yyyy-MM-dd"
        return newDateFormatter.string(from: self)
    }
    
    func isBetween(_ startDate: Date, and endDate: Date) -> Bool {
        return startDate <= self && self <= endDate
    }
}

extension Collection where Iterator.Element == [String:AnyObject] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String:AnyObject]],
           let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
           let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            debugPrint("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}
