//
//  DateManager.m
//  KitePhotoLocker
//
//  Created by Towhidul Islam on 3/6/17.
//  Copyright © 2017 Kite Games Studio. All rights reserved.
//

#import "DateManager.h"

#define yearSuffix @"Years"
#define  monthSuffix @"Months"
#define  weeksSuffix @"Weeks"
#define  daysSuffix @"Days"
#define  todaySuffix @"Today"
#define  yesterdaySuffix @"Yesterday"
#define  tomorrowSuffix @"Tomorrow"

@interface DateManager ()
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSCalendar *calender;
@end

@implementation DateManager

+ (instancetype)sharedInstance{
    static DateManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DateManager alloc] initWithParseFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    });
    return manager;
}

- (instancetype)initWithParseFormat:(NSString *)format{
    if (self = [super init]) {
        self.formatter = [[NSDateFormatter alloc] init];
        [self.formatter setDateFormat:format];
        self.calender = [NSCalendar currentCalendar];
    }
    return self;
}

- (NSString*) stringValue:(NSDate*)date{
    return [self.formatter stringFromDate:date];
}

- (NSDate*) dateValue:(NSString*)strDate{
    return [self.formatter dateFromString:strDate];
}

- (NSInteger) count:(NSDateComponents*)component type:(DateComponentType)type{
    if (type == Day) {
        return labs(component.day);
    }else if (type == Month){
        return labs(component.month);
    }else if (type == Week){
        return labs(component.weekOfYear);
    }else if (type == Hour){
        return labs(component.hour);
    }else if (type == Minute){
        return labs(component.minute);
    }else if (type == Secound){
        return labs(component.second);
    }else{
        return labs(component.year);
    }
}

- (NSInteger) count:(DateComponentType)type from:(NSDate*)from{
    NSDate *fromDate;
    NSDate *toDate;
    NSCalendarUnit unit = [self getUnit:type];
    [self.calender rangeOfUnit:unit startDate:&fromDate
                      interval:NULL forDate:from];
    [self.calender rangeOfUnit:unit startDate:&toDate
                      interval:NULL forDate:[NSDate date]];
    
    NSDateComponents *difference = [self.calender components:unit
                                                    fromDate:fromDate toDate:toDate options:0];
    
    return [self count:difference type:type];
}

- (NSInteger) count:(DateComponentType)type to:(NSDate*)to{
    NSDate *fromDate;
    NSDate *toDate;
    NSCalendarUnit unit = [self getUnit:type];
    [self.calender rangeOfUnit:unit startDate:&fromDate
                 interval:NULL forDate:[NSDate date]];
    [self.calender rangeOfUnit:unit startDate:&toDate
                 interval:NULL forDate:to];
    
    NSDateComponents *difference = [self.calender components:unit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [self count:difference type:type];
}

- (NSCalendarUnit) getUnit:(DateComponentType)type{
    NSCalendarUnit unit = 0;
    switch (type) {
        case Hour:
            unit = NSCalendarUnitHour;
            break;
        case Minute:
            unit = NSCalendarUnitMinute;
            break;
        case Secound:
            unit = NSCalendarUnitSecond;
            break;
        case Day:
            unit = NSCalendarUnitDay;
            break;
        case Month:
            unit = NSCalendarUnitMonth;
            break;
        case Week:
            unit = NSCalendarUnitWeekOfMonth;
            break;
        default:
            unit = NSCalendarUnitYear;
            break;
    }
    return unit;
}

- (NSString*) display:(NSDate*)date{
    NSDateComponents *component = [self.calender components:NSCalendarUnitDay|NSCalendarUnitWeekOfYear|NSCalendarUnitMonth|NSCalendarUnitYear
                                                   fromDate:date
                                                     toDate:[NSDate date]
                                                    options:NSCalendarMatchFirst];
    NSInteger days = labs(component.day);
    NSInteger months = labs(component.month);
    NSInteger weeks = labs(component.weekOfYear);
    NSInteger years = labs(component.year);
    NSString *strSuffix;
    if (years > 0){
        
        if(years == 1){
            strSuffix = @"Year";
        }
        else
            strSuffix = yearSuffix;
        return [NSString stringWithFormat:@"%ld %@",(long)years, strSuffix];
    }
    else if (months > 0){
        
        if(months == 1){
            strSuffix = @"Month";
        }
        else
            strSuffix = monthSuffix;
        return [NSString stringWithFormat:@"%ld %@",(long)months, strSuffix];
    }
    else if (weeks > 0){
        if(weeks == 1){
            strSuffix = @"Week";
        }
        else
            strSuffix = weeksSuffix;
        return [NSString stringWithFormat:@"%ld %@",(long)weeks, strSuffix];
    }
    else if (days > 0){
        if (days > 1){
            return [NSString stringWithFormat:@"%ld %@",(long)days, daysSuffix];
        }
        else{
            return (component.day < 0) ? tomorrowSuffix : yesterdaySuffix;
        }
    }
    else{
        return todaySuffix;
    }
}

- (NSDate*) tomorrow{
    return [self dateByAdding:Day value:1];
}

- (NSDate*) dayAfter:(NSInteger)days{
    return [self dateByAdding:Day value:days];
}

- (NSDate*) dateByAdding:(DateComponentType)type value:(NSInteger)val{
    NSDateComponents *component = [self component:type forValue:val];
    NSDate *today = [NSDate date];
    NSDate *result = [self.calender dateByAddingComponents:component toDate:today options:0];
    return result;
}

- (NSDateComponents*) component:(DateComponentType)type forValue:(NSInteger)val{
    NSDateComponents *component = [[NSDateComponents alloc] init];
    switch (type) {
        case Hour:
            component.hour = val;
            break;
        case Minute:
            component.minute = val;
            break;
        case Secound:
            component.second = val;
            break;
        case Day:
            component.day = val;
            break;
        case Month:
            component.month = val;
            break;
        case Week:
            component.weekOfMonth = val;
            break;
        default:
            component.year = val;
            break;
    }
    return component;
}

@end
