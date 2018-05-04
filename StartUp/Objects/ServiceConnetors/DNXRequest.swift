//
//  DNXRequest.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 11/11/15.
//  Copyright © 2018 ITSoulLab (https://www.itsoullab.com). All rights reserved.
//

import Foundation
import CoreDataStack
import CoreNetworkStack

extension HttpWebRequest{
    
    /**
     Call this method to remove cookies for a specific URL.
     */
    class func removeCookie(forURL url: NSURL){
        if let cookies = HTTPCookieStorage.shared.cookies(for: url as URL){
            for cookie in cookies{
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    func addAuth(){
        let userMan = AppRouter.shared().getAccount()
        guard let accessToken = userMan.oauth.token else{
            print("token is empty")
            return
        }
        let auth = "Bearer \(accessToken)"
        self.requestHeaderFields.addValues([auth], forKey: "Authorization")
    }
    
}

open class DNXRequest: HttpWebRequest{
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public required override init!(baseUrl: String!, method httpMethod: HTTP_METHOD, contentType: Application_ContentType) {
        super.init(baseUrl: baseUrl, method: httpMethod, contentType: contentType)
    }
    
    public required override init!(baseUrl: String!, method httpMethod: HTTP_METHOD, contentType: Application_ContentType, cachePolicy policy: NSURLRequest.CachePolicy) {
        super.init(baseUrl: baseUrl, method: httpMethod, contentType: contentType, cachePolicy: policy)
    }
    
    open override func httpRequestConfiguration(_ request: NSMutableURLRequest!) {
        request.httpShouldHandleCookies = true
    }
    
}

open class DNXFileUploadRequest: HttpFileRequest{
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public required override init!(baseUrl: String!, method httpMethod: HTTP_METHOD, contentType: Application_ContentType) {
        super.init(baseUrl: baseUrl, method: httpMethod, contentType: Application_Multipart_FormData)
    }
    
    public required override init!(baseUrl: String!, method httpMethod: HTTP_METHOD, contentType: Application_ContentType, cachePolicy policy: NSURLRequest.CachePolicy) {
        super.init(baseUrl: baseUrl, method: httpMethod, contentType: contentType, cachePolicy: policy)
    }
    
    open override func httpRequestConfiguration(_ request: NSMutableURLRequest!) {
        request.httpShouldHandleCookies = true
    }
    
}
