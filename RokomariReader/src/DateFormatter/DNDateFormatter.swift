//
//  DateFormatterStore.swift
//  MymoUpload
//
//  Created by Towhid on 11/11/14.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit

class DNDateFormatter: NSObject {
    
    fileprivate struct SharedVariables{
        static var calender = Calendar.current
        static var formatter = Foundation.DateFormatter()
    }
    
    var formatter: Foundation.DateFormatter = SharedVariables.formatter
    
    func defaultDateFormatter() -> Foundation.DateFormatter{
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss a"
        return formatter
    }
    
    func fullDateFormatter() -> Foundation.DateFormatter{
        formatter.dateStyle = Foundation.DateFormatter.Style.full
        formatter.timeStyle = Foundation.DateFormatter.Style.full
        return formatter
    }
    
    func mediumDateFormatter() -> Foundation.DateFormatter{
        formatter.dateStyle = Foundation.DateFormatter.Style.medium
        formatter.timeStyle = Foundation.DateFormatter.Style.medium
        return formatter
    }
    
    func shortDateFormatter() -> Foundation.DateFormatter{
        formatter.dateStyle = Foundation.DateFormatter.Style.short
        formatter.timeStyle = Foundation.DateFormatter.Style.short
        return formatter
    }
    
    func ISO8601DateFormatter() -> Foundation.DateFormatter{
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }
    
    func ISO8601DateOnlyFormatter() -> Foundation.DateFormatter{
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    func tomorrow() -> Date?{
        let tomorrow = day(after: 1)
        return tomorrow
    }
    
    func day(after day: Int = 0) -> Date?{
        var component = DateComponents()
        component.day = day
        let calc = SharedVariables.calender
        let tomorrow = (calc as NSCalendar).date(byAdding: component, to: Date(), options: NSCalendar.Options())
        return tomorrow
    }
    
    func date(addingHours hours: Int = 0) -> Date?{
        var component = DateComponents()
        component.hour = hours
        let calc = SharedVariables.calender
        let tomorrow = (calc as NSCalendar).date(byAdding: component, to: Date(), options: NSCalendar.Options())
        return tomorrow
    }
    
}

