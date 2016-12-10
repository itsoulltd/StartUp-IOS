//
//  Login.swift
//  RokomariReader
//
//  Created by Towhid Islam on 10/27/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

class LoginForm: BaseForm {
    var password: NSString?
    var username: NSString?
    var rememberMe: NSNumber = false
    
    override func serializeValue(value: AnyObject!, forKey key: String!) -> AnyObject! {
        if key == "rememberMe" {
            return rememberMe.boolValue ? "true" : "false"
        }else{
            return super.serializeValue(value, forKey: key)
        }
    }
}
