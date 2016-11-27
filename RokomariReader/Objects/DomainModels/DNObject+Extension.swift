//
//  DNObject+Extension.swift
//  RokomariReader
//
//  Created by Towhid Islam on 11/27/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import SeliseToolKit

extension DNObject { //Search
    
    func matchAnyStringProperty(search: String) -> Bool{
        let source = serializeIntoInfo()
        var match = false
        for (key, value) in source {
            if ((value is NSNull) == false && (value is String)){
                let comp = (source[key] as! String).lowercaseString
                match = comp.containsString(search.lowercaseString)
                if match {
                    break
                }
            }
        }
        return match
    }
    
}

extension DNObject{ //GroupBy and others
    
    class func groupBy(key: String, onCollection source: [DNObject]) -> NSDictionary?{
        //Checking DNObject, NSArray or NSDictionary or NSSet
        if let firstValue = source.first?.valueForKey(key)
            where firstValue is DNObject || firstValue is NSArray || firstValue is NSDictionary || firstValue is NSSet {
            print("DNObject or NSArray or NSDictionary or NSSet NOT Supported as Group Value Type");
            return nil
        }
        //
        let result = NSMutableDictionary()
        let sortCommend = AlphabeticalSort()
        let sorted = sortCommend.sort(source, forKeyPath: key) as! [DNObject]
        //Algo Goes ON
        var runningItem: DNObject? = sorted.first
        if let value = runningItem?.valueForKeyPath(key) as? NSCopying{
            result.setObject(NSMutableArray(), forKey: value)
        }
        //
        for nextItem in sorted {
            let nextValue = nextItem.valueForKeyPath(key) as! NSCopying
            if let runningValue = runningItem?.valueForKeyPath(key) as? NSCopying {
                if DNObject.hasSameValue(runningValue, b: nextValue) == false {
                    result.setObject(NSMutableArray(), forKey: nextValue)
                    runningItem = nextItem
                }
            }
            let mutable = result[nextValue] as! NSMutableArray
            mutable.addObject(nextItem)
        }
        return result
    }
    
    private class func hasSameValue(a: NSCopying, b: NSCopying) -> Bool{
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

extension DNObject{ //base 64 encoding and decoding
    
    func base64EncodedString(key: String) -> Void{
        guard let str = self.valueForKeyPath(key) else{
            return
        }
        let data = str.dataUsingEncoding(NSUTF8StringEncoding)
        let returnStr = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue:0))
        self.updateValue(returnStr, forKey: key)
    }
    
    func base64DecodedString(key: String) -> Void{
        guard let str = self.valueForKeyPath(key) as? String else{
            return
        }
        if let data = NSData(base64EncodedString: str, options: NSDataBase64DecodingOptions(rawValue:0)){
            let resturnStr = NSString(data: data, encoding: NSUTF8StringEncoding)
            self.updateValue(resturnStr, forKey: key)
        }
    }
    
}

