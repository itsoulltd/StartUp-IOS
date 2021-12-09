//
//  OperationProtocol.h
//  NGAppKit
//
//  Created by Towhid Islam on 6/8/17.
//  Copyright © 2018 ITSoulLab(http://itsoullab.com). All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ ProgressBlock)(double);

@protocol OperationProtocol <NSObject>

- (NSString *) identifier;
- (void) execute;

@end
