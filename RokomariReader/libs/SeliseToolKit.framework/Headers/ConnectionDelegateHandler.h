//
//  ConnectionDelegateHandler.h
//  SeliseToolKitProject
//
//  Created by Towhid Islam on 9/13/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentProgressDelegate.h"
#import "CommunicationHeader.h"

@class DNRequest;

@interface ConnectionDelegateHandler : NSObject <NSURLConnectionDataDelegate>
@property (nonatomic, strong) id <ContentProgressDelegate> progressDelegate;
@property (nonatomic, strong) DNRequest *capsul;
@property (nonatomic, copy) CompletionHandler completionHandler;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) ContentProgressHandler *uploadHandler;
@property (nonatomic, strong) ContentProgressHandler *downloadHandler;
- (void) whenProgressFailedWithError:(NSError*)error;
@end
