//
//  RequestFactory.swift
//  Jamahook
//
//  Created by Towhid on 11/4/15.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import SeliseToolKit

public class RequestMetadata: DNObject{
    
    var httpMethod: HTTP_METHOD!
    var contentType: Application_ContentType!
    var routePath: NSString?
    var pathParams: [String]?
    
    public override func updateValue(value: AnyObject!, forKey key: String!) {
        if key == "httpMethod"{
            if ((value as! String).lowercaseString == "post"){
                httpMethod = POST
            }
            else{
                httpMethod = GET
            }
        }
        else if key == "contentType"{
            if ((value as! String).lowercaseString == "json"){
                contentType = Application_JSON
            }
            else if ((value as! String).lowercaseString == "multipart"){
                contentType = Application_Multipart_FormData
            }
            else{
                contentType = Application_Form_URLEncoded
            }
        }
        else if(key == "pathParams"){
            if value is NSArray{
                pathParams = (value as! NSArray) as? [String]
            }
        }
        else{
            super.updateValue(value, forKey: key)
        }
    }
    
    public override func serializeValue(value: AnyObject!, forKey key: String!) -> AnyObject! {
        if key == "httpMethod"{
            if httpMethod == POST{
                return "post"
            }
            else{
                return "get"
            }
        }
        else if key == "contentType"{
            if contentType == Application_JSON{
                return "json"
            }
            else if contentType == Application_Multipart_FormData{
                return "multipart"
            }
            else {
                return "urlencoded"
            }
        }
        else if key == "pathParams"{
            if let pathParams = self.pathParams{
                return pathParams as NSArray
            }else{
                return nil
            }
        }
        else{
            return super.serializeValue(value, forKey: key)
        }
    }
    
}


public class DNRequestFactory: NSObject{
    
    var propertyList: PropertyList!
    
    public required init(configFileName fileName: String) {
        super.init()
        propertyList = PropertyList(fileName: fileName, directoryType: NSSearchPathDirectory.DocumentDirectory, dictionary: true)
    }
    
    public final func getProperty(forKey key: String) -> AnyObject{
        return propertyList.itemForKey(key)
    }
    
    func httpReferrerHeaderValue() -> [String]{
        let str = getProperty(forKey: "Referer") as! String
        return [str]
    }
    
    func isLiveUrlActive() -> Bool{
        let isLive = getProperty(forKey: "ActiveLive") as! Bool
        return isLive
    }
    
    func activeURL() -> NSURL{
        let baseUrlStr = activeURLString()
        let url = NSURL(string: baseUrlStr)!
        return url
    }
    
    func activeURLString() -> String{
        let activeUrl = isLiveUrlActive() ? "LiveUrl" : "StagingUrl"
        let baseUrlStr = getProperty(forKey: activeUrl) as! String
        return baseUrlStr
    }
    
    func pingURLString() -> String{
        let url = getProperty(forKey: "PingUrl") as! String
        return url
    }
    
    final func validateUrlStr(urlStr: String) -> String{
        let uNSStr = urlStr as NSString
        //let result = uNSStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let result = uNSStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
        return result!
    }
    
    final func metadata(forKey key: String) -> RequestMetadata?{
        if let meta = getProperty(forKey: key) as? NSDictionary{
            let metadata = RequestMetadata(info: meta as [NSObject : AnyObject])
            return metadata
        }
        return nil
    }
    
    func requestURL(forKey key: String) -> NSURL?{
        if let metadata = metadata(forKey: key){
            var validated: String = activeURLString()
            if let routePath = metadata.routePath{
                validated = "\(validated)/\(routePath)"
            }
            if let pathParams = metadata.pathParams{
                let combined = pathParams.joinWithSeparator("/")
                validated = "\(validated)/\(combined)"
            }
            return NSURL(string: validateUrlStr(validated))
        }
        return nil
    }
    
    func request(forKey key: String, classType: DNRequest.Type = DNXRequest.self) -> DNRequest?{
        if let metadata = metadata(forKey: key){
            var request: DNRequest? = nil
            if let routePath = metadata.routePath{
                let validated = validateUrlStr("\(activeURLString())/\(routePath)")
                request = classType.init(baseUrl: validated, method: metadata.httpMethod, contentType: metadata.contentType)
            }
            else{
                request = classType.init(baseUrl: activeURLString(), method: metadata.httpMethod, contentType: metadata.contentType)
            }
            if let pathParams = metadata.pathParams{
                request?.pathComponent = pathParams
            }
            request?.requestHeaderFields.addValues(httpReferrerHeaderValue(), forKey: "Referer")
            return request
        }
        return nil
    }
    
}