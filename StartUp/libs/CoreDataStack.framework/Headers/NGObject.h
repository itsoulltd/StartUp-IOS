//
//  DyanaObject.h
//  RequestSynchronizer
//
//  Created by Towhid Islam on 3/31/14.
//  Copyright (c) 2017 Next Generation Object Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGObjectProtocol.h"


/**
 *  trims a given NSString
 *
 *  @param val the NSString to be trimmed
 *
 *  @return trimmed NSString
 */
#define TRIM_STRING(val) [val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

/**
 *  checks if a NSString is valid
 *
 *  @param val a NSString to be checked
 *
 *  @return `YES` or `NO` based on the validity of the NSString
 */
#define IS_VALID_STRING(val) (val != nil) && [val length] != 0 && ([TRIM_STRING(val) length] != 0) && (![val isEqualToString:@"(null)"] || ![val isEqualToString:@"<null>"])

@interface NGObject : NSObject <NSCopying, NSCoding, NGObjectProtocol>
- (instancetype) initWithInfo:(NSDictionary*)info;
- (instancetype) initWithJSON:(NSData*)json;
@end
