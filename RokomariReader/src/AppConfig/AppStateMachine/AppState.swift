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
open class AppState: GKState {
    
    public struct Facts{
        static let IsRemembered = "isRemembered"
        static let IsLoggedIn = "isLoggedIn"
    }
    
    public struct SharedResource{
        static var ruleSystem: NGRuleSystem = {
            let system = NGRuleSystem()
            return system
        }()
    }

    var appStoryboard: AppRouter{
        return AppRouter.shared()
    }
    
    var window: UIWindow?{
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        return appDelegate.window
    }
    
}
