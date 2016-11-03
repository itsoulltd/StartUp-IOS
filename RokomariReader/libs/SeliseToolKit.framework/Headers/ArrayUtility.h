//
//  ArraySortFilterExample.h
//  GoogleAnalyticSample
//
//  Created by Selise on 2/13/14.
//  Copyright (c) 2014 Selise. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kIsEqual @"=="
#define kIsEqualOrGreater @">="
#define kIsEqualOrLess @"<="
#define kIsGreater @">"
#define kIsLess @"<"
#define kNotEqual @"!="

@interface ArrayUtility : NSObject

- (NSArray*) filterArray:(NSArray*)data clause:(NSString*)clause value:(id)value;
- (NSArray*) filterArray:(NSArray*)data type:(NSPredicateOperatorType)type keyPath:(NSString *)keyPath value:(id)value;
- (NSArray*) sortArray:(NSArray*)data assecding:(BOOL)isYes;
- (NSArray *) sortArray:(NSArray *)data keyPath:(NSString*)keyPath assecding:(BOOL)isYes;
- (NSArray *) sortArray:(NSArray *)data keyPaths:(NSArray*)keyPaths assecding:(BOOL)isYes;
- (id) getMaxValue:(NSArray*)data;
- (id) getMaxValue:(NSArray *)data keyPath:(NSString*)keyPath;
- (id) getMinValue:(NSArray*)data;
- (id) getMinValue:(NSArray *)data keyPath:(NSString*)keyPath;
@end
