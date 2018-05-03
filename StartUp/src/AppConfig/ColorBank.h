//
//  ColorListController.h
//  Laplazo
//
//  Created by Selise on 5/6/14.
//  Copyright (c) 2014 Towhidul Islam (towhidul.islam@selise.ch). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct{
    float Red, Green, Blue;
} RGB;

@interface ColorBank : NSObject
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor*) colorForkey:(NSString*)key;
+ (RGB) rgbComponentsForKey:(NSString*)key;
+ (RGB) rgbComponentsForHexString:(NSString *)hexString;
@end
