//
//  AsynchImagePrefetcher.h
//  NGAppKit
//
//  Created by Towhid Islam on 11/16/17.
//  Copyright © 2018 ITSoulLab(http://itsoullab.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsynchImage.h"

typedef void(^AsynchPrefetchOnCompletion)(BOOL complete);

@interface ImagePrefetcher : NSObject
+ (instancetype) shared;
- (void) prefetch:(NSArray<AsynchImage*>*)itemsToPrefetch onCompletion:(AsynchPrefetchOnCompletion)handler;
@end
