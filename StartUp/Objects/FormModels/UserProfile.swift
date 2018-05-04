//
//  UserProfile.swift
//  MymoUpload
//
//  Created by Towhid on 9/9/14.
//  Copyright © 2018 ITSoulLab (https://www.itsoullab.com). All rights reserved.
//

import UIKit
import CoreDataStack

@objcMembers
class UserProfile: BaseForm {
    var userName: NSString?
    var firstName: NSString?
    var lastName: NSString?
    var email: NSString?
    var name: String {
        guard let fn = firstName,
        let ln = lastName else {
            return ""
        }
        return "\(fn) \(ln)"
    }
    var age: NSNumber?
    var dob: Date?
    var profileImagePath: URL?
    var thumbNailPath: URL?
    
    override func updateValue(_ value: Any!, forKey key: String!) {
        
        if key == "firstName"{
            firstName = value as? String as NSString?
        }
        else if key == "lastName"{
            lastName = value as? String as NSString?
        }
        else if key == "age"{
            
            if let val = value as? String{
                age = Int(val) as NSNumber?
            }
            else{
                age = value as? Int as NSNumber?
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
    
    override func updateDate(_ dateStr: String!) -> Date! {
        
        let formatter: Foundation.DateFormatter = Foundation.DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.date(from: dateStr)
    }
    
    override func serializeDate(_ date: Date!) -> String! {
        
        let formatter: Foundation.DateFormatter = Foundation.DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
}
