//
//  EbookSearchResult.swift
//  RokomariReader
//
//  Created by Towhid Islam on 11/18/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

public enum FileSourceType: NSString{
    case ePub = "ePub"
    case PDF = "pdf"
    case JPG = "jpg"
    case PNG = "png"
    case GIF = "gif"
}

public class FileSource: NameResource{
    weak var ebook: Book?
    var file: NSString?
    var fileType: FileSourceType?
    var mainFile: NSString?
    var sampleFile: NSString?
    var version: NSString?
}

public class Book: Response {
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
    var reviews: [Review] = [Review]()
    var rating: [Rating] = [Rating]()
    
    private var savedFolder = DNFolder(name: "Saved", searchDirectoryType: NSSearchPathDirectory.DocumentDirectory)
    var file: DNFile?
    var fileSource: FileSource?
    
    public override func updateValue(value: AnyObject!, forKey key: String!) {
        if key == "status" {
            if let val = value as? NSString  {
                self.status = ResourceStatus(rawValue: val)!
            }
        }else{
            super.updateValue(value, forKey: key)
        }
    }
    
    private var fileTransaction: TransactionStack?
    public func fetchFileInfo(onCompletion: ((FileSource?) -> Void)) -> Void{
        guard let request = RequestFactory.defaultFactory().request(forKey: "GetEbookFile") else{
            fatalError("GetEbookFile not found")
        }
        
        fileTransaction = TransactionStack(callBack: { [weak self] (received) in
            guard let file = received?.first as? FileSource else{
                onCompletion(nil)
                return
            }
            self?.fileSource = file
            onCompletion(file)
        })
        
        let process = TransactionProcess(request: request, parserType: FileSource.self)
        self.fileTransaction?.push(process)
        self.fileTransaction?.commit()
        
    }
    
    private var ratingTransactions: TransactionStack?
    public func fetchRatings(query: Query, onCompletion: (([Rating]?) -> Void)) -> Void{
        
        var req: DNRequest?
        if query is SearchQuery {
            req = RequestFactory.defaultFactory().request(forKey: "SearchRatings")
        }else{
            req = RequestFactory.defaultFactory().request(forKey: "GetRatings")
            if let idx = self.id as? NSNumber{
                query.updateValue(idx.longValue, forKey: "ebook_id")
            }
        }
        
        guard let request = req else{
            fatalError("Invalid Request Object at \(#line) \(#function)")
        }
        
        ratingTransactions = TransactionStack(callBack: { [weak self] (received) in
            guard let items = received as? [Rating] else{
                onCompletion(nil)
                return
            }
            self?.rating = items
            onCompletion(items)
        })
        
        let process = TransactionProcess(request: request, parserType: Rating.self)
        self.ratingTransactions?.push(process)
        self.ratingTransactions?.commit()
    }
    
    private var reviewTransactions: TransactionStack?
    public func fetchReviews(query: Query, onCompletion: (([Review]?) -> Void)) -> Void{
        
        var req: DNRequest?
        if query is SearchQuery {
            req = RequestFactory.defaultFactory().request(forKey: "SearchReviews")
        }else{
            req = RequestFactory.defaultFactory().request(forKey: "GetReviews")
            if let idx = self.id as? NSNumber{
                query.updateValue(idx.longValue, forKey: "ebook_id")
            }
        }
        
        guard let request = req else{
            fatalError("Invalid Request Object at \(#line) \(#function)")
        }
        
        reviewTransactions = TransactionStack(callBack: { [weak self] (received) in
            guard let items = received as? [Review] else{
                onCompletion(nil)
                return
            }
            self?.reviews = items
            onCompletion(items)
        })
        
        let process = TransactionProcess(request: request, parserType: Review.self)
        self.reviewTransactions?.push(process)
        self.reviewTransactions?.commit()
    }
    
}


