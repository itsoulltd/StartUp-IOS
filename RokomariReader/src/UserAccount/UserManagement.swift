//
//  UserAccountManager.swift
//  MymoUpload
//
//  Created by Towhid on 9/9/14.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import Foundation
import CoreDataStack

class UserManagement: NSObject {
    
    var profile: NGObjectProtocol?{
        get{
            guard let data = UserDefaults.standard.data(forKey: "userProfileKey") else{
                return nil
            }
            let unarchived = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:AnyObject]
            let inferred = self.profileType.init()
            inferred.update(withInfo: unarchived)
            return inferred
        }
        set{
            let infos: [String:AnyObject] = newValue?.serializeIntoInfo() as! [String:AnyObject]
            let archived = NSKeyedArchiver.archivedData(withRootObject: infos)
            UserDefaults.standard.set(archived, forKey: "userProfileKey")
            UserDefaults.standard.synchronize()
        }
    }
    
    func deleteProfile(){
        if self.profile != nil {
            UserDefaults.standard.removeObject(forKey: "userProfileKey")
        }
    }
    
    func updateProfile(_ value: AnyObject, forKey key: String, synch: Bool = false){
        guard let xProfile = profile else{
            return
        }
        xProfile.updateValue(value, forKey: key)
        if synch {
            let infos: [String:AnyObject] = xProfile.serializeIntoInfo() as! [String:AnyObject]
            let archived = NSKeyedArchiver.archivedData(withRootObject: infos)
            UserDefaults.standard.set(archived, forKey: "userProfileKey")
            UserDefaults.standard.synchronize()
        }
    }
    
    fileprivate var profileType: NGObject.Type = NGObject.self
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
    
    convenience init(profileType: NGObject.Type) {
        self.init()
        self.profileType = profileType
    }
    
    func logout(_ passwordOnly:Bool = false){
        loggedIn = false
        oauth.removeToken()
        credential.removeCredential(passwordOnly)
        deleteProfile()
    }
    
    func loginWithToken(_ token: String, email: String, password: String, remembered: Bool = false) -> Bool{
        oauth.token = token
        credential.update(withInfo: ["email":email,"password":password])
        credential.isRemembered = remembered
        loggedIn = true
        return loggedIn
    }
}
