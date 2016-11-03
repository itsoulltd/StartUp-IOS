//
//  RemoteObject.h
//  RequestSynchronizer
//
//  Created by Towhid Islam on 7/7/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunicationHeader.h"
#import "ContentProgressDelegate.h"

@class DNRequest;
@class ConnectionDelegateHandler;

@interface RemoteConnection : NSObject
@property (nonatomic, strong) id <ContentProgressDelegate> progressDelegate;
- (instancetype) initWithConnectionDelegate:(ConnectionDelegateHandler*)handler;
- (void) sendAsynchronusMessage:(DNRequest*)capsul onCompletion:(CompletionHandler)completion;
- (void) sendAsynchronusMessage:(DNRequest*)capsul onDispatchQueue:(dispatch_queue_t)queue onCompletion:(CompletionHandler)completion;
- (void) cancelRemoteMessage;
- (void) sendSynchronusMessage:(DNRequest*)capsul onCompletion:(CompletionHandler)completion;
- (CompletionHandler) getCompletionHandler;
@end
