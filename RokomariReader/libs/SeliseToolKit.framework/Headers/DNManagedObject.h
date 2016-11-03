//
//  DyanaManagedObject.h
//  CoreDataTest
//
//  Created by Towhid Islam on 4/12/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DNManagedObjectProtocol.h"
#import "DebugLog.h"
#import "ExceptionLog.h"

@interface DNManagedObject : NSManagedObject <DNManagedObjectProtocol>
- (instancetype)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context updateWithInfo:(NSDictionary*)info;
- (instancetype)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context updateWithJSON:(NSData*)json;
@end
