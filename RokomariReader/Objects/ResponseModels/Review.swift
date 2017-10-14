//
//  ReviewResponse.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/3/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation

@objcMembers
open class Review: NameResource{
    var title: NSString?
    var detail: NSString?
    weak var ebook: Book?
    var customer: NSString?
}
