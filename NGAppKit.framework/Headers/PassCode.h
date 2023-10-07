//
//  PassCode.h
//  NGAppKit
//
//  Created by Towhidul Islam on 3/1/17.
//  Copyright © 2018 ITSoulLab(http://itsoullab.com). All rights reserved.
//

#import <CoreDataStack/CoreDataStack.h>

@interface PassCode : NGObject

- (instancetype) initWithKeychainIdentifier:(NSString*)identifier;
- (NSString*) getPin;
- (void) setPin:(NSString*)pin;
- (BOOL) matchPin:(NSString*)pin;
- (void) remove;

@end
