//
//  Query.swift
//  RokomariReader
//
//  Created by Towhid Islam on 11/19/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

public class Query: DNObject {
    var page: NSNumber = 0
    var size: NSNumber = 20
    var sort: NSArray?
    
    public func queryString() -> String{
        var str = "page=\(page)&size=\(size)"
        for item in sort! {
            str += "&sort=\(item)"
        }
        return str
    }
}

public class SearchQuery: Query {
    
    var query: NSString?
    
    public override func queryString() -> String {
        var superStr = super.queryString()
        if let qu = query{
            superStr += "&query=\(qu)"
        }
        return superStr
    }
    
}
