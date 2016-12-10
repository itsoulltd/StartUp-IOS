//
//  UserProfile.swift
//  MymoUpload
//
//  Created by Towhid on 9/9/14.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

class UserProfile: BaseForm {
    var userName: NSString?
    var firstName: NSString?
    var lastName: NSString?
    var name: String {
        return "\(firstName) \(lastName)"
    }
    var age: NSNumber?
    var dob: NSDate?
    var profileImagePath: NSURL?
    var thumbNailPath: NSURL?
    
    override func updateValue(value: AnyObject!, forKey key: String!) {
        
        if key == "firstName"{
            firstName = value as? String
        }
        else if key == "lastName"{
            lastName = value as? String
        }
        else if key == "age"{
            
            if let val = value as? String{
                age = Int(val)
            }
            else{
                age = value as? Int
            }
        }
        else if key == "dob"{
            if let dobStr = value as? String{
                dob = updateDate(dobStr)
            }
        }
        else{
            super.updateValue(value, forKey: key)
        }
    }
    
    override func updateDate(dateStr: String!) -> NSDate! {
        
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.dateFromString(dateStr)
    }
    
    override func serializeDate(date: NSDate!) -> String! {
        
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.stringFromDate(date)
    }
}
