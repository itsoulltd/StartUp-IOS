//
//  DyanaObjectProtocol.h
//  RequestSynchronizer
//
//  Created by Towhid Islam on 4/4/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@protocol DNObjectProtocol <NSObject>
@required
- (void) updateWithInfo:(NSDictionary*)info;
- (void) updateValue:(id)value forKey:(NSString*)key;
- (NSDictionary*) serializeIntoInfo;
- (id) serializeValue:(id)value forKey:(NSString*)key;
- (NSString*) serializeDate:(NSDate*)date;
- (NSDate*) updateDate:(NSString*)dateStr;
@optional
- (void) updateWithJSON:(NSData*)json;
- (NSData*) serializeIntoJSON;
- (NSString*) serializeDate:(NSDate*)date forKey:(NSString*)key;
- (NSDate*) updateDate:(NSString*)dateStr forKey:(NSString*)key;
@end
