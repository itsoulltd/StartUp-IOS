//
//  AppDelegate.swift
//  RokomariReader
//
//  Created by Towhid Islam on 10/25/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import CoreDataStack
import CoreNetworkStack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    @objc func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        CSDebugLog.setDebugModeOn(false)
        CSDebugLog.setTrackingModeOn(false)
        CNDebugLog.setDebugModeOn(false)
        CNDebugLog.setTrackingModeOn(false)
        AppRouter.shared().start()
        window?.makeKeyAndVisible()
        return true
    }

}

