//
//  AuthorCatalog.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/3/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import SeliseToolKit

public class AuthorCatalog: DNObject{
    var authorResults: [Query: [Author]] = [Query: [Author]]()
    
    private var authorTransac: TransactionStack?
    public func authors(query: Query, onCompletion: (([Author]) -> Void)) -> Void{
        var request: DNRequest?
        if query is SearchQuery {
            request = RequestFactory.defaultFactory().request(forKey: "SearchAuthors")
        }else{
            request = RequestFactory.defaultFactory().request(forKey: "GetAllAuthors")
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
        let process = TransactionProcess(request: req, parserType: Author.self)
        authorTransac?.push(process)
        authorTransac?.commit()
    }
}


