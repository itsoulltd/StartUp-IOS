//
//  EBookSearch.swift
//  RokomariReader
//
//  Created by Towhid Islam on 11/26/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import CoreDataStack
import CoreNetworkStack
import WebServiceKit

open class BookLibrary: NGObject {
    
    var searchResult: [SearchQuery:[Book]] = [SearchQuery:[Book]]()
    var fetchResult: [Query:[Book]] = [Query:[Book]]()
    
    var categoryResults: [Query: [Category]] = [Query: [Category]]()
    
    fileprivate var searchBooks: TransactionStack?
    open func search(_ query: SearchQuery, onCompletion: @escaping (([Book]) -> Void)) -> Void {
        guard let request = ServiceBroker.defaultFactory().request(forKey: "SearchEBooks") else{
            fatalError("SearchEBooks not available")
        }
        
        searchBooks = TransactionStack(callBack: { [weak self] (received) in
            guard let res = received as? [Book] else{
                onCompletion([Book]())
                return
            }
            self?.searchResult[query] = res
            onCompletion(res)
        })
        
        request.addAuth()
        request.payLoad = query
        let process = Transaction(request: request, parserType: Book.self)
        searchBooks?.push(process)
        searchBooks?.commit()
    }
    
    fileprivate var fetchBooks: TransactionStack?
    open func fetch(_ query: Query, onCompletion: @escaping (([Book]) -> Void)) -> Void {
        guard let request = ServiceBroker.defaultFactory().request(forKey: "GetAllEBooks") else{
            fatalError("GetAllEBooks not available")
        }
        
        fetchBooks = TransactionStack(callBack: { [weak self] (received) in
            guard let res = received as? [Book] else{
                onCompletion([Book]())
                return
            }
            self?.fetchResult[query] = res
            onCompletion(res)
        })
        
        request.addAuth()
        request.payLoad = query
        let process = Transaction(request: request, parserType: Book.self)
        fetchBooks?.push(process)
        fetchBooks?.commit()
    }
    
    fileprivate var categoryTransac: TransactionStack?
    open func categories(_ query: Query, onCompletion: @escaping (([Category]) -> Void)) -> Void{
        var request: HttpWebRequest?
        if query is SearchQuery {
            request = ServiceBroker.defaultFactory().request(forKey: "SearchCategories")
        }else{
            request = ServiceBroker.defaultFactory().request(forKey: "GetAllCategories")
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
        let process = Transaction(request: req, parserType: Category.self)
        categoryTransac?.push(process)
        categoryTransac?.commit()
    }
    
    fileprivate var bookTrans: TransactionStack?
    open func ebook(by id: NSNumber, onCompletion: @escaping ((Book?) -> Void)) -> Void{
        guard let request = ServiceBroker.defaultFactory().request(forKey: "GetEBook") else{
            fatalError("GetEBook not found")
        }
        
        request.addAuth()
        request.payLoad = NGObject(info: ["id":id.int64Value])
        
        bookTrans = TransactionStack(callBack: { (received) in
            if let vm = received?.first as? Book{
                onCompletion(vm)
            }
        })
        
        let process = Transaction(request: request, parserType: Book.self)
        self.bookTrans?.push(process)
        self.bookTrans?.commit()
    }
    
}
