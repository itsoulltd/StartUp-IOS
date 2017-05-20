//
//  RequestFactory.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 1/25/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import CoreDataStack
import WebServiceKit

open class ServiceBroker: NSObject{
    
    struct URLKeys {
        static let ActiveLive = "ActiveLive"
        static let PingURL = "PingUrl"
        static let LiveURL = "LiveUrl"
        static let StagingURL = "StagingUrl"
        static let ReferrerKey = "Referer"
    }
    
    fileprivate static var factoryCollection: [String : RequestFactory] = [String : RequestFactory]()
    
    open class func defaultFactory() -> RequestFactory{
        return getFactory(forKey: "RokomaryWebServices")
    }
    
    open class func getFactory(forKey key: String) -> RequestFactory{
        if let factory = factoryCollection[key]{
            return factory
        }
        else{
            let factory = RequestFactory(configFileName: key)
            factoryCollection[key] = factory
            return factory
        }
    }
    
}
