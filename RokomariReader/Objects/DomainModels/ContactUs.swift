//
//  ContactUs.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/3/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import SeliseToolKit

public enum ContactUsStatus: NSString{
    case Invalid = "invalid"
    case NotResponded = "not_responded"
    case Responded = "responded"
}

public class ContactUs: Response{
    var createdDate: NSString?
    var lastModifiedBy: NSString?
    var lastModifiedDate: NSString?
    var status: ContactUsStatus = .Invalid
    var phone: NSString?
    var subject: NSString?
    var email: NSString?
    
    public override func updateValue(value: AnyObject!, forKey key: String!) {
        if key == "status" {
            if let val = value as? NSString  {
                self.status = ContactUsStatus(rawValue: val)!
            }
        }else{
            super.updateValue(value, forKey: key)
        }
    }
    
}