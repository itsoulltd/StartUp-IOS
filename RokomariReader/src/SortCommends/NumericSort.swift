//
//  NumericSort.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 8/16/15.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation

class NumericSort: SortCommend {
    
    override func compare(first: AnyObject, second: AnyObject, forKeyPath keyPath: String?) -> Bool {
        let firstValue: AnyObject? = first.valueForKeyPath(keyPath!)
        let secondValue: AnyObject? = second.valueForKeyPath(keyPath!)
        if firstValue is NSNumber{
            //ByDefault Number is Ascending Order
            return (firstValue as! NSNumber).compare((secondValue as! NSNumber)) == preferredSortOrder()
        }
        else{
            //ByDefault String is Ascending Order
            return compare(first, second: second, forKeyPath: keyPath)
        }
    }
    
}