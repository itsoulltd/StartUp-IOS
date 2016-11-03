//
//  NSString+Hash.h
//  SeliseToolKitProject
//
//  Created by Towhid Islam on 10/19/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SeliseHash)

- (NSString*) selise_MD5;

- (NSString*) selise_SHA1;

- (NSString*) selise_SHA256;
@end
