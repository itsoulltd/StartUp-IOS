//
//  NSData+Hash.h
//  SeliseToolKitProject
//
//  Created by Towhid Islam on 10/19/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SeliseHash)

- (NSData*) selise_MD5;

- (NSData*) selise_SHA1;

- (NSData*) selise_SHA256;

@end
