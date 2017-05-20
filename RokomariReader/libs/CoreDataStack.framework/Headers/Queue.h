//
//  Queue.h
//  RequestSynchronizer
//
//  Created by m.towhid.islam@gmail.com on 4/15/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Queue : NSObject <NSCoding, NSCopying>
- (void) enqueue:(id)item;
- (id) dequeue;
- (void) printQueue;
- (BOOL)isEmpty;
@end
