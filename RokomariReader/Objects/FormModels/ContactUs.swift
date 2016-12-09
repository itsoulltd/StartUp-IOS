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

/*{
 "email": "m.towhid.islam@gmail.com", //Required Field
 "message": "Need Some Assistance",
 "name": "Towhid",
 "phone": "01712645571",
 "status": "responded",
 "subject": "Hi there!"
 }*/

public class ContactUs: BaseForm{
    
    var status: NSString = ContactUsStatus.Responded.rawValue
    var phone: NSString?
    var subject: NSString?
    var email: NSString?
    var message: NSString?
    
    override init() {
        super.init()
        addRequiredRule(to: "email")
    }
    
    override init!(info: [NSObject : AnyObject]!) {
        super.init(info: info)
        addRequiredRule(to: "email")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addRequiredRule(to: "email")
    }
    
}
