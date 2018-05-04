//
//  Login.swift
//  StartUp
//
//  Created by Towhid Islam on 10/27/16.
//  Copyright © 2018 ITSoulLab (https://www.itsoullab.com). All rights reserved.
//

import UIKit
import CoreDataStack

@objcMembers
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

@objcMembers
class ChangePassForm: BaseForm {
    var oldPassword: NSString?
    var password: NSString?
    var reTypePassword: NSString?
}
