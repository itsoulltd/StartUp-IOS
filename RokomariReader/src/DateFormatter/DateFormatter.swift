//
//  DateFormatter.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 8/16/15.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation

class DateFormatter: DNDateFormatter {
    
    static let yearSuffix = NSLocalizedString("Years", comment: "")
    static let monthSuffix = NSLocalizedString("Months", comment: "")
    static let weeksSuffix = NSLocalizedString("Weeks", comment: "")
    static let daysSuffix = NSLocalizedString("Days", comment: "")
    static let todaySuffix = NSLocalizedString("Today", comment: "")
    static let yesterdaySuffix = NSLocalizedString("Yesterday", comment: "")
    static let tomorrowSuffix = NSLocalizedString("Tomorrow", comment: "")
    
    func relativeDateString(forDate date: NSDate) -> String{
        let units: NSCalendarUnit = [NSCalendarUnit.Day, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Month, NSCalendarUnit.Year]
        let components = NSCalendar.currentCalendar().components(units, fromDate: date, toDate: NSDate(), options: NSCalendarOptions.MatchFirst)
        let years = abs(components.year)
        let months = abs(components.month)
        let weeks = abs(components.weekOfYear)
        let days = abs(components.day)
        if years > 0{
            return "\(years) " + DateFormatter.yearSuffix
        }
        else if months > 0{
            return "\(months) " + DateFormatter.monthSuffix
        }
        else if weeks > 0{
            return "\(weeks) " + DateFormatter.weeksSuffix
        }
        else if days > 0{
            if days > 1{
                return "\(days) " + DateFormatter.daysSuffix
            }
            else{
                return (components.day < 0) ? DateFormatter.tomorrowSuffix : DateFormatter.yesterdaySuffix
            }
        }
        else{
            return DateFormatter.todaySuffix
        }
    }
    
    func serverSideDateFormatter() -> NSDateFormatter{
        //yyyy-MM-dd'T'HH:mm:ssZ OR yyyy-MM-dd'T'HH:mm:ss.sssz OR yyyy-MM-dd'T'HH:mm:ss.sssZ
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sss'Z'"
        formatter.timeZone = NSTimeZone(name: "UTC")
        //fr_CH en_US
        //println("Local Identifier \(NSLocale.currentLocale().localeIdentifier)")//
        formatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        return formatter
    }
    
}