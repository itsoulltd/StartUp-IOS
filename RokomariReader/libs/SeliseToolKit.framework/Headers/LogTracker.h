//
//  LogTracker.h
//  RequestSynchronizer
//
//  Created by Towhid Islam on 8/25/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DNFileUploadRequest;
@interface LogTracker : NSObject
- (instancetype) initWithPersistenceFileName:(NSString*)fileName;
- (void) save;
- (void) printSavedLog;
- (void) sendFeedbackTo:(DNFileUploadRequest*)binary;
- (void) addToLogBook:(NSString*)log;
@end
