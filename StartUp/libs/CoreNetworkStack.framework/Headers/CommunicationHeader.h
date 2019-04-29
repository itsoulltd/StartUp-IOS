//
//  CommunicationHeader.h
//  RequestSynchronizer
//
//  Created by Towhid on 9/4/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#ifndef RequestSynchronizer_CommunicationHeader_h
#define RequestSynchronizer_CommunicationHeader_h

typedef enum : NSUInteger {
    POST,
    PUT,
    DELETE,
    GET
} HTTP_METHOD;

typedef enum: NSUInteger {
    Application_Form_URLEncoded,
    Application_JSON,
    Application_XML,
    Application_PLIST,
    Application_Multipart_FormData,
    Application_PlainText
    
}Application_ContentType;

typedef enum : NSUInteger {
    NetworkOperationError = 19991,
    NetworkOperationCancel = 19992,
    NetworkOperationUnreachable = 19993
} NetworkOperationCode;

typedef void(^CompletionHandler)(NSData* data, NSURLResponse *response, NSError* error);
typedef void(^DownloadCompletionHandler)(NSURL* savedURL, NSURLResponse *response, NSError* error);
typedef void (^CompletionHandlerType)();

#endif
