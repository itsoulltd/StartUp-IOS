//
//  PublisherCatalog.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/3/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import SeliseToolKit

public class PublisherCatalog: DNObject{
    
    var publisherResults: [Query: [Publisher]] = [Query: [Publisher]]()
    
    private var publisherTransac: TransactionStack?
    public func publishers(query: Query, onCompletion: (([Publisher]) -> Void)) -> Void{
        var request: DNRequest?
        if query is SearchQuery {
            request = RequestFactory.defaultFactory().request(forKey: "SearchPublishers")
        }else{
            request = RequestFactory.defaultFactory().request(forKey: "GetAllPublishers")
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
        let process = TransactionProcess(request: req, parserType: Publisher.self)
        publisherTransac?.push(process)
        publisherTransac?.commit()
    }
    
}