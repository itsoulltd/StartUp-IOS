//
//  ConnectionHandler.h
//  NGStackToolKitProject
//
//  Created by Towhid Islam on 9/13/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentDelegate.h"
#import "CommunicationHeader.h"

@class HttpWebRequest;

@interface ConnectionHandler : NSObject <NSURLConnectionDataDelegate>
@property (nonatomic, strong) id <ContentDelegate> progressDelegate;
@property (nonatomic, strong) HttpWebRequest *capsul;
@property (nonatomic, copy) CompletionHandler completionHandler;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) ContentHandler *uploadHandler;
@property (nonatomic, strong) ContentHandler *downloadHandler;
- (void) whenProgressFailedWithError:(NSError*)error;
@end
