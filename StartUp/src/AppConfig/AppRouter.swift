//
//  AppStoryboard.swift
//  StartupProjectSampleA
//
//  Created by Towhid Islam on 7/17/15.
//  Copyright © 2018 ITSoulLab (https://www.itsoullab.com). All rights reserved.
//

import Foundation
import UIKit
import WebServiceKit
import NGAppKit

enum LanguageISOId: String{
    case English = "en"
    case Arabic = "ar"
}

enum LanguageCode: Int{
    case English = 1
    case Arabic = 2
}

enum StoryboardNames: String {
    case Main = "Main"
    case LaunchScreen = "LaunchScreen"
}

class AppRouter: NSObject {
    
    private override init() {
        super.init()
        registerSignoutObserver()
        registerUnauthorizedObserver()
    }
    
    private struct SharedInstance {
        static let router = AppRouter()
    }
    
    class func shared() -> AppRouter{
        return SharedInstance.router
    }
    
    public func start() {
        //print("isRemembered : \(getAccount().credential.isRemembered), isLoggin : \(getAccount().loggedIn)")//
        if getAccount().loggedIn == false {
            LoginRouter().route(from: nil, withInfo: nil)
        }else{
            MegaGridRouter().route(from: nil, withInfo: nil)
        }
    }
    
    deinit{
        print("deinit -> \(NSStringFromClass(type(of: self)))")
    }
    
    private var userAccount = UserManagement(profileType: UserProfile.self)
    public func getAccount() -> UserManagement{
        return userAccount
    }
    
    private var signoutObserver: AnyObject?
    public func registerSignoutObserver() -> Void{
        if signoutObserver == nil{
            signoutObserver = NotificationCenter.default.addObserver(forName: NotificationKeys.UserSignOutNotification, object: nil, queue: OperationQueue.main, using: { (notification: Notification!) -> Void in
                self.userAccount.logout()
                self.start()
            })
        }
    }
    
    private var unauthorizedObserver: AnyObject?
    public func registerUnauthorizedObserver() -> Void{
        if unauthorizedObserver == nil{
            unauthorizedObserver = NotificationCenter.default.addObserver(forName: Response.HttpStatusUnauthorizedAccessNotification, object: nil, queue: OperationQueue.main, using: { (notification: Notification!) -> Void in
                self.userAccount.logout()
                self.start()
            })
        }
    }
    
    final func messageLogger(funcName: String, message: String){
        print("\(NSStringFromClass(type(of: self))) \(funcName) :: \(message)")
    }
    
    func languageID() -> String{
        return Locale.preferredLanguages.first!
    }
    
    final func resolveLanguageCode() -> Int{
        var langCode: Int = 0
        switch(languageID()){
        case LanguageISOId.Arabic.rawValue:
            langCode = LanguageCode.Arabic.rawValue
            break
        case LanguageISOId.English.rawValue:
            langCode = LanguageCode.English.rawValue
            break
        default:
            langCode = LanguageCode.English.rawValue
        }
        return langCode
    }
    
}
