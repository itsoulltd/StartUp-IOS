//
//  RNCryptorHelper.h
//  StartupProjectSampleA
//
//  Created by Towhid on 8/25/15.
//  Copyright (c) 2015 Towhid (Selise.ch). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNCryptor.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"

@interface RNCryptorHelper : NSObject
+ (RNEncryptor*) encryptorWithKey:(NSString*)key handler:(RNCryptorHandler)handler;
+ (NSData*) encrypt:(NSData*)data withKey:(NSString*)key;
+ (RNDecryptor*) decryptorWithKey:(NSString*)key handler:(RNCryptorHandler)handler;
+ (NSData*) decrypt:(NSData*)cipher withKey:(NSString*)key;
+ (NSData *)keyForPassword:(NSString *)password salt:(NSData *)salt;
@end
