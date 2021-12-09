//
//  UUIDGenerator.h
//  Laplazo
//
//  Created by Selise on 5/6/14.
//  Copyright (c) 2014 Towhidul Islam (http://itsoullab.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainWrapper.h"

@interface UUIDGenerator : NSObject
+ (NSString*) deviceUUID;
+ (NSString*) appBundleIdentifier;
@end
