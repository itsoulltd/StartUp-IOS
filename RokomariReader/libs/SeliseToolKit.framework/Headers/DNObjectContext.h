//
//  CoreDataContextManager.h
//  CoreDataTest
//
//  Created by Towhid Islam on 1/25/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString* const AppDefaultContextDidMergeNotification;

#define kInsertedIdKey @"inserted-IdKey"
#define kUpdatedIdKey @"updated-IdKey"
#define kDeletedIdKey @"deleted-IdKey"

@interface DNObjectContext : NSObject

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
