//
//  AlphabeticalSort.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 8/16/15.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import SeliseToolKit

class AlphabeticalSort: SortCommend {
    
    override func sort(inout inMemory collection: [DNObjectProtocol], forKeyPath keyPath: String?, order: NSComparisonResult = NSComparisonResult.OrderedAscending) -> [DNObjectProtocol] {
        self.order = order
        collection.sortInPlace { (first, second) -> Bool in
            return self.compare(first, second: second, forKeyPath: keyPath)
        }
        return collection
    }
    
    override func sort(collection: [DNObjectProtocol], forKeyPath keyPath: String?, order: NSComparisonResult = NSComparisonResult.OrderedAscending) -> [DNObjectProtocol] {
        self.order = order
        let sorted = collection.sort { (first, second) -> Bool in
            return self.compare(first, second: second, forKeyPath: keyPath)
        }
        return sorted
    }
}
