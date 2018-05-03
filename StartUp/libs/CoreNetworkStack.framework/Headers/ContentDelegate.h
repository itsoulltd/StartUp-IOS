//
//  ContentDelegate.h
//  RequestSynchronizer
//
//  Created by Towhid on 9/3/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import "ContentHandler.h"

#ifndef RequestSynchronizer_ContentDelegate_h
#define RequestSynchronizer_ContentDelegate_h
@protocol ContentDelegate <NSObject>
@optional
- (void) progressHandler:(ContentHandler*)handler uploadPercentage:(float)percentage;
- (void) progressHandler:(ContentHandler*)handler downloadPercentage:(float)percentage;
- (void) progressHandler:(ContentHandler*)handler didFailedWithError:(NSError*)error;
@end

#endif
