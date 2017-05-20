//
//  MultiDataContextManager.h
//  RequestSynchronizer
//
//  Created by Towhid Islam on 7/18/14.
//  Copyright (c) 2017 Next Generation Object Ltd. All rights reserved.
//

#import "NGCoreDataContext.h"

@interface NGKeyedContext : NGCoreDataContext
+ (instancetype) sharedInstance;
- (NSManagedObjectContext*) contextForKey:(NSString*)key;
- (NSManagedObjectContext*) cloneContextForKey:(NSString*)key;
- (void)saveContextForKey:(NSString*)key;
- (void)mergeContextForKey:(NSString*)key fromContext:(NSManagedObjectContext*)context;
@end
