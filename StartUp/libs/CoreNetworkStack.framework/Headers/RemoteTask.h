//
//  AbstructRemoteTask.h
//  RequestSynchronizer
//
//  Created by Towhid Islam on 8/17/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunicationHeader.h"
#import "ContentDelegate.h"

@class HttpWebRequest;
@class HttpFileRequest;
@class ContentHandler;

@interface RemoteTask : NSObject
@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong) HttpWebRequest *capsul;
@property (nonatomic, strong) dispatch_queue_t queue;
- (void) cancelTask;
@end

@interface RemoteDataTask : RemoteTask
@property (nonatomic, copy) CompletionHandler completionHandler;
@end

@interface RemoteUploadTask : RemoteDataTask
@property (nonatomic, strong) NSURL *tempLocalFileURL;
@property (nonatomic, strong) id <ContentDelegate> progressDelegate;
@property (nonatomic, strong) ContentHandler *uploadHandler;
- (instancetype) initWithNetCapsulBinary:(HttpFileRequest*)binary;
@end

@interface RemoteDownloadTask : RemoteTask
@property (nonatomic, strong) NSData *resumeable;
@property (nonatomic, copy) DownloadCompletionHandler completionHandler;
@property (nonatomic, strong) id <ContentDelegate> progressDelegate;
@property (nonatomic, strong) ContentHandler *downloadHandler;
@end
