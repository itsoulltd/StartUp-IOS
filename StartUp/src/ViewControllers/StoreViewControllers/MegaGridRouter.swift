//
//  MegaGridRouter.swift
//  StartUp
//
//  Created by Towhid Islam on 5/4/18.
//  Copyright © 2018 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import NGAppKit

class MegaGridRouter: Router {

    override func route(from viewController: UIViewController?, withInfo info: NGObject?) {
        let storyboard = AppStoryboard.load("Main")
        let rootViewController = storyboard?.viewController(byType: MegaGridTvc.self)
        let nav = UINavigationController(rootViewController: rootViewController!)
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = nav
    }
}
