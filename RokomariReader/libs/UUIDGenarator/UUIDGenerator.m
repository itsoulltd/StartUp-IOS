//
//  UUIDGenerator.m
//  Laplazo
//
//  Created by Selise on 5/6/14.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

#import "UUIDGenerator.h"
#import <UIKit/UIKit.h>

@implementation UUIDGenerator

+ (NSString *)deviceUUID{
    
    NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
    //Access KeyChain to retrive previous device uuid.
    //If there is no stored uuid for this app(unique-identifier like e.g ch.selise.laplazo), then return generated uuid.
    //If there is any then try to match with the generated uuid.
    //if matched then return generated uuid.
    //if not then return the previous uuid, which was saved last time in keychain.
    NSString *returnValue = [uuid UUIDString];
    NSString *matchingKey = [KeychainWrapper keychainStringFromMatchingIdentifier:[UUIDGenerator appBundleIdentifier]];
    if (matchingKey) {
        returnValue = matchingKey;
    }else{
        [KeychainWrapper createKeychainValue:returnValue forIdentifier:[UUIDGenerator appBundleIdentifier]];
    }
    
    return returnValue;
}

+ (NSString*) appBundleIdentifier{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *key = (__bridge NSString*)kCFBundleIdentifierKey;
    return [infoDic objectForKey:key];
}

@end
