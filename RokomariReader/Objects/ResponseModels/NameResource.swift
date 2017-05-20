//
//  NameResource.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/3/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import CoreDataStack
import WebServiceKit

public enum ResourceStatus: NSString{
    case active = "active"
    case inactive = "inactive"
    case available = "available"
    case unavailable = "unavailable"
    case unknown = "unknown"
}

open class NameResource: Response {
    var createdDate: NSString?
    var lastModifiedBy: NSString?
    var lastModifiedDate: NSString?
    var status: ResourceStatus = .inactive
    
    open override func updateValue(_ value: Any!, forKey key: String!) {
        if key == "status" {
            if let val = value as? NSString  {
                self.status = ResourceStatus(rawValue: val)!
            }
        }else{
            super.updateValue(value, forKey: key)
        }
    }
}
