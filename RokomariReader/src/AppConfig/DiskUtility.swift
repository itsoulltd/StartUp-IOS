//
//  DiskUtility.swift
//  Jamahook
//
//  Created by Towhid on 12/22/15.
//  Copyright © 2015 Hoxro Ltd, 207 Regent Street, London, W1B 3HN. All rights reserved.
//

import UIKit

public enum SpaceIn: Int{
    case Bytes, KB, MB, GB, TB
}

public class DiskUtility: NSObject {
    
    class func documentDirectoryPath() -> NSString{
        let array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        return array.lastObject as! NSString
    }

    class func diskSpace(byKey key: String) -> NSNumber?{
        let path = DiskUtility.documentDirectoryPath()
        do{
            if let info = try NSFileManager.defaultManager().attributesOfFileSystemForPath(path as String) as NSDictionary?{
                let sizeInBytes = info.objectForKey(key) as? NSNumber
                return sizeInBytes
            }
        } catch let error as NSError{
            print("\(#function) at line \(#line) \(error.debugDescription)")
        }
        return nil
    }
    
    class func totalSpace(In space: SpaceIn = .Bytes) -> Double{
        if let total = DiskUtility.diskSpace(byKey: NSFileSystemSize){
            let divisor: Double = DiskUtility.getValue(total.doubleValue, space: space)
            return divisor
        }
        return 0.0
    }
    
    class func freeSpace(In space: SpaceIn = .Bytes) -> Double{
        if let free = DiskUtility.diskSpace(byKey: NSFileSystemFreeSize){
            let divisor: Double = DiskUtility.getValue(free.doubleValue, space: space)
            return divisor
        }
        return 0.0
    }
    
    class func getValue(value: Double, space: SpaceIn) -> Double{
        var factor: Double = 1.0
        switch space{
        case .TB:
            factor = value / 1024.0 / 1024.0 / 1024.0 / 1024.0
            break
        case .GB:
            factor = value / 1024.0 / 1024.0 / 1024.0
            break
        case .MB:
            factor = value / 1024.0 / 1024.0
            break
        case .KB:
            factor = value / 1024.0
            break
        default:
            factor = value
        }
        return factor
    }
    
}
