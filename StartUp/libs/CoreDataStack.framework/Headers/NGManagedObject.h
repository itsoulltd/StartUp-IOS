//
//  DyanaManagedObject.h
//  CoreDataTest
//
//  Created by Towhid Islam on 4/12/14.
//  Copyright (c) 2017 Next Generation Object Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NGManagedObjectProtocol.h"

@interface NGManagedObject : NSManagedObject <NGManagedObjectProtocol>
- (instancetype)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context updateWithInfo:(NSDictionary*)info;
- (instancetype)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context updateWithJSON:(NSData*)json;
@end
