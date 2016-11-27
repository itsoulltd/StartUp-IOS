//
//  EbookSearchResult.swift
//  RokomariReader
//
//  Created by Towhid Islam on 11/18/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

public class NameResource: Response {
    var image_url: NSString?
    var name_bangla: NSString?
    var name_english: NSString?
}

public class Category: NameResource {
    
}

public class Author: NameResource {
    
}

public class Publisher: NameResource {
    
}

public class EBook: Response {
    var authors: [Author] = [Author]()
    var categories: [Category] = [Category]()
    var detail_bangla: NSString?
    var detail_english: NSString?
    var discount: NSNumber?
    var edition: NSNumber?
    var image_url: NSString?
    var isbn: NSString?
    var name_bangla: NSString?
    var name_english: NSString?
    var number_of_pages: NSNumber?
    var price_list: NSNumber?
    var price_sales: NSNumber?
    var publisher: Publisher?
    var rokomari_id: NSNumber?
    var status: NSString?
}

