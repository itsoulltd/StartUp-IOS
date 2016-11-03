//
//  BackgroundFetchMonitor.swift
//  HoxroCaseTracker
//
//  Created by Towhid Islam on 9/7/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import Foundation
import SeliseToolKit

class BackgroundFetchMonitor: NSObject {
    
    private var commendList: [FetchCommend] = [FetchCommend]()

    func configureFetchSchedule(application: UIApplication) -> Void{
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    }
    
    func executeFetch(completionHandler: (UIBackgroundFetchResult) -> Void){
        if commendList.isEmpty {
            completionHandler(UIBackgroundFetchResult.NoData)
            return
        }
        for commend in commendList {
            commend.fetch()
        }
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    func addCommend(commend: FetchCommend){
        commendList.append(commend)
    }
    
    func removeCommend(commend: FetchCommend){
        //TODO:
    }
    
}

protocol FetchCommend: NSObjectProtocol {
    func fetch() -> UIBackgroundFetchResult
}


