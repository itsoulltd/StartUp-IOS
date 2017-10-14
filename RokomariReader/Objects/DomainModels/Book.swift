//
//  EbookSearchResult.swift
//  RokomariReader
//
//  Created by Towhid Islam on 11/18/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import CoreDataStack
import FileSystemSDK
import CoreNetworkStack
import WebServiceKit

public enum FileSourceType: NSString{
    case ePub = "ePub"
    case pdf = "pdf"
    case jpg = "jpg"
    case png = "png"
    case gif = "gif"
}

@objcMembers
open class FileSource: NameResource{
    weak var ebook: Book?
    var file: NSString?
    var fileType: FileSourceType?
    var mainFile: NSString?
    var sampleFile: NSString?
    var version: NSString?
}

open class Book: Response {
    @objc var authors: [Author] = [Author]()
    @objc var categories: [Category] = [Category]()
    @objc var detail_bangla: NSString?
    @objc var detail_english: NSString?
    @objc var discount: NSNumber?
    @objc var edition: NSNumber?
    @objc var image_url: NSString?
    @objc var isbn: NSString?
    @objc var name_bangla: NSString?
    @objc var name_english: NSString?
    @objc var number_of_pages: NSNumber?
    @objc var price_list: NSNumber?
    @objc var price_sales: NSNumber?
    @objc var publisher: Publisher?
    @objc var rokomari_id: NSNumber?
    var status: ResourceStatus = .unknown
    
    @objc var avarageRating: NSNumber?
    @objc var reviews: [Review] = [Review]()
    @objc var rating: [Rating] = [Rating]()
    
    fileprivate var savedFolder = Folder(name: "Saved", searchDirectoryType: FileManager.SearchPathDirectory.documentDirectory)
    var file: File?
    var fileSource: FileSource?
    
    open override func updateValue(_ value: Any!, forKey key: String!) {
        if key == "status" {
            if let val = value as? NSString  {
                self.status = ResourceStatus(rawValue: val)!
            }
        }else{
            super.updateValue(value, forKey: key)
        }
    }
    
    fileprivate var fileTransaction: TransactionStack?
    open func fetchFileInfo(_ onCompletion: @escaping ((FileSource?) -> Void)) -> Void{
        guard let request = ServiceBroker.defaultFactory().request(forKey: "GetEbookFile") else{
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
        
        let process = Transaction(request: request, parserType: FileSource.self)
        self.fileTransaction?.push(process)
        self.fileTransaction?.commit()
        
    }
    
    fileprivate var ratingTransactions: TransactionStack?
    open func fetchRatings(_ query: Query, onCompletion: @escaping (([Rating]?) -> Void)) -> Void{
        
        var req: HttpWebRequest?
        if query is SearchQuery {
            req = ServiceBroker.defaultFactory().request(forKey: "SearchRatings")
        }else{
            req = ServiceBroker.defaultFactory().request(forKey: "GetRatings")
            if let idx = self.id as? NSNumber{
                query.updateValue(idx.intValue, forKey: "ebook_id")
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
        
        let process = Transaction(request: request, parserType: Rating.self)
        self.ratingTransactions?.push(process)
        self.ratingTransactions?.commit()
    }
    
    fileprivate var reviewTransactions: TransactionStack?
    open func fetchReviews(_ query: Query, onCompletion: @escaping (([Review]?) -> Void)) -> Void{
        
        var req: HttpWebRequest?
        if query is SearchQuery {
            req = ServiceBroker.defaultFactory().request(forKey: "SearchReviews")
        }else{
            req = ServiceBroker.defaultFactory().request(forKey: "GetReviews")
            if let idx = self.id as? NSNumber{
                query.updateValue(idx.intValue, forKey: "ebook_id")
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
        
        let process = Transaction(request: request, parserType: Review.self)
        self.reviewTransactions?.push(process)
        self.reviewTransactions?.commit()
    }
    
}


