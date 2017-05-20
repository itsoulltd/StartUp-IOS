//
//  BackgroundFetchMonitor.swift
//  HoxroCaseTracker
//
//  Created by Towhid Islam on 9/7/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import Foundation
import CoreDataStack

class BackgroundFetchMonitor: NSObject {
    
    fileprivate var commendList: [FetchCommend] = [FetchCommend]()

    func configureFetchSchedule(_ application: UIApplication) -> Void{
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    }
    
    func executeFetch(_ completionHandler: (UIBackgroundFetchResult) -> Void){
        if commendList.isEmpty {
            completionHandler(UIBackgroundFetchResult.noData)
            return
        }
        for commend in commendList {
            let _ = commend.fetch()
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func addCommend(_ commend: FetchCommend){
        commendList.append(commend)
    }
    
    func removeCommend(_ commend: FetchCommend){
        //TODO:
    }
    
}

protocol FetchCommend: NSObjectProtocol {
    func fetch() -> UIBackgroundFetchResult
}


