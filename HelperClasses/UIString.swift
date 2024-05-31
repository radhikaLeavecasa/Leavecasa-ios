//
//  UIString.swift
//  Josh
//
//  Created by Esfera-Macmini on 28/04/22.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    func isValidAadhaar() -> Bool {
        let aadhaarRegex = "^[2-9]{1}[0-9]{3}\\s[0-9]{4}\\s[0-9]{4}$"
        let aadhaarTest = NSPredicate(format: "SELF MATCHES %@", aadhaarRegex)
        return aadhaarTest.evaluate(with: self)
    }
    func isValidDrivingLicenseNumber() -> Bool {
        let drivingLicenseRegex = "^([A-Z]{2})-([0-9]{2})-([0-9]{11})$"
        let drivingLicensePredicate = NSPredicate(format: "SELF MATCHES %@", drivingLicenseRegex)
        
        return drivingLicensePredicate.evaluate(with: self)
    }
    func isValidVoterCardNumber() -> Bool {
        let voterCardRegex = "^[A-Za-z0-9]{10}$"
        let voterCardTest = NSPredicate(format: "SELF MATCHES %@", voterCardRegex)
        return voterCardTest.evaluate(with: self)
    }
    func validateGSTNumber() -> Bool {
        let gstRegex = "^\\d{2}[A-Z]{5}\\d{4}[A-Z]{1}[A-Z\\d]{1}[Z]{1}[A-Z\\d]{1}$"
        let gstTest = NSPredicate(format: "SELF MATCHES %@", gstRegex)
        return gstTest.evaluate(with: self)
    }

    func stringConvertIntoDate() -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func convertStoredDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: self)
        
        if let date = date {
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "HH:mm"
            return newDateFormatter.string(from: date)
        }
        return ""
    }
    func convertStoredDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: self)
        
        if let date = date {
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "dd MMM yyyy"
            return newDateFormatter.string(from: date)
        }
        return ""
    }
    func hotelDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        
        if let date = date {
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "dd MMM"
            return newDateFormatter.string(from: date)
        }
        return ""
    }
    
    func busDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: self)
        
        if let date = date {
            dateFormatter.dateFormat = "dd MMM"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func convertDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: self)
        
        if let date = date {
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "dd MMM | hh:mm a"
            return newDateFormatter.string(from: date)
        }
        return ""
    }
    
    func convertDateWithString(_ format: String = "EEE, dd MMM", oldFormat: String = "yyyy-MM-dd'T'HH:mm:ss.000000Z") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = oldFormat
        let date = dateFormatter.date(from: self)
        
        if let date = date {
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = format
            return newDateFormatter.string(from: date)
        }
        return ""
    }

    func passportDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.string(from: date ?? Date())
    }
    
    func isValidHtmlString() -> Bool {
        if self.isEmpty {
            return false
        }
        return (self.range(of: "<(\"[^\"]*\"|'[^']*'|[^'\">])*>", options: .regularExpression) != nil)
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func isEmptyCheck() -> Bool{
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
extension Int{
    
    func getDuration() -> String {
        let hours = self / 60
        let minutes = (self % 60)
        return "\(hours)h \(minutes)m"
    }
}
