//
//  DateManager.h
//  NGAppKit
//
//  Created by Towhidul Islam on 3/6/17.
//  Copyright © 2018 ITSoulLab(http://itsoullab.com). All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Hour,
    Minute,
    Secound,
    Day,
    Week,
    Month,
    Year
} DateComponentType;

@interface DateManager : NSObject

+ (instancetype) sharedInstance;

- (instancetype) initWithParseFormat:(NSString*)format;
- (instancetype)initWithStyle:(NSDateFormatterStyle)format;

- (void)switchToUTC;
- (void)switchToLocal;

- (NSString*) stringValue:(NSDate*)date;
- (NSDate*) dateValue:(NSString*)strDate;
- (NSString*) display:(NSDate*)date;
- (NSDate*) tomorrow;
- (NSDate *) now;
- (NSDate*) dayAfter:(NSInteger)days;
- (NSDate*) dateByAdding:(DateComponentType)type value:(NSInteger)val;
- (NSInteger) count:(DateComponentType)type from:(NSDate*)from;
- (NSInteger) count:(DateComponentType)type to:(NSDate*)to;
@end
