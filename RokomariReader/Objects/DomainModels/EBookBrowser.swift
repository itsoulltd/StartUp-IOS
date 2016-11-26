//
//  EBookSearch.swift
//  RokomariReader
//
//  Created by Towhid Islam on 11/26/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

public class EBookBrowser: DNObject {
    
    var searchResult: [SearchQuery:[EBook]] = [SearchQuery:[EBook]]()
    var fetchResult: [Query:[EBook]] = [Query:[EBook]]()
    
    private var searchBooks: TransactionStack?
    public func search(query: SearchQuery, onCompletion: (([EBook]) -> Void)) -> Void {
        guard let request = RequestFactory.defaultFactory().request(forKey: "SearchEBooks") else{
            fatalError("SearchEBooks not available")
        }
        
        searchBooks = TransactionStack(callBack: { [weak self] (received) in
            guard let res = received as? [EBook] else{
                onCompletion([EBook]())
                return
            }
            self?.searchResult[query] = res
            onCompletion(res)
        })
        
        request.addAuth()
        request.payLoad = query
        let process = TransactionProcess(request: request, parserType: EBook.self)
        searchBooks?.push(process)
        searchBooks?.commit()
    }
    
    private var fetchBooks: TransactionStack?
    public func fetch(query: Query, onCompletion: (([EBook]) -> Void)) -> Void {
        guard let request = RequestFactory.defaultFactory().request(forKey: "GetAllEBooks") else{
            fatalError("GetAllEBooks not available")
        }
        
        fetchBooks = TransactionStack(callBack: { [weak self] (received) in
            guard let res = received as? [EBook] else{
                onCompletion([EBook]())
                return
            }
            self?.fetchResult[query] = res
            onCompletion(res)
        })
        
        request.addAuth()
        request.payLoad = query
        let process = TransactionProcess(request: request, parserType: EBook.self)
        fetchBooks?.push(process)
        fetchBooks?.commit()
    }
    
}
