//
//  ContactUs.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/3/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import WebServiceKit

@objcMembers
open class ContactUs: Response{
    var createdDate: NSString?
    var lastModifiedBy: NSString?
    var lastModifiedDate: NSString?
    var status: ContactUsStatus = .invalid
    var phone: NSString?
    var subject: NSString?
    var email: NSString?
    
    open override func updateValue(_ value: Any!, forKey key: String!) {
        if key == "status" {
            if let val = value as? NSString  {
                self.status = ContactUsStatus(rawValue: val)!
            }
        }else{
            super.updateValue(value, forKey: key)
        }
    }
    
}
