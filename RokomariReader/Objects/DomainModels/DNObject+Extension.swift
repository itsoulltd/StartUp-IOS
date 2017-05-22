//
//  NGObject+Extension.swift
//  RokomariReader
//
//  Created by Towhid Islam on 11/27/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import CoreDataStack

extension NGObject { //Search
    
    func matchAnyStringProperty(_ search: String) -> Bool{
        let source = serializeIntoInfo()
        var match = false
        for (key, value) in source! {
            if ((value is NSNull) == false && (value is String)){
                let comp = (source?[key] as! String).lowercased()
                match = comp.contains(search.lowercased())
                if match {
                    break
                }
            }
        }
        return match
    }
    
}

extension NGObject{ //GroupBy and others
    
    class func groupBy(_ key: String, onCollection source: [NGObject]) -> NSDictionary?{
        //Checking NGObject, NSArray or NSDictionary or NSSet
        if let firstValue = source.first?.value(forKey: key), firstValue is NGObject || firstValue is NSArray || firstValue is NSDictionary || firstValue is NSSet {
            print("NGObject or NSArray or NSDictionary or NSSet NOT Supported as Group Value Type");
            return nil
        }
        //
        let result = NSMutableDictionary()
        let sortCommend = AlphabeticalSort()
        let sorted = sortCommend.sort(source, forKeyPath: key) as! [NGObject]
        //Algo Goes ON
        var runningItem: NGObject? = sorted.first
        if let value = runningItem?.value(forKeyPath: key) as? NSCopying{
            result.setObject(NSMutableArray(), forKey: value)
        }
        //
        for nextItem in sorted {
            let nextValue = nextItem.value(forKeyPath: key) as! NSCopying
            if let runningValue = runningItem?.value(forKeyPath: key) as? NSCopying {
                if NGObject.hasSameValue(runningValue, b: nextValue) == false {
                    result.setObject(NSMutableArray(), forKey: nextValue)
                    runningItem = nextItem
                }
            }
            let mutable = result[nextValue] as! NSMutableArray
            mutable.add(nextItem)
        }
        return result
    }
    
    fileprivate class func hasSameValue(_ a: NSCopying, b: NSCopying) -> Bool{
        if (a is NSString && b is NSString) {
            return (a as! NSString) == (b as! NSString)
        }else if (a is NSNumber && b is NSNumber){
            return (a as! NSNumber).stringValue == (b as! NSNumber).stringValue
        }else if (a is NSValue && b is NSValue){
            return (a as! NSValue) == (b as! NSValue)
        }
        return false
    }
    
}

extension NGObject{ //base 64 encoding and decoding
    
    /*func base64EncodedString(_ key: String) -> Void{
        guard let str = self.value(forKeyPath: key) else{
            return
        }
        let data = (str as AnyObject).data(using: String.Encoding.utf8)
        let returnStr = data?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue:0))
        self.updateValue(returnStr, forKey: key)
    }
    
    func base64DecodedString(_ key: String) -> Void{
        guard let str = self.value(forKeyPath: key) as? String else{
            return
        }
        if let data = Data(base64Encoded: str, options: NSData.Base64DecodingOptions(rawValue:0)){
            let resturnStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            self.updateValue(resturnStr, forKey: key)
        }
    }*/
    
}

