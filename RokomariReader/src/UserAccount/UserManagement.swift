//
//  UserAccountManager.swift
//  MymoUpload
//
//  Created by Towhid on 9/9/14.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import Foundation
import SeliseToolKit

class UserManagement: NSObject {
    
    var profile: DNObjectProtocol?{
        get{
            guard let data = NSUserDefaults.standardUserDefaults().dataForKey("userProfileKey") else{
                return nil
            }
            let unarchived = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String:AnyObject]
            let inferred = self.profileType.init()
            inferred.updateWithInfo(unarchived)
            return inferred
        }
        set{
            let infos: [String:AnyObject] = newValue?.serializeIntoInfo() as! [String:AnyObject]
            let archived = NSKeyedArchiver.archivedDataWithRootObject(infos)
            NSUserDefaults.standardUserDefaults().setObject(archived, forKey: "userProfileKey")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func deleteProfile(){
        if self.profile != nil {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userProfileKey")
        }
    }
    
    func updateProfile(value: AnyObject, forKey key: String, synch: Bool = false){
        guard let xProfile = profile else{
            return
        }
        xProfile.updateValue(value, forKey: key)
        if synch {
            let infos: [String:AnyObject] = xProfile.serializeIntoInfo() as! [String:AnyObject]
            let archived = NSKeyedArchiver.archivedDataWithRootObject(infos)
            NSUserDefaults.standardUserDefaults().setObject(archived, forKey: "userProfileKey")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    private var profileType: DNObject.Type = DNObject.self
    var oauth: OAuth = OAuth()
    var credential: Credential = Credential()
    
    var loggedIn: Bool = false
    
    var token: String? {
        return oauth.token
    }
    
    override init() {
        super.init()
        if (oauth.token != nil && credential.password != nil){
            loggedIn = true
        }else{
            loggedIn = false
        }
    }
    
    convenience init(profileType: DNObject.Type) {
        self.init()
        self.profileType = profileType
    }
    
    func logout(passwordOnly:Bool = false){
        loggedIn = false
        oauth.removeToken()
        credential.removeCredential(passwordOnly)
        deleteProfile()
    }
    
    func loginWithToken(token: String, email: String, password: String, remembered: Bool = false) -> Bool{
        oauth.token = token
        credential.updateWithInfo(["email":email,"password":password])
        credential.isRemembered = remembered
        loggedIn = true
        return loggedIn
    }
}
