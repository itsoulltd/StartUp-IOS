//
//  EBookSearch.swift
//  RokomariReader
//
//  Created by Towhid Islam on 11/26/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

public class BookLibrary: DNObject {
    
    var searchResult: [SearchQuery:[EBook]] = [SearchQuery:[EBook]]()
    var fetchResult: [Query:[EBook]] = [Query:[EBook]]()
    
    var categoryResults: [Query: [Category]] = [Query: [Category]]()
    
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
    
    private var bookTrans: TransactionStack?
    public func ebook(by id: NSNumber, onCompletion: ((EBook?) -> Void)) -> Void{
        guard let request = RequestFactory.defaultFactory().request(forKey: "GetEBook") else{
            fatalError("GetEBook not found")
        }
        
        request.addAuth()
        request.payLoad = DNObject(info: ["id":id.longValue])
        
        bookTrans = TransactionStack(callBack: { (received) in
            if let vm = received?.first as? EBook{
                onCompletion(vm)
            }
        })
        
        let process = TransactionProcess(request: request, parserType: EBook.self)
        self.bookTrans?.push(process)
        self.bookTrans?.commit()
    }
    
}
