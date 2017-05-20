//
//  SessionHandler.h
//  NGStackToolKitProject
//
//  Created by Towhid Islam on 9/13/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionHandler : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>{
    NSInteger _backgroundTaskCounter;
}
- (void) increaseCounter;
- (void) decreaseCounter;
- (BOOL) isAllTaskDone;
- (void) executeCompletionHandlerFor:(NSURLSession*)session;
@property (nonatomic, weak) NSMutableDictionary* taskMapper;
@property (nonatomic, weak) NSMutableDictionary* responseDataMapper;
@property (nonatomic, weak) NSMutableDictionary *completionHandlerDictionary;
@end
