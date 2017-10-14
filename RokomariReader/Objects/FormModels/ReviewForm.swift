//
//  Review.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/3/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import CoreDataStack

@objcMembers
open class ReviewForm: BaseForm{
    var detail: NSString?
    var ebookId: NSNumber?
    var id: NSNumber?
    var title: NSString?
}
