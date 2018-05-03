//
//  SessionedRemoteObject.h
//  RequestSynchronizer
//
//  Created by Towhid Islam on 7/7/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import "RemoteSessionProtocol.h"
#import "CommunicationHeader.h"

@class NGObject;
@class HttpWebRequest;
@class HttpFileRequest;
@class RemoteDataTask;
@class RemoteDownloadTask;
@class RemoteUploadTask;
@class ContentHandler;
@class SessionHandler;

@interface RemoteSession : NSObject <RemoteSessionProtocol>
@property (readonly) NSURLSession *backgroundSession;
@property (readonly) NSURLSession *basicSession;
@property (readonly) NSURLSession *utilitySession;
@property (readonly) SessionHandler *delegateHandler;
@property (readonly) NSMutableDictionary *taskMapper;
@property (readonly) NSMutableDictionary *responseDataMapper;
@property (readonly) NSMutableDictionary *completionHandlerDictionary;
+ (instancetype) defaultSession;
- (instancetype)initWithBackgroundSessionIdentifier:(NSString*)identifier;
- (instancetype)initWithBackgroundSessionIdentifier:(NSString*)identifier andSessionDelegate:(SessionHandler*)handler;
- (RemoteDownloadTask*) resumeDownloadFrom:(RemoteDownloadTask*)task;
- (void) addCompletionHandler: (CompletionHandlerType) handler forSession: (NSString *)identifier;
- (void) addCompletionHandler: (CompletionHandlerType) handler forSession: (NSString *)identifier andSessionDelegate:(SessionHandler*)sessionDelegate;
- (void) setupCachePolicy:(NSURLSessionConfiguration*)configuration directory:(NSString*)directoryPath;
@end
