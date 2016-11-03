//
//  AbstructRemoteTask.h
//  RequestSynchronizer
//
//  Created by Towhid Islam on 8/17/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunicationHeader.h"
#import "ContentProgressDelegate.h"

@class DNRequest;
@class DNFileUploadRequest;
@class ContentProgressHandler;

@interface RemoteTask : NSObject
@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong) DNRequest *capsul;
@property (nonatomic, strong) dispatch_queue_t queue;
- (void) cancelTask;
@end

@interface RemoteDataTask : RemoteTask
@property (nonatomic, copy) CompletionHandler completionHandler;
@end

@interface RemoteUploadTask : RemoteDataTask
@property (nonatomic, strong) NSURL *tempLocalFileURL;
@property (nonatomic, strong) id <ContentProgressDelegate> progressDelegate;
@property (nonatomic, strong) ContentProgressHandler *uploadHandler;
- (instancetype) initWithNetCapsulBinary:(DNFileUploadRequest*)binary;
@end

@interface RemoteDownloadTask : RemoteTask
@property (nonatomic, strong) NSData *resumeable;
@property (nonatomic, copy) DownloadCompletionHandler completionHandler;
@property (nonatomic, strong) id <ContentProgressDelegate> progressDelegate;
@property (nonatomic, strong) ContentProgressHandler *downloadHandler;
@end
