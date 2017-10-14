//
//  Query.swift
//  RokomariReader
//
//  Created by Towhid Islam on 11/19/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import CoreDataStack

@objcMembers
open class Query: BaseForm {
    var page: NSNumber = 0
    var size: NSNumber = 20
    var sort: NSArray?
}

@objcMembers
open class SearchQuery: Query {
    var query: NSString?
    
    func applyFieldValidation() {
        addRequiredRule(to: "query")
    }
}
