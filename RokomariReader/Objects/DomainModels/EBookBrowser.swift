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
    
    var authorResults: [Query: [Author]] = [Query: [Author]]()
    var categoryResults: [Query: [Category]] = [Query: [Category]]()
    var publisherResults: [Query: [Publisher]] = [Query: [Publisher]]()
    
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
    
    private var categoryTransac: TransactionStack?
    public func categories(query: Query, onCompletion: (([Category]) -> Void)) -> Void{
        var request: DNRequest?
        if query is SearchQuery {
            request = RequestFactory.defaultFactory().request(forKey: "SearchCategories")
        }else{
            request = RequestFactory.defaultFactory().request(forKey: "GetAllCategories")
        }
        
        guard let req = request else{
            fatalError("Invalid Request Object at \(#line) \(#function)")
        }
        
        categoryTransac = TransactionStack(callBack: { [weak self] (received) in
            guard let res = received as? [Category] else{
                onCompletion([Category]())
                return
            }
            self?.categoryResults[query] = res
            onCompletion(res)
        })
        
        req.addAuth()
        req.payLoad = query
        let process = TransactionProcess(request: req, parserType: Category.self)
        categoryTransac?.push(process)
        categoryTransac?.commit()
    }
    
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
