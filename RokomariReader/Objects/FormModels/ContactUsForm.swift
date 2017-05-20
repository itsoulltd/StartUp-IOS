//
//  ContactUs.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/3/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import CoreDataStack

public enum ContactUsStatus: NSString{
    case invalid = "invalid"
    case notResponded = "not_responded"
    case responded = "responded"
}

/*{
 "email": "m.towhid.islam@gmail.com", //Required Field
 "message": "Need Some Assistance",
 "name": "Towhid",
 "phone": "01712645571",
 "status": "responded",
 "subject": "Hi there!"
 }*/

open class ContactUsForm: BaseForm{
    
    var status: NSString = ContactUsStatus.responded.rawValue
    var phone: NSString?
    var subject: NSString?
    var email: NSString?
    var message: NSString?
    
    override init() {
        super.init()
        addRequiredRule(to: "email")
    }
    
    override init!(info: [AnyHashable: Any]!) {
        super.init(info: info)
        addRequiredRule(to: "email")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addRequiredRule(to: "email")
    }
    
}
