//
//  EbookSearchResult.swift
//  RokomariReader
//
//  Created by Towhid Islam on 11/18/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

public class EBookResource: NameResource{
    var imageUrl: NSString?
    var nameBangla: NSString?
    var nameEnglish: NSString?
}

public class Category: EBookResource {
    var parentId: NSInteger = 0
}

public class Author: EBookResource {
    var detail: NSString?
}

public class Publisher: EBookResource {
    var detail: NSString?
}

public enum EBookStatus: NSString{
    case Available = "available"
    case Unavailable = "unavailable"
    case Unknown = "unknown"
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
    var status: EBookStatus = .Unknown
    
    public override func updateValue(value: AnyObject!, forKey key: String!) {
        if key == "status" {
            if let val = value as? NSString  {
                self.status = EBookStatus(rawValue: val)!
            }
        }else{
            super.updateValue(value, forKey: key)
        }
    }
}

