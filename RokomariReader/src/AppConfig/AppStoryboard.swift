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
    case english = 1
    case arabic = 2
}

class AppStoryboard: NSObject {
    
    override init() {
        super.init()
    }
    
    convenience init(storyboard name: String) {
        self.init()
        let _ = storyboard(name)
    }
    
    fileprivate var mainStoryboard: UIStoryboard!
    
    deinit{
        print("deinit -> \(NSStringFromClass(type(of: self)))")
    }
    
    final func messageLogger(_ funcName: String, message: String){
        print("\(NSStringFromClass(type(of: self))) \(funcName) :: \(message)")
    }
    
    final func resolveLanguageCode() -> Int{
        //
        var langCode: Int = 0
        switch(AppInfo().languageID()){
        case LanguageISOId.Arabic.rawValue:
            langCode = LanguageCode.arabic.rawValue
            break
        case LanguageISOId.English.rawValue:
            langCode = LanguageCode.english.rawValue
            break
        default:
            langCode = LanguageCode.english.rawValue
        }
        return langCode
    }
    
    final func resolveClassName(_ type: AnyClass) -> String{
        let fullClassName: NSString = NSStringFromClass(type.self) as NSString
        let moduleName = AppInfo().stringValue(forKey: AppInfo.ConstentKeys.BundleNameKey)!
        let moduleWithSeparetor = NSString(format: "%@.", moduleName)
        let className = fullClassName.replacingOccurrences(of: moduleWithSeparetor as String, with: "")
        return className
    }
    
    final func resolveStoryboardID(_ type: AnyClass) -> String{
        let storyboardID = resolveClassName(type)
        return storyboardID
    }
    
    final func initialViewController() -> UIViewController{
        let selectedStoryboard = storyboard()!
        let initial = selectedStoryboard.instantiateInitialViewController() as UIViewController!
        return initial!
    }
    
    final func resolveViewController(fromType type: AnyClass) -> UIViewController{
        let storyboardID = resolveStoryboardID(type)
        let viewController = storyboard()?.instantiateViewController(withIdentifier: storyboardID) as UIViewController!
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
    
    final func storyboard(_ name: String? = nil) -> UIStoryboard?{
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
