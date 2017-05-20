//
//  RemoteSessionProtocol.h
//  RequestSynchronizer
//
//  Created by Towhid on 8/31/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#ifndef RequestSynchronizer_RemoteSessionProtocol_h
#define RequestSynchronizer_RemoteSessionProtocol_h

#import "RemoteTask.h"
#import "SessionHandler.h"

@protocol RemoteSessionProtocol <NSObject>
@required
- (NSURLSession*) createBackgroundSessionWithIdentifier:(NSString*)identifier andSessionDelegate:(SessionHandler*)handler;
- (RemoteDataTask*) sendMessage:(HttpWebRequest*)capsul onCompletion:(CompletionHandler)completion;
- (RemoteDataTask*) sendMessage:(HttpWebRequest*)capsul onDispatchQueue:(dispatch_queue_t)queue onCompletion:(CompletionHandler)completion;
@optional
- (RemoteDataTask*) sendUtilityMessage:(HttpWebRequest*)capsul onCompletion:(CompletionHandler)completion;
- (RemoteDataTask*) sendUtilityMessage:(HttpWebRequest*)capsul onDispatchQueue:(dispatch_queue_t)queue onCompletion:(CompletionHandler)completion;
- (RemoteUploadTask*) uploadContent:(HttpFileRequest*)capsul progressDelegate:(id<ContentDelegate>)delegate onCompletion:(CompletionHandler)completion;
- (RemoteUploadTask*) uploadContent:(HttpFileRequest*)capsul progressDelegate:(id<ContentDelegate>)delegate onDispatchQueue:(dispatch_queue_t)queue onCompletion:(CompletionHandler)completion;
- (RemoteDownloadTask*) downloadContent:(HttpWebRequest*)capsul progressDelegate:(id<ContentDelegate>)delegate onCompletion:(DownloadCompletionHandler)completion;
@end

#endif
