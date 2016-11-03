//
//  DNCoreObject.h
//  StartupProjectSampleA
//
//  Created by Towhid Islam on 4/12/15.
//  Copyright (c) 2015 Towhid (Selise.ch). All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DNManagedObject.h"

typedef NS_ENUM(NSInteger, Match) {
    All,
    Any
};

typedef void (^SearchHandler)(NSFetchRequest *request);

@class DNCoreObject;

@protocol DNCoreObjectProtocol <NSObject>
+ (NSUInteger) rows:(NSManagedObjectContext*)context;
+ (NSArray*) read:(NSDictionary*)searchPaths context:(NSManagedObjectContext*)context;
- (void) write:(NSDictionary*)updateProperties;
@optional
+ (DNCoreObject*) readBy:(NSManagedObjectID*)managedId context:(NSManagedObjectContext*)context;
@end

@interface DNCoreObject : DNManagedObject <DNCoreObjectProtocol>
@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSDate *eventTimeStamp;
@property (nonatomic, retain) NSNumber *eventOrder;
@property (nonatomic, retain) NSString *eventRemarks;

+ (NSString*) entityName;
+ (NSPredicate*) predicateForKey:(NSString*)key value:(id)value;
+ (NSArray*) readUsing:(NSManagedObjectContext*)context sortDescriptors:(NSArray*)descriptors searchHandler:(SearchHandler)handler;
+ (DNCoreObject*) readByGuid:(NSString*)guid context:(NSManagedObjectContext*)context;
+ (void) write:(NSDictionary *)updateProperties whereGuid:(NSString *)guid context:(NSManagedObjectContext *)context;
+ (void) write:(NSDictionary *)updateProperties whereManagedID:(NSManagedObjectID *)ID context:(NSManagedObjectContext *)context;
+ (void) insert:(NSArray*)items context:(NSManagedObjectContext *)context;
@end
