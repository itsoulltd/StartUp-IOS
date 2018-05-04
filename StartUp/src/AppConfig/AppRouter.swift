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
        print("isRemembered : \(getAccount().credential.isRemembered), isLoggin : \(getAccount().loggedIn)")//
        if getAccount().loggedIn == false {
            let rootViewController = resolveViewController(fromType: LoginTVC.self)
            let nav = UINavigationController(rootViewController: rootViewController)
            replaceRootViewController(nav)
        }else{
            let rootViewController = resolveViewController(fromType: MegaGridTvc.self)
            let nav = UINavigationController(rootViewController: rootViewController)
            replaceRootViewController(nav)
        }
    }
    
    public func show(fromType type: AnyClass, boardName: StoryboardNames = .Main) {
        let viewController = resolveViewController(fromType: type, boardName: boardName)
        showViewController(viewController, sender: nil)
    }
    
    public func show(fromStoryboardId stid: String, boardName: StoryboardNames = .Main) {
        let viewController = resolveViewController(fromStoryboardId: stid, boardName: boardName)
        showViewController(viewController, sender: nil)
    }
    
    private var mainStoryboard: UIStoryboard!
    private var storyboards: [String: UIStoryboard?] = [String: UIStoryboard?]()
    
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
        return Locale.preferredLanguages.first as String!
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
    
    final func resolveStoryboardID(type: AnyClass) -> String{
        let storyboardID = AppStoryboard.resolveClassName(type)!
        return storyboardID
    }
    
    final func initialViewController(_ boardName: StoryboardNames = .Main) -> UIViewController{
        let story = AppStoryboard.load(boardName.rawValue)
        return (story?.initialViewController())!
    }
    
    final func resolveViewController(fromType type: AnyClass, boardName: StoryboardNames = .Main) -> UIViewController{
        let storyboardID = resolveStoryboardID(type: type)
        return resolveViewController(fromStoryboardId: storyboardID, boardName: boardName)
    }
    
    final func resolveViewController(fromStoryboardId storyboardID: String, boardName: StoryboardNames = .Main) -> UIViewController{
        let story = AppStoryboard.load(boardName.rawValue)
        let viewController = story?.viewController(byStoryboardID: storyboardID)
        return viewController!
    }
    
    final func replaceRootViewController(_ viewController: UIViewController){
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = viewController
    }
    
    final func replaceNavigationStack(_ controllers:[UIViewController], animated: Bool = true){
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        if let activeViewController = appDelegate.window?.rootViewController{
            if activeViewController is UINavigationController{
                (activeViewController as! UINavigationController).setViewControllers(controllers, animated: animated)
            }
            else if activeViewController is UITabBarController{
                if let visibleController = (activeViewController as! UITabBarController).selectedViewController as? UINavigationController{
                    visibleController.setViewControllers(controllers, animated: animated)
                }
            }
        }
    }
    
    final func showViewController(_ viewController: UIViewController, sender: AnyObject?){
        AppStoryboard.show(viewController, sender: sender)
    }
    
    final func showModalViewController(_ viewController: UIViewController, sender: AnyObject?){
        AppStoryboard.show(viewController, sender: sender)
    }
    
    final func visibleViewController() -> UIViewController?{
        return AppStoryboard.visibleViewController()
    }
    
}
