//
//  Response.swift
//  RokomariReader
//
//  Created by Towhid Islam on 10/30/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

/*{
    "message": "error.validation",
    "description": null,
    "fieldErrors": [
        {
            "objectName": "managedUserVM",
            "field": "email",
            "message": "Email"
        },
        {
            "objectName": "managedUserVM",
            "field": "langKey",
            "message": "Size"
        }
    ]
}*/

public class Response: DNObject {
    
    required override public init(){
        super.init()
    }
    
    required override public init!(info: [NSObject : AnyObject]!) {
        super.init(info: info)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var id: NSString = NSUUID().UUIDString
    var failed: Bool{
        return (code.rawValue == HttpStatusCode.OK.rawValue || code.rawValue == HttpStatusCode.Created.rawValue) ? true : false
    }
    var code: HttpStatusCode = HttpStatusCode.NotFound {
        didSet{
            if code.rawValue == HttpStatusCode.Unauthorized.rawValue  {
                NSNotificationCenter.defaultCenter().postNotificationName(Notifications.UserLogout, object: nil)
            }
        }
    }
    var errorMessage: NSString?
    var message: NSString?
    var description_rokomari: NSString?
    var fieldErrors: [FieldError] = [FieldError]()
    
    func handleHttpResponse(response: NSURLResponse?, error: NSError?){
        if let res = response as? NSHTTPURLResponse{
            code = HttpStatusCode(rawValue: res.statusCode)!
        }
        if let err = error {
            errorMessage = err.debugDescription
        }
    }
    
    override public func updateValue(value: AnyObject!, forKey key: String!) {
        if key == "description" {
            description_rokomari = value as? NSString
        }
        else if key == "fieldErrors"{
            if value is NSArray {
                let vals = value as! [[String:AnyObject]]
                for item in vals {
                    fieldErrors.append(FieldError(info: item))
                }
            }
        }
        else{
            super.updateValue(value, forKey: key)
        }
    }
}


class FieldError: DNObject {
    var objectName: NSString?
    var field: NSString?
    var message: NSString?
}
