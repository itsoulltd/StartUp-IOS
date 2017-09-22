//
//  NSArray+FilterAndSorting.h
//  CoreDataStack
//
//  Created by Towhidul Islam on 12/15/16.
//  Copyright © 2016 Towhidul Islam. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kIsEqual @"=="
#define kIsEqualOrGreater @">="
#define kIsEqualOrLess @"<="
#define kIsGreater @">"
#define kIsLess @"<"
#define kNotEqual @"!="

@interface NSArray (FilterAndSorting)
- (NSArray*) filterUsingClause:(NSString*)clause value:(id)value;
- (NSArray*) filterWithType:(NSPredicateOperatorType)type keyPath:(NSString *)keyPath value:(id)value;
- (NSArray*) sortWhenAssecding:(BOOL)isYes;
- (NSArray *) sortForKeyPath:(NSString*)keyPath assecding:(BOOL)isYes;
- (NSArray *) sortForKeyPaths:(NSArray*)keyPaths assecding:(BOOL)isYes;
- (id) getMaxValue;
- (id) getMaxValueForKeyPath:(NSString*)keyPath;
- (id) getMinValue;
- (id) getMinValueForKeyPath:(NSString*)keyPath;
@end
