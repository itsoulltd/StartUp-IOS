//
//  Login.swift
//  RokomariReader
//
//  Created by Towhid Islam on 10/27/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import CoreDataStack

class LoginForm: BaseForm {
    var password: NSString?
    var username: NSString?
    var rememberMe: NSNumber = true
    
    override func serializeValue(_ value: Any!, forKey key: String!) -> Any! {
        if key == "rememberMe" {
            return rememberMe.boolValue ? "true" : "false" as AnyObject!
        }else{
            return super.serializeValue(value, forKey: key) as AnyObject!
        }
    }
}

class ChangePassForm: BaseForm {
    var oldPassword: NSString?
    var password: NSString?
    var reTypePassword: NSString?
}
