//
//  AppInfo.h
//  StartUpProject
//
//  Created by Towhidul Islam on 12/20/16.
//  Copyright © 2016 Kite Games Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AppInfoKeys) {
    MainStoryboardName,
    BundleName,
    BundleDisplayName,
    BundleIdentifier,
    Version,
    BuildVersion
};

@interface AppInfo : NSObject

- (NSString*) stringValueForKey:(AppInfoKeys)key;
- (NSNumber*) numberValueForKey:(AppInfoKeys)key;

@end
