//
//  DateSort.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 8/16/15.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import CoreDataStack

class DateSort: SortCommend {
    
    override func sort(inMemory collection: inout [NGObjectProtocol], forKeyPath keyPath: String? = nil, order: ComparisonResult = ComparisonResult.orderedAscending) -> [NGObjectProtocol] {
        self.order = order
        collection.sort { (first, second) -> Bool in
            //Now make comparison.
            return self.compare(first as! NSObject, second: second as! NSObject, forKeyPath: keyPath)
        }
        return collection
    }
    
    override func sort(_ collection: [NGObjectProtocol], forKeyPath keyPath: String? = nil, order: ComparisonResult = ComparisonResult.orderedAscending) -> [NGObjectProtocol] {
        self.order = order
        let sorted = collection.sorted { (first, second) -> Bool in
            //Now make comparison.
            return self.compare(first as! NSObject, second: second as! NSObject, forKeyPath: keyPath)
        }
        return sorted
    }
    
    override func isDateType(forKeyPath keyPath: String?) -> Bool {
        return true
    }
    
    override func date(fromString stringValue: String?) -> Date? {
        let formatter: Foundation.DateFormatter = Foundation.DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss a"
        return formatter.date(from: stringValue!)
    }
    
}
