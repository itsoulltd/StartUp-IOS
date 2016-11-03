//
//  AppState.swift
//  Jamahook
//
//  Created by Towhid on 11/30/15.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import GameplayKit

@available(iOS 9.0, *)
public class AppState: GKState {
    
    public struct Facts{
        static let IsRemembered = "isRemembered"
        static let IsLoggedIn = "isLoggedIn"
    }
    
    public struct SharedResource{
        static var ruleSystem: DNRuleSystem = {
            let system = DNRuleSystem()
            return system
        }()
    }

    var appStoryboard: AppStoryboard{
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        return appDelegate.appStoryboard
    }
    
    var window: UIWindow?{
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        return appDelegate.window
    }
    
}
