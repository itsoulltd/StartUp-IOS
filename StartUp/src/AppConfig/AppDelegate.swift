//
//  AppDelegate.swift
//  StartUp
//
//  Created by Towhid Islam on 10/25/16.
//  Copyright © 2018 ITSoulLab (https://www.itsoullab.com). All rights reserved.
//

import UIKit
import CoreDataStack
import CoreNetworkStack
import NGAppKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    @objc func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        CSDebugLog.setDebugModeOn(false)
        CSDebugLog.setTrackingModeOn(false)
        CNDebugLog.setDebugModeOn(false)
        CNDebugLog.setTrackingModeOn(false)
        AppStoryboard.configureApplication(application, mainBundle: Bundle.main)
        AppRouter.shared().start()
        window?.makeKeyAndVisible()
        return true
    }

}

