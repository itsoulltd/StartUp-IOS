//
//  ForgotPassRouter.swift
//  StartUp
//
//  Created by Towhid Islam on 5/4/18.
//  Copyright © 2018 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import NGAppKit

class ForgotPassRouter: Router {

    override func route(from viewController: UIViewController?, withInfo info: NGObject?) {
        let storyboard = AppStoryboard.load("Main")
        let vc = storyboard?.viewController(byType: ForgetPasswordTVC.self)
        AppStoryboard.show(vc, sender: nil)
    }
}
