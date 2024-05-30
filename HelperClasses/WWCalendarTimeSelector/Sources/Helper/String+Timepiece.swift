//
//  String+Timepiece.swift
//  Timepiece
//
//  Created by Naoto Kaneko on 2015/03/01.
//  Copyright (c) 2015年 Naoto Kaneko. All rights reserved.
//

import Foundation

extension String {
    func dateFromFormat(_ format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.calendar = Calendar.autoupdatingCurrent
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    func convertCheckinDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.yearMonthDate
        let date = dateFormatter.date(from: self)
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = DateFormat.fullDate
        return newDateFormatter.string(from: date ?? Date())
    }
    func getSymbolForCurrencyCode() -> String?{
        let locale = NSLocale(localeIdentifier: self)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: self)
    }
    func containsNumbers() -> Bool {
        let regex = try! NSRegularExpression(pattern: "\\d")
        let range = NSRange(location: 0, length: self.utf16.count)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
}
