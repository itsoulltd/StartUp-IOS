//
//  QueueManager.h
//  NGOperationQueue
//
//  Created by Towhid Islam on 6/10/17.
//  Copyright © 2017 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OperationGroup.h"
#import "AsynchOperation.h"

extern NSNotificationName const QueueManagerOperationStatusNotification;

typedef enum : NSUInteger {
    QueueManagerStatusDone,
    QueueManagerStatusStop,
    QueueManagerStatusSuspend,
    QueueManagerStatusRunning
} QueueManagerStatus;

@interface QueueManager : NSObject
@property (nonatomic, readonly) NSString *identifier;
- (instancetype) initWithIdentifier:(NSString*)identifier maxConcurentItem:(NSInteger)count;
- (void) runGroup:(OperationGroup*)group;
- (void) runOperation:(AsynchOperation*)opt;
@property (nonatomic, assign) QueueManagerStatus status;
- (void) suspend;
- (void) resume;
- (void) cancelGroups:(NSArray<NSString*>*)identifiers;
@end
