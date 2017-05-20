//
//  SortCommend.swift
//  RufDriveApp
//
//  Created by Towhid on 7/29/15.
//  Copyright (c) 2015 md arifuzzaman. All rights reserved.
//

import Foundation
import CoreDataStack

protocol SortCommendProtocol: NSObjectProtocol{
    static func restoreSharedCommend(defaultSortType sortType: NGObject.Type) -> SortCommend
    static func restoreCommend(byKey key: String) -> SortCommend?
    static func storeSharedCommend(_ commend: SortCommend) -> Void
    static func storeCommend(_ commend: SortCommend, byKey key: String) -> Void
    func sort(inMemory collection: inout [NGObjectProtocol], forKeyPath keyPath: String?, order: ComparisonResult) -> [NGObjectProtocol]
    func sort(_ collection: [NGObjectProtocol], forKeyPath keyPath: String?, order: ComparisonResult) -> [NGObjectProtocol]
    func compare(_ first: NSObject, second: NSObject, forKeyPath keyPath: String?) -> Bool
    func isDateType(forKeyPath keyPath: String?) -> Bool
    func date(fromString stringValue: String?) -> Date?
    func preferredSortOrder() -> ComparisonResult
}

class SortCommend: NGObject, SortCommendProtocol {
    
    class func restoreSharedCommend(defaultSortType sortType: NGObject.Type = SortCommend.self) -> SortCommend{
        if let savedObject = SortCommend.restoreCommend(byKey: "SharedCommendKey"){
            return savedObject
        }
        let dynamicObj = sortType.init()
        return dynamicObj as! SortCommend
    }
    
    class func restoreCommend(byKey key: String) -> SortCommend?{
        if let savedObject = UserDefaults.standard.object(forKey: key) as? Data{
            let unarchived = NSKeyedUnarchiver.unarchiveObject(with: savedObject) as? SortCommend
            return unarchived
        }
        return nil
    }
    
    class func storeSharedCommend(_ commend: SortCommend) -> Void{
        SortCommend.storeCommend(commend, byKey: "SharedCommendKey")
    }
    
    class func storeCommend(_ commend: SortCommend, byKey key: String) -> Void{
        let archived = NSKeyedArchiver.archivedData(withRootObject: commend)
        UserDefaults.standard.set(archived, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func sort(inMemory collection: inout [NGObjectProtocol], forKeyPath keyPath: String?, order: ComparisonResult = ComparisonResult.orderedAscending) -> [NGObjectProtocol]{
        self.order = order
        collection.sort { (first, second) -> Bool in
            return self.compare(first as! NSObject, second: second as! NSObject, forKeyPath: keyPath)
        }
        return collection
    }
    
    func sort(_ collection: [NGObjectProtocol], forKeyPath keyPath: String?, order: ComparisonResult = ComparisonResult.orderedAscending) -> [NGObjectProtocol]{
        self.order = order
        let sorted = collection.sorted { (first, second) -> Bool in
            return self.compare(first as! NSObject, second: second as! NSObject, forKeyPath: keyPath)
        }
        return sorted
    }
    
    var order: ComparisonResult = ComparisonResult.orderedAscending
    func preferredSortOrder() -> ComparisonResult {
        return order
    }
    
    func isDateType(forKeyPath keyPath: String?) -> Bool {
        return false
    }
    
    func date(fromString stringValue: String?) -> Date? {
        return nil
    }
    
    func compare(_ first: NSObject, second: NSObject, forKeyPath keyPath: String?) -> Bool{
        if isDateType(forKeyPath: keyPath){
            if let firstDate = getDate(fromValue: first.value(forKeyPath: keyPath!)! as AnyObject){
                if let secondDate = getDate(fromValue: second.value(forKeyPath: keyPath!)! as AnyObject){
                    let comparison = firstDate.compare(secondDate)
                    //ByDefault Date is Descending Order
                    return comparison == self.preferredSortOrder()
                }
            }
            return false
        }
        else{
            let firstValue: AnyObject? = first.value(forKeyPath: keyPath!) as AnyObject?
            let secondValue: AnyObject? = second.value(forKeyPath: keyPath!) as AnyObject?
            if let firstString = getString(fromValue: firstValue!){
                if let secondString = getString(fromValue: secondValue!){
                    if firstValue is NSNumber{
                        //ByDefault Number is Ascending Order
                        return firstString.compare(secondString as String, options: NSString.CompareOptions.numeric) == self.preferredSortOrder()
                    }
                    else{
                        //ByDefault String is Ascending Order
                        return firstString.compare(secondString as String, options: NSString.CompareOptions.literal) == self.preferredSortOrder()
                    }
                }
            }
            return false
        }
    }
    
    fileprivate func getDate(fromValue value: AnyObject) -> Date?{
        if value is Date{
            return value as? Date
        }
        else{
            return date(fromString: value as? String)
        }
    }
    
    fileprivate func getString(fromValue value: AnyObject) -> NSString?{
        if value is NSNumber{
            return (value as? NSNumber)?.stringValue as NSString?
        }
        else if value is String{
            return value as? NSString
        }
        return nil
    }
    
}

