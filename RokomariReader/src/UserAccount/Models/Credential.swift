//
//  Credential.swift
//  MymoUpload
//
//  Created by Towhid on 9/9/14.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

class Credential: DNObject {
    
    let emailIdentifier: String = "\(NSBundle.mainBundle().bundleIdentifier!).user_email"
    let passwordIdentifier: String = "\(NSBundle.mainBundle().bundleIdentifier!).user_password"
    let rememberIdentifier: String = "\(NSBundle.mainBundle().bundleIdentifier!).user_remember"
    
    var isRemembered: Bool{
        get{
            let valueInString = KeychainWrapper.keychainStringFromMatchingIdentifier(rememberIdentifier)
            return (valueInString == nil) ? false : valueInString == "true"
        }
        set{
            let valueInString = (newValue == true) ? "true" : "false"
            KeychainWrapper.createKeychainValue(valueInString, forIdentifier: rememberIdentifier)
        }
    }
   
    var email: String?{
        get{
            return KeychainWrapper.keychainStringFromMatchingIdentifier(emailIdentifier)
        }
        set{
            KeychainWrapper.createKeychainValue(newValue, forIdentifier: emailIdentifier)
        }
    }
    
    var password: String?{
        get{
            return KeychainWrapper.keychainStringFromMatchingIdentifier(passwordIdentifier)
        }
        set{
            KeychainWrapper.createKeychainValue(newValue, forIdentifier: passwordIdentifier)
        }
    }
    
    override func updateValue(value: AnyObject!, forKey key: String!) {
        if key == "email" {
            email = value as? String
        }
        else if key == "password" {
            password = value as? String
        }
        else{
            super.updateValue(value, forKey: key)
        }
    }
    
    func removeCredential(passwordOnly:Bool){
        //if not true then remove only password
        //else remove both
        if passwordOnly != true{
            if let _ = KeychainWrapper.keychainStringFromMatchingIdentifier(emailIdentifier){
                KeychainWrapper.deleteItemFromKeychainWithIdentifier(emailIdentifier)
            }
        }
        if let _ = KeychainWrapper.keychainStringFromMatchingIdentifier(passwordIdentifier){
            KeychainWrapper.deleteItemFromKeychainWithIdentifier(passwordIdentifier)
        }
        if let _ = KeychainWrapper.keychainStringFromMatchingIdentifier(rememberIdentifier){
            KeychainWrapper.deleteItemFromKeychainWithIdentifier(rememberIdentifier)
        }
    }
}
