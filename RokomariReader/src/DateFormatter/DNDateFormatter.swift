//
//  DateFormatterStore.swift
//  MymoUpload
//
//  Created by Towhid on 11/11/14.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit

class DNDateFormatter: NSObject {
    
    private struct SharedVariables{
        static var calender = NSCalendar.currentCalendar()
        static var formatter = NSDateFormatter()
    }
    
    var formatter: NSDateFormatter = SharedVariables.formatter
    
    func defaultDateFormatter() -> NSDateFormatter{
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss a"
        return formatter
    }
    
    func fullDateFormatter() -> NSDateFormatter{
        formatter.dateStyle = NSDateFormatterStyle.FullStyle
        formatter.timeStyle = NSDateFormatterStyle.FullStyle
        return formatter
    }
    
    func mediumDateFormatter() -> NSDateFormatter{
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateFormatterStyle.MediumStyle
        return formatter
    }
    
    func shortDateFormatter() -> NSDateFormatter{
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return formatter
    }
    
    func ISO8601DateFormatter() -> NSDateFormatter{
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }
    
    func ISO8601DateOnlyFormatter() -> NSDateFormatter{
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    func tomorrow() -> NSDate?{
        let tomorrow = day(after: 1)
        return tomorrow
    }
    
    func day(after day: Int = 0) -> NSDate?{
        let component = NSDateComponents()
        component.day = day
        let calc = SharedVariables.calender
        let tomorrow = calc.dateByAddingComponents(component, toDate: NSDate(), options: NSCalendarOptions())
        return tomorrow
    }
    
    func date(addingHours hours: Int = 0) -> NSDate?{
        let component = NSDateComponents()
        component.hour = hours
        let calc = SharedVariables.calender
        let tomorrow = calc.dateByAddingComponents(component, toDate: NSDate(), options: NSCalendarOptions())
        return tomorrow
    }
    
}

