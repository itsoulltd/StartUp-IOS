//
//  RequestFactory.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 1/25/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import SeliseToolKit

public class RequestFactory: NSObject{
    
    struct URLKeys {
        static let ActiveLive = "ActiveLive"
        static let PingURL = "PingUrl"
        static let LiveURL = "LiveUrl"
        static let StagingURL = "StagingUrl"
        static let ReferrerKey = "Referer"
    }
    
    private static var factoryCollection: [String : DNRequestFactory] = [String : DNRequestFactory]()
    
    public class func defaultFactory() -> DNRequestFactory{
        return getFactory(forKey: "RequestList")
    }
    
    public class func getFactory(forKey key: String) -> DNRequestFactory{
        if let factory = factoryCollection[key]{
            return factory
        }
        else{
            let factory = DNRequestFactory(configFileName: key)
            factoryCollection[key] = factory
            return factory
        }
    }
    
}