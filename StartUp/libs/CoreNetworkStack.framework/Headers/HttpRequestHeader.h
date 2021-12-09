//
//  AuthenticationInfo.h
//  RequestSynchronizer
//
//  Created by Towhid Islam on 5/17/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

@import CoreDataStack;

@interface HttpRequestHeader : NGObject
@property (nonatomic, setter=setEncodingEnabled:) BOOL isEncodingEnabled;
+ (instancetype)createAuthHeaderWithFields:(NSDictionary *)fields andKey:(NSString*)key;
+ (instancetype)createAuthHeaderWithValues:(NSArray *)values andKey:(NSString*)key;
- (void) addValues:(NSArray*)values forKey:(NSString*)key;
- (void) addFields:(NSDictionary*)fields forKey:(NSString*)key;
- (void) mutateAuthenticationHeaderInfo:(NSMutableURLRequest*)request;
@end
