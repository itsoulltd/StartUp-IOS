//
//  RemoteObject.h
//  RequestSynchronizer
//
//  Created by Towhid Islam on 7/7/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunicationHeader.h"
#import "ContentDelegate.h"

@class HttpWebRequest;
@class ConnectionHandler;

@interface RemoteConnection : NSObject
@property (nonatomic, strong) id <ContentDelegate> progressDelegate;
- (instancetype) initWithConnectionDelegate:(ConnectionHandler*)handler;
- (void) sendAsynchronusMessage:(HttpWebRequest*)capsul onCompletion:(CompletionHandler)completion;
- (void) sendAsynchronusMessage:(HttpWebRequest*)capsul onDispatchQueue:(dispatch_queue_t)queue onCompletion:(CompletionHandler)completion;
- (void) cancelRemoteMessage;
- (void) sendSynchronusMessage:(HttpWebRequest*)capsul onCompletion:(CompletionHandler)completion;
- (CompletionHandler) getCompletionHandler;
@end
