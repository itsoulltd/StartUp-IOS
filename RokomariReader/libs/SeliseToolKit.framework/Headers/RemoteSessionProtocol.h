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
#import "SessionDelegateHandler.h"

@protocol RemoteSessionProtocol <NSObject>
@required
- (NSURLSession*) createBackgroundSessionWithIdentifier:(NSString*)identifier andSessionDelegate:(SessionDelegateHandler*)handler;
- (RemoteDataTask*) sendMessage:(DNRequest*)capsul onCompletion:(CompletionHandler)completion;
- (RemoteDataTask*) sendMessage:(DNRequest*)capsul onDispatchQueue:(dispatch_queue_t)queue onCompletion:(CompletionHandler)completion;
@optional
- (RemoteDataTask*) sendUtilityMessage:(DNRequest*)capsul onCompletion:(CompletionHandler)completion;
- (RemoteDataTask*) sendUtilityMessage:(DNRequest*)capsul onDispatchQueue:(dispatch_queue_t)queue onCompletion:(CompletionHandler)completion;
- (RemoteUploadTask*) uploadContent:(DNFileUploadRequest*)capsul progressDelegate:(id<ContentProgressDelegate>)delegate onCompletion:(CompletionHandler)completion;
- (RemoteUploadTask*) uploadContent:(DNFileUploadRequest*)capsul progressDelegate:(id<ContentProgressDelegate>)delegate onDispatchQueue:(dispatch_queue_t)queue onCompletion:(CompletionHandler)completion;
- (RemoteDownloadTask*) downloadContent:(DNRequest*)capsul progressDelegate:(id<ContentProgressDelegate>)delegate onCompletion:(DownloadCompletionHandler)completion;
@end

#endif
