//
//  RNCryptorHelper.m
//  StartupProjectSampleA
//
//  Created by Towhid on 8/25/15.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

#import "RNCryptorHelper.h"

@implementation RNCryptorHelper

+ (RNEncryptor *)encryptorWithKey:(NSString *)key handler:(RNCryptorHandler)handler{
    RNEncryptor *encryptor = [[RNEncryptor alloc] initWithSettings:kRNCryptorAES256Settings password:key handler:handler];
    return encryptor;
}

+ (NSData *)encrypt:(NSData *)data withKey:(NSString *)key{
    //
    NSError* error;
    NSData* encypted = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:key error:&error];
    if (error != nil) {
        NSLog(@"%@",[error debugDescription]);
    }
    return encypted;
}

+ (RNDecryptor *)decryptorWithKey:(NSString *)key handler:(RNCryptorHandler)handler{
    RNDecryptor *decryptor = [[RNDecryptor alloc] initWithPassword:key handler:handler];
    return decryptor;
}

+ (NSData *)decrypt:(NSData *)cipher withKey:(NSString *)key{
    //
    NSError* error;
    NSData* decypted = [RNDecryptor decryptData:cipher withPassword:key error:&error];
    if (error != nil) {
        NSLog(@"%@",[error debugDescription]);
    }
    return decypted;
}

+ (NSData *)keyForPassword:(NSString *)password salt:(NSData *)salt{
    
    RNCryptorKeyDerivationSettings keySettings = {
        .keySize = kCCKeySizeAES256,
        .saltSize = 8,
        .PBKDFAlgorithm = kCCPBKDF2,
        .PRF = kCCPRFHmacAlgSHA1,
        .rounds = 10000
    };
    
    NSData* result = [RNCryptor keyForPassword:password salt:salt settings:keySettings];
    return result;
}

@end
