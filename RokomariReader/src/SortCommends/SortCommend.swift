//
//  SortCommend.swift
//  RufDriveApp
//
//  Created by Towhid on 7/29/15.
//  Copyright (c) 2015 md arifuzzaman. All rights reserved.
//

import Foundation
import SeliseToolKit

protocol SortCommendProtocol: NSObjectProtocol{
    static func restoreSharedCommend(defaultSortType sortType: DNObject.Type) -> SortCommend
    static func restoreCommend(byKey key: String) -> SortCommend?
    static func storeSharedCommend(commend: SortCommend) -> Void
    static func storeCommend(commend: SortCommend, byKey key: String) -> Void
    func sort(inout inMemory collection: [DNObjectProtocol], forKeyPath keyPath: String?, order: NSComparisonResult) -> [DNObjectProtocol]
    func sort(collection: [DNObjectProtocol], forKeyPath keyPath: String?, order: NSComparisonResult) -> [DNObjectProtocol]
    func compare(first: AnyObject, second: AnyObject, forKeyPath keyPath: String?) -> Bool
    func isDateType(forKeyPath keyPath: String?) -> Bool
    func date(fromString stringValue: String?) -> NSDate?
    func preferredSortOrder() -> NSComparisonResult
}

class SortCommend: DNObject, SortCommendProtocol {
    
    class func restoreSharedCommend(defaultSortType sortType: DNObject.Type = SortCommend.self) -> SortCommend{
        if let savedObject = SortCommend.restoreCommend(byKey: "SharedCommendKey"){
            return savedObject
        }
        let dynamicObj = sortType.init()
        return dynamicObj as! SortCommend
    }
    
    class func restoreCommend(byKey key: String) -> SortCommend?{
        if let savedObject = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSData{
            let unarchived = NSKeyedUnarchiver.unarchiveObjectWithData(savedObject) as? SortCommend
            return unarchived
        }
        return nil
    }
    
    class func storeSharedCommend(commend: SortCommend) -> Void{
        SortCommend.storeCommend(commend, byKey: "SharedCommendKey")
    }
    
    class func storeCommend(commend: SortCommend, byKey key: String) -> Void{
        let archived = NSKeyedArchiver.archivedDataWithRootObject(commend)
        NSUserDefaults.standardUserDefaults().setObject(archived, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func sort(inout inMemory collection: [DNObjectProtocol], forKeyPath keyPath: String?, order: NSComparisonResult = NSComparisonResult.OrderedAscending) -> [DNObjectProtocol]{
        self.order = order
        collection.sortInPlace { (first, second) -> Bool in
            return self.compare(first, second: second, forKeyPath: keyPath)
        }
        return collection
    }
    
    func sort(collection: [DNObjectProtocol], forKeyPath keyPath: String?, order: NSComparisonResult = NSComparisonResult.OrderedAscending) -> [DNObjectProtocol]{
        self.order = order
        let sorted = collection.sort { (first, second) -> Bool in
            return self.compare(first, second: second, forKeyPath: keyPath)
        }
        return sorted
    }
    
    var order: NSComparisonResult = NSComparisonResult.OrderedAscending
    func preferredSortOrder() -> NSComparisonResult {
        return order
    }
    
    func isDateType(forKeyPath keyPath: String?) -> Bool {
        return false
    }
    
    func date(fromString stringValue: String?) -> NSDate? {
        return nil
    }
    
    func compare(first: AnyObject, second: AnyObject, forKeyPath keyPath: String?) -> Bool{
        if isDateType(forKeyPath: keyPath){
            if let firstDate = getDate(fromValue: first.valueForKeyPath(keyPath!)!){
                if let secondDate = getDate(fromValue: second.valueForKeyPath(keyPath!)!){
                    let comparison = firstDate.compare(secondDate)
                    //ByDefault Date is Descending Order
                    return comparison == self.preferredSortOrder()
                }
            }
            return false
        }
        else{
            let firstValue: AnyObject? = first.valueForKeyPath(keyPath!)
            let secondValue: AnyObject? = second.valueForKeyPath(keyPath!)
            if let firstString = getString(fromValue: firstValue!){
                if let secondString = getString(fromValue: secondValue!){
                    if firstValue is NSNumber{
                        //ByDefault Number is Ascending Order
                        return firstString.compare(secondString as String, options: NSStringCompareOptions.NumericSearch) == self.preferredSortOrder()
                    }
                    else{
                        //ByDefault String is Ascending Order
                        return firstString.compare(secondString as String, options: NSStringCompareOptions.LiteralSearch) == self.preferredSortOrder()
                    }
                }
            }
            return false
        }
    }
    
    private func getDate(fromValue value: AnyObject) -> NSDate?{
        if value is NSDate{
            return value as? NSDate
        }
        else{
            return date(fromString: value as? String)
        }
    }
    
    private func getString(fromValue value: AnyObject) -> NSString?{
        if value is NSNumber{
            return (value as? NSNumber)?.stringValue
        }
        else if value is String{
            return value as? NSString
        }
        return nil
    }
    
}

