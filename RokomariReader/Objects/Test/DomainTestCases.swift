//
//  DomainTestCases.swift
//  HoxroCaseTracker
//
//  Created by Towhid Islam on 9/7/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

class DomainTestCases: NSObject {

    var userManagement: UserManagement = UserManagement(profileType: UserProfile.self)
    var monitor: TRVSMonitor = TRVSMonitor(expectedSignalCount: 1)
    var user = User()
    
    func runTest(){
        print("Test Is Running")
        login()
    }
    
    func login(){
        let model = Login()
        model.password = "towhid"
        model.username = "towhid"
        user.login(model) { (response) in
            print(response?.id_token!)
            self.monitor.signal()
        }
        monitor.wait()
    }
}
