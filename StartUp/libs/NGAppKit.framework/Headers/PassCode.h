//
//  PassCode.h
//  NGAppKit
//
//  Created by Towhidul Islam on 3/1/17.
//  Copyright © 2017 Towhidul Islam. All rights reserved.
//

#import <CoreDataStack/CoreDataStack.h>

@interface PassCode : NGObject

- (instancetype) initWithKeychainIdentifier:(NSString*)identifier;
- (NSString*) getPin;
- (void) setPin:(NSString*)pin;
- (BOOL) matchPin:(NSString*)pin;
- (void) remove;

@end
