//
//  AlertMessageController.swift
//  MymoUpload
//
//  Created by Towhid on 9/15/14.
//  Copyright (c) 2014 Towhid (Selise.ch). All rights reserved.
//

import UIKit

class AlertViewController: NSObject {
   
    @available(iOS 8.0, *)
    class func show(_ message: AlertMessage){
        if let activeViewController = AlertViewController.visibleViewController(){
            AlertViewController.show(activeViewController, message: message)
        }
    }
    
    @available(iOS 8.0, *)
    class func show(_ viewController: UIViewController, message: AlertMessage){
        let alertViewController = createAlertViewController(message)
        viewController.present(alertViewController, animated: true, completion: nil)
    }
    
    @available(iOS 8.0, *)
    class func show(using controller: UIAlertController){
        if let visible = AlertViewController.visibleViewController(){
            visible.present(controller, animated: true, completion: nil)
        }
    }
    
    class fileprivate func visibleViewController() -> UIViewController?{
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
    
    @available(iOS 8.0, *)
    fileprivate class func createAlertViewController(_ message: AlertMessage) -> UIAlertController{
        let alertViewController = UIAlertController(title: message.title as String, message: message.message as String, preferredStyle: UIAlertController.Style.alert)
        
        if let cancelAction = message.cancelAction{
            alertViewController.addAction(cancelAction)
        }
        
        if let others = message.otherActions{
            for action in others {
                alertViewController.addAction(action)
            }
        }
        return alertViewController
    }
    
    @available(iOS 8.0, *)
    class func longTextAlert( _ viewController: UIViewController, message: AlertMessage){
        let alertViewController = createAlertViewController(message)
        alertViewController.view.frame = UIScreen.main.applicationFrame
        viewController.present(alertViewController, animated: true, completion: nil)
    }
}

@available(iOS 8.0, *)
class CustomAlertViewController: UIAlertController {
    
    override var preferredContentSize: CGSize {
        get{
            return CGSize(width: 200.0, height: 350.0)
        }
        set{}
    }
}
