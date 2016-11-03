//
//  DNXRequest.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 11/11/15.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import SeliseToolKit

extension DNRequest{
    
    /**
     Call this method to remove cookies for a specific URL.
     */
    class func removeCookie(forURL url: NSURL){
        if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(url){
            for cookie in cookies{
                NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
            }
        }
    }
    
    func addAuth(){
        let userMan = UserManagement(profileType: UserProfile.self)
        guard let accessToken = userMan.oauth.token else{
            print("token is empty")
            return
        }
        let auth = "Bearer \(accessToken)"
        self.requestHeaderFields.addValues([auth], forKey: "Authorization")
    }
    
}

public class DNXRequest: DNRequest{
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public required override init!(baseUrl: String!, method httpMethod: HTTP_METHOD, contentType: Application_ContentType) {
        super.init(baseUrl: baseUrl, method: httpMethod, contentType: contentType)
    }
    
    public required override init!(baseUrl: String!, method httpMethod: HTTP_METHOD, contentType: Application_ContentType, cachePolicy policy: NSURLRequestCachePolicy) {
        super.init(baseUrl: baseUrl, method: httpMethod, contentType: contentType, cachePolicy: policy)
    }
    
    public override func httpRequestConfiguration(request: NSMutableURLRequest!) {
        request.HTTPShouldHandleCookies = true
    }
    
}

public class DNXFileUploadRequest: DNFileUploadRequest{
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public required override init!(baseUrl: String!, method httpMethod: HTTP_METHOD, contentType: Application_ContentType) {
        super.init(baseUrl: baseUrl, method: httpMethod, contentType: Application_Multipart_FormData)
    }
    
    public required override init!(baseUrl: String!, method httpMethod: HTTP_METHOD, contentType: Application_ContentType, cachePolicy policy: NSURLRequestCachePolicy) {
        super.init(baseUrl: baseUrl, method: httpMethod, contentType: contentType, cachePolicy: policy)
    }
    
    public override func httpRequestConfiguration(request: NSMutableURLRequest!) {
        request.HTTPShouldHandleCookies = true
    }
    
}
