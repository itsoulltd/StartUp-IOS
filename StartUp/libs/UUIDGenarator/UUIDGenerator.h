//
//  UUIDGenerator.h
//  Laplazo
//
//  Created by Selise on 5/6/14.
//  Copyright © 2018 ITSoulLab (https://www.itsoullab.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainWrapper.h"

@interface UUIDGenerator : NSObject
+ (NSString*) deviceUUID;
+ (NSString*) appBundleIdentifier;
@end
