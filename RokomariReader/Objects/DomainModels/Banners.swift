//
//  Banners.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/3/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import SeliseToolKit

public class Banners: DNObject{
    
    private var transaction: TransactionStack?
    func fetch(query: Query, onCompletion:(([Banner]) -> Void)) -> Void{
        var request: DNRequest?
        if query is SearchQuery {
            request = RequestFactory.defaultFactory().request(forKey: "")
        }else{
            request = RequestFactory.defaultFactory().request(forKey: "")
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
        let process = TransactionProcess(request: req, parserType: Banner.self)
        transaction?.push(process)
        transaction?.commit()
    }
    
}

public class Banner: NameResource{
    var image: NSString?
    var link: NSString?
    var name: NSString?
    var position: NSNumber?
    var type: NSString?
    
}

public class BannerQuery: Query{
    var type: NSString?
    var status: NameResource?
}

