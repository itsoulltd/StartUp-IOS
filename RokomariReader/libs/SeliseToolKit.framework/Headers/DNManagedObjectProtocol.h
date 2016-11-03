//
//  DyanaManagedObjectProtocol.h
//  CoreDataTest
//
//  Created by Towhid Islam on 4/12/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNObjectProtocol.h"

@protocol DNManagedObjectProtocol <DNObjectProtocol>
@optional
+ (instancetype) insertIntoContext:(NSManagedObjectContext *)context withProperties:(NSDictionary*)properties;
+ (instancetype) insertIntoContext:(NSManagedObjectContext *)context withJSON:(NSData*)json;
@end
