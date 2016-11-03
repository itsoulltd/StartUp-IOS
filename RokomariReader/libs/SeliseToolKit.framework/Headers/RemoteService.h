//
//  DyanaService.h
//  RequestSynchronizer
//
//  Created by Towhid Islam on 5/1/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import "RemoteServiceProtocol.h"
#import "CommunicationHeader.h"
#import "NetworkActivityController.h"

@class DNObject;
@class DNRequest;
@class DNFileUploadRequest;
@class FailureMessage;

typedef void(^SuccessHandler)(NSArray* items);
typedef void(^UnsuccessHandler)(FailureMessage* message,NSError* error);

@interface RemoteService : NSObject <RemoteServiceProtocol>
- (Class) getRegisteredParser;
- (void) registerParserClassName:(NSString*)className;
- (void) sendAsynchronusMessage:(DNRequest*)capsul whenSuccess:(SuccessHandler)success whenUnsuccess:(UnsuccessHandler)failure;
- (void) sendAsynchronusMessage:(DNRequest*)capsul onDispatchQueue:(dispatch_queue_t)queue whenSuccess:(SuccessHandler)success whenUnsuccess:(UnsuccessHandler)failure;
- (SuccessHandler) getSucessHandler;
- (UnsuccessHandler) getUnsuccessHandler;
@end
