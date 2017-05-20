//
//  Banners.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/3/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import CoreDataStack
import CoreNetworkStack
import WebServiceKit

open class Banners: NGObject{
    
    fileprivate var transaction: TransactionStack?
    func fetch(_ query: Query, onCompletion:@escaping (([Banner]) -> Void)) -> Void{
        var request: HttpWebRequest?
        if query is SearchQuery {
            request = ServiceBroker.defaultFactory().request(forKey: "")
        }else{
            request = ServiceBroker.defaultFactory().request(forKey: "")
        }
        
        guard let req = request else{
            fatalError("Invalid Request Object at \(#line) \(#function)")
        }
        
        transaction = TransactionStack(callBack: { (received) in
            guard let res = received as? [Banner] else{
                onCompletion([Banner]())
                return
            }
            onCompletion(res)
        })
        
        req.addAuth()
        req.payLoad = query
        let process = Transaction(request: req, parserType: Banner.self)
        transaction?.push(process)
        transaction?.commit()
    }
    
}

open class Banner: NameResource{
    var image: NSString?
    var link: NSString?
    var name: NSString?
    var position: NSNumber?
    var type: NSString?
    
}

open class BannerQuery: Query{
    var type: NSString?
    var status: NameResource?
}

