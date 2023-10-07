//
//  AsynchOperation.h
//  NGAppKit
//
//  Created by Towhid Islam on 6/7/17.
//  Copyright © 2018 ITSoulLab(http://itsoullab.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OperationProtocol.h"

@interface AsynchOperation : NSOperation <OperationProtocol>

- (void) execute;
- (void) finish;

@end
