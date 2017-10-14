//
//  AppStoryboard.swift
//  StartupProjectSampleA
//
//  Created by Towhid Islam on 7/17/15.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import UIKit
import WebServiceKit

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
    
    final func storyboard(name: StoryboardNames) -> UIStoryboard{
        guard let hasBoard = storyboards[name.rawValue] as? UIStoryboard else{
            let info = AppInfo()
            if name == .Main {
                let main = info.mainStoryboard()
                if main != nil{
                    storyboards[name.rawValue] = main
                }
                return main!
            }else{
                let board = info.mainStoryboard(name.rawValue)
                if board != nil{
                    storyboards[name.rawValue] = board
                }
                return board!
            }
        }
        return hasBoard
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
    
    final func resolveLanguageCode() -> Int{
        var langCode: Int = 0
        switch(AppInfo().languageID()){
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
    
    final func resolveClassName(type: AnyClass) -> String{
        let fullClassName: NSString = NSStringFromClass(type.self) as NSString
        let moduleName = AppInfo().stringValue(forKey: AppInfo.ConstentKeys.BundleNameKey)!
        let moduleWithSeparetor = NSString(format: "%@.", moduleName)
        let className = fullClassName.replacingOccurrences(of: moduleWithSeparetor as String, with: "")
        return className
    }
    
    final func resolveStoryboardID(type: AnyClass) -> String{
        let storyboardID = resolveClassName(type: type)
        return storyboardID
    }
    
    final func initialViewController(_ boardName: StoryboardNames = .Main) -> UIViewController{
        let selectedStoryboard = storyboard(name: boardName)
        let initial = selectedStoryboard.instantiateInitialViewController() as UIViewController!
        return initial!
    }
    
    final func resolveViewController(fromType type: AnyClass, boardName: StoryboardNames = .Main) -> UIViewController{
        let storyboardID = resolveStoryboardID(type: type)
        return resolveViewController(fromStoryboardId: storyboardID, boardName: boardName)
    }
    
    final func resolveViewController(fromStoryboardId storyboardID: String, boardName: StoryboardNames = .Main) -> UIViewController{
        let viewController = storyboard(name: boardName).instantiateViewController(withIdentifier: storyboardID) as UIViewController!
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
    
    final func replaceNavigationStackLast(_ viewController: UIViewController, animated: Bool = true){
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        var navStack: [UIViewController]?
        var navController: UINavigationController?
        if let activeViewController = appDelegate.window?.rootViewController{
            if activeViewController is UINavigationController{
                navController = (activeViewController as! UINavigationController)
                navStack = navController?.viewControllers
            }
            else if activeViewController is UITabBarController{
                if let visibleController = (activeViewController as! UITabBarController).selectedViewController as? UINavigationController{
                    navController = visibleController
                    navStack = visibleController.viewControllers
                }
            }
        }
        if let navStack = navStack{
            let newSet = NSMutableArray(capacity: navStack.count)
            for viewController in navStack as [UIViewController]{
                newSet.add(viewController)
                print("Retain In PushStack :: \(viewController.description)")
            }
            newSet.removeLastObject()
            newSet.add(viewController)
            navController?.setViewControllers(newSet.objectEnumerator().allObjects as! [UIViewController], animated: animated)
        }
    }
    
    final func showViewController(_ viewController: UIViewController, sender: AnyObject?){
        if let activeViewController = visibleViewController(){
            if #available(iOS 8.0, *){
                activeViewController.show(viewController, sender: sender)
            }
            else{
                if let nav = activeViewController.navigationController{
                    nav.pushViewController(viewController, animated: true)
                }else{
                    activeViewController.modalPresentationStyle = UIModalPresentationStyle.currentContext
                    activeViewController.present(viewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    final func showModalViewController(_ viewController: UIViewController, sender: AnyObject?){
        if let activeViewController = visibleViewController(){
            activeViewController.modalPresentationStyle = UIModalPresentationStyle.currentContext
            activeViewController.present(viewController, animated: true, completion: nil)
        }
    }
    
    final func visibleViewController() -> UIViewController?{
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        if let activeViewController = appDelegate.window?.rootViewController{
            if activeViewController is UINavigationController{
                if let visibleViewController = (activeViewController as! UINavigationController).visibleViewController{
                    return visibleViewController
                }
            }
            else if activeViewController is UITabBarController{
                if let visibleViewController = (activeViewController as! UITabBarController).selectedViewController{
                    return visibleViewController
                }
            }
            else{
                return activeViewController
            }
        }
        return nil
    }
    
}
