//
//  StackArray.h
//  ArrayUtilSample
//
//  Created by m.towhid.islam@gmail.com on 3/27/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject <NSCopying, NSCoding>
- (void) push:(id)item;
- (id) pop;
- (void) printStack;
- (BOOL) isEmpty;
@end
