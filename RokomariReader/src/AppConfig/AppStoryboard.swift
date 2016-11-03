//
//  AppStoryboard.swift
//  StartupProjectSampleA
//
//  Created by Towhid Islam on 7/17/15.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import UIKit

enum LanguageISOId: String{
    case English = "en"
    case Arabic = "ar"
}

enum LanguageCode: Int{
    case English = 1
    case Arabic = 2
}

class AppStoryboard: NSObject {
    
    override init() {
        super.init()
    }
    
    convenience init(storyboard name: String) {
        self.init()
        storyboard(name)
    }
    
    private var mainStoryboard: UIStoryboard!
    
    deinit{
        print("deinit -> \(NSStringFromClass(self.dynamicType))")
    }
    
    final func messageLogger(funcName: String, message: String){
        print("\(NSStringFromClass(self.dynamicType)) \(funcName) :: \(message)")
    }
    
    final func resolveLanguageCode() -> Int{
        //
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
        let fullClassName: NSString = NSStringFromClass(type.self)
        let moduleName = AppInfo().stringValue(forKey: AppInfo.ConstentKeys.BundleNameKey)!
        let moduleWithSeparetor = NSString(format: "%@.", moduleName)
        let className = fullClassName.stringByReplacingOccurrencesOfString(moduleWithSeparetor as String, withString: "")
        return className
    }
    
    final func resolveStoryboardID(type: AnyClass) -> String{
        let storyboardID = resolveClassName(type)
        return storyboardID
    }
    
    final func initialViewController() -> UIViewController{
        let selectedStoryboard = storyboard()!
        let initial = selectedStoryboard.instantiateInitialViewController() as UIViewController!
        return initial
    }
    
    final func resolveViewController(fromType type: AnyClass) -> UIViewController{
        let storyboardID = resolveStoryboardID(type)
        let viewController = storyboard()?.instantiateViewControllerWithIdentifier(storyboardID) as UIViewController!
        return viewController
    }
    
    final func replaceRootViewController(viewController: UIViewController){
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        appDelegate.window?.rootViewController = viewController
    }
    
    final func replaceNavigationStack(controllers:[UIViewController], animated: Bool = true){
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
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
    
    final func replaceNavigationStackLast(viewController: UIViewController, animated: Bool = true){
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
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
                newSet.addObject(viewController)
                print("Retain In PushStack :: \(viewController.description)")
            }
            newSet.removeLastObject()
            newSet.addObject(viewController)
            navController?.setViewControllers(newSet.objectEnumerator().allObjects as! [UIViewController], animated: animated)
        }
    }
    
    final func showViewController(viewController: UIViewController, sender: AnyObject?){
        if let activeViewController = visibleViewController(){
            if #available(iOS 8.0, *){
                activeViewController.showViewController(viewController, sender: sender)
            }
            else{
                if let nav = activeViewController.navigationController{
                    nav.pushViewController(viewController, animated: true)
                }else{
                    activeViewController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
                    activeViewController.presentViewController(viewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    final func showModalViewController(viewController: UIViewController, sender: AnyObject?){
        if let activeViewController = visibleViewController(){
            activeViewController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            activeViewController.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    final func visibleViewController() -> UIViewController?{
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        if let activeViewController = appDelegate.window?.rootViewController{
            if activeViewController is UINavigationController{
                if let visibleViewController = (activeViewController as! UINavigationController).visibleViewController{
                    return visibleViewController
                }
            }
            if activeViewController is UITabBarController{
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
    
    final func storyboard(name: String? = nil) -> UIStoryboard?{
        if mainStoryboard == nil{
            let info = AppInfo()
            if let name = name{
                self.mainStoryboard = info.mainStoryboard(name)
            }
            else{
                self.mainStoryboard = info.mainStoryboard()
            }
        }
        return mainStoryboard
    }
    
}