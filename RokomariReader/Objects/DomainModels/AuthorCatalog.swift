//
//  AuthorCatalog.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/3/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import CoreDataStack
import CoreNetworkStack
import WebServiceKit

open class AuthorCatalog: NGObject{
    var authorResults: [Query: [Author]] = [Query: [Author]]()
    
    fileprivate var authorTransac: TransactionStack?
    open func authors(_ query: Query, onCompletion: @escaping (([Author]) -> Void)) -> Void{
        var request: HttpWebRequest?
        if query is SearchQuery {
            request = ServiceBroker.defaultFactory().request(forKey: "SearchAuthors")
        }else{
            request = ServiceBroker.defaultFactory().request(forKey: "GetAllAuthors")
        }
        
        guard let req = request else{
            fatalError("Invalid Request Object at \(#line) \(#function)")
        }
        
        authorTransac = TransactionStack(callBack: { [weak self] (received) in
            guard let res = received as? [Author] else{
                onCompletion([Author]())
                return
            }
            self?.authorResults[query] = res
            onCompletion(res)
            })
        
        req.addAuth()
        req.payLoad = query
        let process = Transaction(request: req, parserType: Author.self)
        authorTransac?.push(process)
        authorTransac?.commit()
    }
}


