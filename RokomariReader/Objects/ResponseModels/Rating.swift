//
//  RatingResponse.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/3/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit

public class Rating: NameResource {
    weak var ebook: Book?
    var value: NSNumber?
    var customer: NSString?
}
