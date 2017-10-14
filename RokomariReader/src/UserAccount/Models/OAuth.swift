//
//  OAuth.swift
//  MymoUpload
//
//  Created by Towhid on 9/9/14.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import CoreDataStack

@objcMembers
class OAuth: NGObject {
    
    let tokenIdentifier: String = "\(Bundle.main.bundleIdentifier!).user_token"
   
    var token: String?{
        get{
            return KeychainWrapper.keychainStringFrom(matchingIdentifier: tokenIdentifier)
        }
        set{
            KeychainWrapper.createKeychainValue(newValue, forIdentifier: tokenIdentifier)
        }
    }
    var secretKey: String?
    
    override func updateValue(_ value: Any!, forKey key: String!) {
        if key == "token"{
            token = value as? String
        }
        else if key == "secretKey"{
            secretKey = value as? String
        }
        else{
            super.updateValue(value, forKey: key)
        }
    }
    
    func removeToken(){
        //just remove token from keyChain
        if let _ = KeychainWrapper.keychainStringFrom(matchingIdentifier: tokenIdentifier){
            KeychainWrapper.deleteItemFromKeychain(withIdentifier: tokenIdentifier)
        }
    }
}
