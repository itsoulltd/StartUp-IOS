//
//  NameResource.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/3/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import SeliseToolKit

public enum NameResourceStatus: NSString{
    case Active = "active"
    case Inactive = "inactive"
}

public class NameResource: Response {
    var createdDate: NSString?
    var lastModifiedBy: NSString?
    var lastModifiedDate: NSString?
    var status: NameResourceStatus = .Inactive
    
    public override func updateValue(value: AnyObject!, forKey key: String!) {
        if key == "status" {
            if let val = value as? NSString  {
                self.status = NameResourceStatus(rawValue: val)!
            }
        }else{
            super.updateValue(value, forKey: key)
        }
    }
}
