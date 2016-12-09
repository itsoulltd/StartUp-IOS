//
//  EbookSearchResult.swift
//  RokomariReader
//
//  Created by Towhid Islam on 11/18/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

public enum EbookFileType: NSString{
    case ePub = "ePub"
    case PDF = "pdf"
    case JPG = "jpg"
    case PNG = "png"
    case GIF = "gif"
}

public class EbookFile: NameResource{
    weak var ebook: EBook?
    var file: NSString?
    var fileType: EbookFileType?
    var mainFile: NSString?
    var sampleFile: NSString?
    var version: NSString?
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
    var status: ResourceStatus = .Unknown
    
    var avarageRating: NSNumber?
    var reviews: [ReviewResponse] = [ReviewResponse]()
    var rating: [RatingResponse] = [RatingResponse]()
    
    private var savedFolder = DNFolder(name: "Saved", searchDirectoryType: NSSearchPathDirectory.DocumentDirectory)
    var physicalFile: DNFile?
    var ebookFile: EbookFile?
    
    public override func updateValue(value: AnyObject!, forKey key: String!) {
        if key == "status" {
            if let val = value as? NSString  {
                self.status = ResourceStatus(rawValue: val)!
            }
        }else{
            super.updateValue(value, forKey: key)
        }
    }
    
    public func fetchFileInfo(onCompletion: ((EbookFile?) -> Void)) -> Void{
        //TODO
    }
    
    public func fetchRatings(onCompletion: (([RatingResponse]?) -> Void)) -> Void{
        //TODO
    }
    
    public func fetchReviews(onCompletion: (([ReviewResponse]?) -> Void)) -> Void{
        //TODO
    }
    
}


