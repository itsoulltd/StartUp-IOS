//
//  ContentProgressDelegate.h
//  RequestSynchronizer
//
//  Created by Towhid on 9/3/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import "ContentProgressHandler.h"

#ifndef RequestSynchronizer_ContentProgressDelegate_h
#define RequestSynchronizer_ContentProgressDelegate_h
@protocol ContentProgressDelegate <NSObject>
@optional
- (void) progressHandler:(ContentProgressHandler*)handler uploadPercentage:(float)percentage;
- (void) progressHandler:(ContentProgressHandler*)handler downloadPercentage:(float)percentage;
- (void) progressHandler:(ContentProgressHandler*)handler didFailedWithError:(NSError*)error;
@end

#endif
