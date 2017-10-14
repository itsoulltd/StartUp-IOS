//
//  PublisherCatalog.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/3/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import CoreDataStack
import CoreNetworkStack
import WebServiceKit

open class PublisherCatalog: NGObject{
    
    @objc var publisherResults: [Query: [Publisher]] = [Query: [Publisher]]()
    
    fileprivate var publisherTransac: TransactionStack?
    open func publishers(_ query: Query, onCompletion: @escaping (([Publisher]) -> Void)) -> Void{
        var request: HttpWebRequest?
        if query is SearchQuery {
            request = ServiceBroker.defaultFactory().request(forKey: "SearchPublishers")
        }else{
            request = ServiceBroker.defaultFactory().request(forKey: "GetAllPublishers")
        }
        
        guard let req = request else{
            fatalError("Invalid Request Object at \(#line) \(#function)")
        }
        
        publisherTransac = TransactionStack(callBack: { [weak self] (received) in
            guard let res = received as? [Publisher] else{
                onCompletion([Publisher]())
                return
            }
            self?.publisherResults[query] = res
            onCompletion(res)
            })
        
        req.addAuth()
        req.payLoad = query
        let process = Transaction(request: req, parserType: Publisher.self)
        publisherTransac?.push(process)
        publisherTransac?.commit()
    }
    
}
