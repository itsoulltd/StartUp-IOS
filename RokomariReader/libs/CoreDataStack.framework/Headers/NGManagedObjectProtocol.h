//
//  DyanaManagedObjectProtocol.h
//  CoreDataTest
//
//  Created by Towhid Islam on 4/12/14.
//  Copyright (c) 2017 Next Generation Object Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGObjectProtocol.h"

@protocol NGManagedObjectProtocol <NGObjectProtocol>
@optional
+ (instancetype) insertIntoContext:(NSManagedObjectContext *)context withProperties:(NSDictionary*)properties;
+ (instancetype) insertIntoContext:(NSManagedObjectContext *)context withJSON:(NSData*)json;
@end
