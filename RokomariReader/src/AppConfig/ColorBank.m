//
//  ColorListController.m
//  Laplazo
//
//  Created by Selise on 5/6/14.
//  Copyright (c) 2014 Towhidul Islam (towhidul.islam@selise.ch). All rights reserved.
//

#import "ColorBank.h"
@import CoreDataStack;

@implementation ColorBank

- (id)init{
    
    if (self = [super init]) {
        //
    }
    
    return self;
}

+ (PropertyList*) manager{
    
    static PropertyList *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[PropertyList alloc] initWithFileName:@"ColorList" directoryType:NSDocumentDirectory dictionary:YES];
    });
    return _manager;
}

//linked from http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    
    if (!hexString || [hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length <= 0) {
        return nil;
    }
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)colorForkey:(NSString *)key{
    NSString *hexString = [[ColorBank manager] itemForKey:key];
    if (hexString) {
        return [ColorBank colorFromHexString:hexString];
    }else{
        return [UIColor blackColor];
    }
}

+ (RGB) rgbComponentsForHexString:(NSString *)hexString{
    
    if (!hexString || [hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length <= 0) {
        RGB components = {.Red=0, .Green=0, .Blue=0};
        return components;
    }
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    
    RGB components = {.Red = ((rgbValue & 0xFF0000) >> 16), .Green = ((rgbValue & 0xFF00) >> 8), .Blue = ((rgbValue & 0xFF))};
    return components;
}

+ (RGB)rgbComponentsForKey:(NSString *)key{
    
    if (!key || [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length <= 0) {
        RGB components = {.Red=0, .Green=0, .Blue=0};
        return components;
    }
    
    NSString *hexString = [[ColorBank manager] itemForKey:key];
    return [ColorBank rgbComponentsForHexString:hexString];
}

@end
