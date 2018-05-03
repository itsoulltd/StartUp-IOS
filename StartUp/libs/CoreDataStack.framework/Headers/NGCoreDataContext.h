//
//  CoreDataContextManager.h
//  CoreDataTest
//
//  Created by Towhid Islam on 1/25/14.
//  Copyright (c) 2017 Next Generation Object Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString* const KGDefaultManagedContextDidMergeNotification;

#define kInsertedIDs @"inserted-IdKey"
#define kUpdatedIDs @"updated-IdKey"
#define kDeletedIDs @"deleted-IdKey"

@interface NGCoreDataContext : NSObject

+ (instancetype) sharedInstance;
@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, readonly) NSString *defaultModelFileName;
- (NSManagedObjectContext*) defaultContext;
- (NSManagedObjectContext*) cloneDefaultContext;
- (void)saveDefaultContext;
- (void)saveContext:(NSManagedObjectContext*)context;
- (void)mergeDefaultContextFromContext:(NSManagedObjectContext*)context;
-(NSManagedObjectContext*) createFromDataModelFileName:(NSString*)name;
@end
