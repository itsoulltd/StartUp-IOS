//
//  UUIDGenerator.h
//  Laplazo
//
//  Created by Selise on 5/6/14.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainWrapper.h"

@interface UUIDGenerator : NSObject
+ (NSString*) deviceUUID;
+ (NSString*) appBundleIdentifier;
@end
